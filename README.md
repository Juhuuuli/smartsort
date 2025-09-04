# SmartSort  

**SmartSort** is a mobile application built with **Flutter** and powered by **YOLOv8 AI** to help users correctly sort waste into **recyclable**, **organic**, and **general waste**.  

By combining **AI-based waste recognition** with a clean and intuitive user interface, SmartSort empowers people to make environmentally conscious decisions every day.  

---

## ✨ Features  

- Select multiple images of waste from your gallery or camera  
- Real-time AI classification using YOLOv8  
- Categorization into:
  - **Recyclable**
  - **Organic**
  - **General waste**  
- Clean and user-friendly Flutter UI  
- Full backend running in **Docker** with **FastAPI** and **PostgreSQL**  

---

## 🌍 Motivation  

In many cities — including Bangkok — a large portion of waste is incorrectly disposed of.  
This results in:  

- Environmental pollution  
- Inefficient recycling processes  
- Missed opportunities for sustainable waste management  

**SmartSort** helps users make better waste-sorting decisions by providing **instant AI-powered classification** and storing results for future analysis and retraining.  

---

## 🧠 AI Model  

We use the **YOLOv8 object detection framework** for image recognition.  
The model is trained on three categories of waste:  

- **Organic**  
- **Recyclable**  
- **General**  

The trained model is deployed in the backend and accessed through FastAPI.  

---

## 🖥️ System Architecture  

```
Frontend (Flutter App)
        |
        v
Backend (FastAPI + YOLOv8) -----> PostgreSQL (data storage)
        |
        +--> Dockerized (app, db, backup service)
```

---

## 🚀 Getting Started  

### 1. Prerequisites  

- [Flutter SDK](https://docs.flutter.dev/get-started/install)  
- Dart SDK  
- Android Studio or VS Code with Flutter plugin  
- Android/iOS device or emulator  
- [Docker & Docker Compose](https://docs.docker.com/get-docker/)  
- Conda (for training YOLOv8 models)  

---

### 2. Clone Repository  

```bash
git clone https://github.com/yourusername/garbage_classification.git
```

---

## 3. Backend Setup (FastAPI + PostgreSQL in Docker)  

The backend runs inside **Docker** and includes three main services:  
- **FastAPI application** (serves the YOLOv8 model and API)  
- **PostgreSQL database** (stores predictions and corrections)  
- **Backup service** (manual and scheduled backups of the database)  

---

### Navigate into the backend folder  

```bash
cd backend
```

---

### Start containers (app + db)  

Build and start the FastAPI backend together with the PostgreSQL database:  

```bash
docker compose up --build app db
```

This will:  
- Start the FastAPI server inside a Docker container  
- Start the PostgreSQL database container  
- Link them together so the app can write results into the database  

---

### Backup system  

The backend includes a built-in backup system for the PostgreSQL database.  

- **Run a one-time backup:**  

```bash
docker compose run --rm backup-once
```

- **Enable scheduled backups (cron):**  

```bash
docker compose up -d backup-cron
```

With scheduled backups enabled, the database is backed up automatically at regular intervals.  
One-time backups can be run manually whenever needed.  

---

## 4. Frontend Setup (Flutter App)  

Navigate into the Flutter app:  

```bash
cd frontend/smartsort_app
flutter pub get
flutter run
```

---

## 🏋️ YOLOv8 Training  

### Environment Setup  

```bash
# Create new conda environment
conda create -n yolov8-env python=3.10 -y
conda activate yolov8-env

# Install YOLOv8
pip install ultralytics

# (Optional) Jupyter support
pip install notebook

# Verify installation
yolo --version
```

### Training Command  

```bash
# Train YOLOv8 model on custom dataset
yolo task=detect mode=train model=yolov8n.pt data="yourpath/dataset/data.yaml" epochs=50 imgsz=640 name=smartsort
```

---

## 📝 Label Studio (Annotation)  

### Installation & Start  

```bash
# Install Label Studio
pip install label-studio

# Activate YOLO environment
conda activate yolov8-env

# Start Label Studio
label-studio start
```

### Usage  

1. Open [http://localhost:8080](http://localhost:8080)  
2. Create a project (e.g., *Smartsort Annotation*)  
3. Define classes: **organic**, **recyclable**, **general**  
4. Import dataset images  
5. Annotate images with bounding boxes  
6. Export annotations in **YOLO format**  
7. Save them to your dataset directory (e.g., `yourpath/dataset/labels/`)  

---

## 🐳 Docker Overview  

The project uses **Docker Compose** with multiple services:  

- **app** → FastAPI + YOLOv8 inference  
- **db** → PostgreSQL database  
- **backup-once** → Manual backup runner  
- **backup-cron** → Automatic scheduled backups  

### Example startup  

```bash
# Build and run everything
docker compose up --build

# Only run app + db without backup
docker compose up --build app db
```

---

## 💾 Database  

The PostgreSQL database logs **every detection** with:  

- `timestamp`  
- `predicted_class`  
- `confidence`  
- `bounding box info`  
- `image filename` and `label filename`  
- `correction_class` (if user corrects prediction)  

This allows future **model retraining** and **waste analytics**.  

---

## 📊 Backup Strategy  

SmartSort includes an integrated backup service.  

- **One-time backup:**  

```bash
docker compose run --rm backup-once
```

- **Scheduled backups:**  

```bash
docker compose up -d backup-cron
```

Backups ensure that no classification data is lost and provide a history for future retraining.  

---


## 🤝 Contributing  

Contributions are welcome! Please open issues or pull requests to improve SmartSort.  

---

## 📜 License  

MIT License © 2025 SmartSort Team  
