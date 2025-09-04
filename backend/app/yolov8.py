from ultralytics import YOLO
from pathlib import Path

# Load the model once at import to avoid repeated disk I/O per call.
# Path is relative to the project root (adjust if packaging/layout changes).
model_path = Path("models/smartsort.pt")
model = YOLO(str(model_path))

# Project category names. This model requires explicit names,
# and the order must match the training class index mapping.
CATEGORIES = ['organic', 'recyclable', 'general']

def predict_image(image_path: str) -> dict:
    """
    Run classification on a single image and return the top-1 result.

    Assumptions:
      - The YOLO model is used in *classification* mode for this endpoint,
        so `results[0].probs` is available.
      - `CATEGORIES` aligns with the model's class index order.

    Args:
        image_path (str): Filesystem path to the input image.

    Returns:
        dict: {
            "class": <str>,        # predicted category name
            "confidence": <float>  # probability for the top-1 class in [0, 1]
        }
    """
    # Run inference; for a single image, YOLO returns a list with one result.
    results = model(image_path)
    
    # Obtain the index of the most probable class from the probability vector.
    top_result = results[0].probs.top1
    class_id = int(top_result)
    # Translate the class index into a human-readable label.
    class_name = CATEGORIES[class_id]
    # Extract the confidence score for the chosen class.
    confidence = float(results[0].probs.data[class_id])

    # Return a compact, JSON-friendly structure.
    return {
        "class": class_name,
        "confidence": round(confidence, 4)
    }
