from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import JSONResponse
from ultralytics import YOLO
from PIL import Image
from pathlib import Path
from datetime import datetime
from crud import save_prediction
from database import init_db
import uuid
import io

# FastAPI backend for the "smartsort" waste-classification project.
# Provides endpoints for: prediction, saving agreed results,
# saving user corrections, and storing samples for manual labeling.

app = FastAPI()

# Load the trained YOLOv8 model (weights are stored under models/).
model = YOLO("models/smartsort.pt")

# Initialize database (tables/connection) so each submission can be logged.
init_db()

def generate_filenames(original_name: str):
    """
    Generate unique, collision-resistant filenames for both the image and its label.

    Rationale:
      - Avoid filename clashes across multiple uploads
      - Keep a traceable link between the image and the corresponding label

    Returns:
        tuple[str, str]: (picture_filename, label_filename)
    """
    ext = Path(original_name).suffix or ".jpg"
    stem = Path(original_name).stem
    unique = f"{datetime.now().strftime('%Y%m%d%H%M%S')}_{uuid.uuid4().hex}"
    picture_filename = f"{unique}_{stem}{ext}"
    label_filename = picture_filename.replace(ext, ".txt")
    return picture_filename, label_filename

# 1. Prediction without storing
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """
    1) Run inference and return predictions only (no persistence).

    Steps:
      - Read the uploaded image into memory
      - Run the YOLO model and obtain the first result list (single image)
      - Return a simple list of {class, confidence} for each detected box
    """
    content = await file.read()
    image = Image.open(io.BytesIO(content))
    results = model(image)
    boxes = results[0].boxes

    predictions = [{
        "class": model.names[int(box.cls[0])],
        "confidence": round(float(box.conf[0]), 3)
    } for box in boxes]

    return JSONResponse(content={"predictions": predictions})

# 2. Storage after “Agree” (classification is correct)
@app.post("/submit/agreed")
async def submit_agreed(file: UploadFile = File(...)):
    """
    2) Persist image + auto-generated labels when the user agrees with the model.

    Workflow:
      - Re-run inference on the uploaded file
      - Save the raw image to data/correct/pictures
      - Save a YOLO-style label file to data/correct/labels
      - Log (filenames, label, confidence) into the database via save_prediction

    Note:
      - Label lines are written as "class cx cy w h conf".
      - The xywh values come from YOLOv8's tensor; depending on configuration
        these may be pixel units rather than normalized (0..1). Adjust if needed.
    """
    content = await file.read()
    image = Image.open(io.BytesIO(content))
    results = model(image)
    boxes = results[0].boxes

    picture_filename, label_filename = generate_filenames(file.filename)
    pic_path = Path("data/correct/pictures") / picture_filename
    label_path = Path("data/correct/labels") / label_filename
    pic_path.parent.mkdir(parents=True, exist_ok=True)
    label_path.parent.mkdir(parents=True, exist_ok=True)

    # Persist the original upload as-is.
    with open(pic_path, "wb") as f:
        f.write(content)

    # Write labels for all detected boxes; create an empty file if none.
    if boxes and len(boxes) > 0:
        with open(label_path, "w") as f:
            for box in boxes:
                cls_id = int(box.cls[0])
                conf = float(box.conf[0])
                xywh = box.xywh[0].tolist()
                xywh_str = " ".join([str(round(x, 6)) for x in xywh])
                f.write(f"{cls_id} {xywh_str} {round(conf, 6)}\n")
    else:
        with open(label_path, "w") as f:
            f.write("")

    # For DB logging, record the first detection as the primary label.
    if boxes and len(boxes) > 0:
        first_box = boxes[0]
        cls_id = int(first_box.cls[0])
        conf = float(first_box.conf[0])
        label = model.names[cls_id]
    else:
        label = "unknown"
        conf = 0.0

    save_prediction(picture_filename, label_filename, label, conf, correction=False, corrected_class=None)

    return JSONResponse(content={"status": "saved", "label": label, "confidence": conf})

# 3. Storage when corrected by user (“Disagree”)
@app.post("/submit/correction")
async def submit_correction(
    file: UploadFile = File(...),
    corrected_class: str = Form(...)
):
    """
    3) Persist image + corrected label when the user disagrees with the model.

    Workflow:
      - Run the model to attempt reusing a reasonable bounding box
      - If no box is available, fall back to a centered dummy box
      - Map the provided corrected_class (string) to a numeric class ID
      - Save to data/corrections (for future retraining)
      - Log the correction in the database
    """
    content = await file.read()
    image = Image.open(io.BytesIO(content))
    results = model(image)
    boxes = results[0].boxes

    picture_filename, label_filename = generate_filenames(file.filename)
    pic_path = Path("data/corrections/pictures") / picture_filename
    label_path = Path("data/corrections/labels") / label_filename
    pic_path.parent.mkdir(parents=True, exist_ok=True)
    label_path.parent.mkdir(parents=True, exist_ok=True)

    # Store the original image.
    with open(pic_path, "wb") as f:
        f.write(content)

    # Default values
    confidence = 0.0
    label = "unknown"

    # Reuse the first predicted box if available; otherwise, write a default box
    # to indicate "needs attention".
    if boxes and len(boxes) > 0:
        box = boxes[0]
        xywh = box.xywh[0].tolist()
        confidence = float(box.conf[0])
        label = model.names[int(box.cls[0])]
    else:
        xywh = [0.5, 0.5, 0.2, 0.2] # (cx, cy, w, h) fallback
        confidence = 1.0

    # Project class mapping (string -> numeric ID).
    class_ids = {"organic": 0, "recyclable": 1, "general": 2}
    cls_id = class_ids.get(corrected_class.lower(), -1)

    # Write a single label line only if the class is recognized.
    with open(label_path, "w") as f:
        if cls_id >= 0:
            xywh_str = " ".join([str(round(x, 6)) for x in xywh])
            f.write(f"{cls_id} {xywh_str} {round(confidence, 6)}\n")

    save_prediction(
    picture_filename,
    label_filename,
    predicted_class=label,                # <- YOLO-prediction
    confidence=confidence,
    correction=True,
    corrected_class=corrected_class.lower()  # <- User-correction
)

    return JSONResponse(content={"status": "correction_saved","predicted": label, "corrected": corrected_class, "confidence": confidence})

# 4. Storage when no prediction is available (“Unknown”)
@app.post("/submit/manual")
async def submit_manual(file: UploadFile = File(...)):
    """
    4) Store images that had no reliable prediction (manual labeling queue).

    Behavior:
      - Save the image under data/manual_labeling/pictures
      - Insert a DB record with label="unknown" and confidence=0.0
      - No label file is created at this stage
    """
    content = await file.read()
    picture_filename, _ = generate_filenames(file.filename)
    pic_path = Path("data/manual_labeling/pictures") / picture_filename
    pic_path.parent.mkdir(parents=True, exist_ok=True)

    with open(pic_path, "wb") as f:
        f.write(content)
    save_prediction(picture_filename, None, "unknown", 0.0, correction=False)

    return JSONResponse(content={"status": "manual_saved", "filename": picture_filename})