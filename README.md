# 🤖 Facify - Real-Time Face Detection App  

**Facify** is a powerful **AI-powered Flutter app** that uses **Google's ML Kit** to detect human faces in real-time with **high accuracy and performance**. Designed for seamless user experience, Facify combines intelligent vision technology with a modern UI to provide fast and reliable face detection on mobile devices.

---

## 📽️ Demo Video

[![Watch Demo](https://img.icons8.com/fluency/96/video-playlist.png)](https://github.com/user-attachments/assets/05073b3d-c30d-42d5-8c05-8df79308e2cd)

> 🔗 Click the image above to watch a short demo of **Facify** in action (hosted on GitHub).

---

## 🧠 How It Works

Facify uses **on-device machine learning** to detect facial features through the camera in real time. It relies on **Google ML Kit’s Face Detection API**, which leverages advanced AI models for:

- Face landmark detection (eyes, nose, mouth)  
- Head position (roll, pitch, yaw)  
- Real-time tracking  
- Eye open/closed probability  
- Smile probability  

---

## 📱 Features

1. **Real-Time Face Detection**  
   Detects faces instantly from the live camera feed with high precision.

2. **AI-Powered Accuracy**  
   Utilizes Google ML Kit’s pre-trained models optimized for mobile devices.

3. **Multiple Face Tracking**  
   Capable of detecting and tracking multiple faces simultaneously.

4. **Smooth Camera Preview**  
   Lag-free, real-time camera feed using `camera` plugin and custom painter overlays.

5. **User-Friendly UI**  
   Clean interface with animated transitions and feedback when faces are detected.

---

## 💻 Technologies Used

- **Flutter**: Cross-platform mobile app development  
- **Dart**: Programming language used for logic and UI  
- **Google ML Kit**: On-device face detection API  
- **Camera**: For accessing and streaming real-time camera feed  
- **CustomPainter**: For drawing face bounding boxes  
- **Provider / GetX** *(optional)*: For managing state (if used)

---

## ⚙️ Requirements

- Android device with Camera permissions  
- Flutter SDK & Android Studio installed  
- Internet not required (on-device ML runs offline)

---

## 🌐 AI Service Used

This app uses **[Google ML Kit - Face Detection API](https://developers.google.com/ml-kit/vision/face-detection)** which provides:

- Fast, on-device performance  
- High accuracy even in challenging lighting  
- Landmark and classification features

---

## 🚀 Getting Started

To run the project locally:

```bash
git clone https://github.com/Taha170717/InternIntelligence_Facify.git
cd InternIntelligence_Facify
flutter pub get
flutter run
