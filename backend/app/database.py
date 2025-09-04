from sqlalchemy import create_engine, Column, Integer, String, Float, DateTime, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from datetime import datetime
import os

# DB URL from environment (for deployments) or a local default.
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@db:5432/smartsortdb")

# Engine + session factory (scoped per request in the API layer).
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)

# Declarative base for ORM models.
Base = declarative_base()

# Prediction-Tabelle
class Prediction(Base):
    """Prediction records: filenames, class, confidence, and timestamp."""
    __tablename__ = "predictions"

    id = Column(Integer, primary_key=True, index=True)
    picture_filename = Column(String)
    label_filename = Column(String, nullable=True)
    predicted_class = Column(String)
    confidence = Column(Float)
    timestamp = Column(DateTime, default=datetime.utcnow)
    corrected_class = Column(String, nullable=True)
    correction = Column(Boolean, default=False)

def init_db():
    """Create tables if they do not exist."""
    Base.metadata.create_all(bind=engine)
