# Base image with Python 3.11 (slim to keep image size smaller)
FROM python:3.11-slim

# System packages required by Ultralytics/YOLO, PIL, and general tooling
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Application workspace
WORKDIR /app

# Install Python dependencies first to leverage Docker layer caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code (only this layer rebuilds on code changes)
COPY ./app /app

# Start FastAPI via Uvicorn
# Assumes /app/main.py exposes `app = FastAPI()`
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8001"]
