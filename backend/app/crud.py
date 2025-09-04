from database import SessionLocal, Prediction

# CRUD helper for persisting model results to the database.

def save_prediction(pic_name, label_name, predicted_class, confidence, correction=False, corrected_class=None):
    """Insert a single prediction row (image, optional label, class, confidence, correction flag, corrected_class)."""
    db = SessionLocal()
    prediction = Prediction(
        picture_filename=pic_name,
        label_filename=label_name,
        predicted_class=predicted_class,
        confidence=confidence,
        correction=correction,
        corrected_class=corrected_class
    )
    db.add(prediction)
    db.commit()
    db.close()
