# Gingivitis Risk Assessment Tool
<img src="screenshots/logo.png" width="80"/>
A mobile application built with **Flutter** and **Firebase** to assist dental professionals in assessing, storing, and managing patients' gingivitis risk. This tool simplifies clinical decision-making by providing structured assessments and automated risk evaluations.

---

## 📱 Features

- 🔐 **Authentication**
  - Sign Up / Sign In
  - Forgot Password support using Firebase Authentication

- 📄 **Multi-Tabbed Risk Assessment Form**
  - Patient Information
  - Plaque Index
  - Oral Hygiene Habits
  - Bleeding Index
  - Gingival Index
  - Teeth Probing
  - Stress Assessment

- 📊 **Automated Risk Evaluation**
  - Risk categorized as: **Low**, **Moderate**, or **High**
  - A tailored **treatment plan** is generated based on the risk category

- 🗂️ **Patient Record Management**
  - View all patient records with risk level and details
  - Edit or update existing assessments

- 🔍 **Search Functionality**
  - Search patients by **name** or **phone number**

- ☁️ **Cloud Storage**
  - Firebase Firestore used to store patient data securely
  - Firebase Authentication for user account management

---

## 📸 Screenshots

<p align="center">
  <img src="images/in.jpg" width="200"/>
  <img src="images/up.jpg" width="200"/>
  <img src="images/record.jpg" width="200"/>
  <img src="images/form.jpg" width="200"/>
  
</p>

---

## 🧪 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend/Cloud:** Firebase (Authentication, Firestore)
- **State Management:** Provider 
- **Platform:** Android & iOS

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK
- Android Studio / VS Code
- Firebase Project (configured with Android/iOS app)

### Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/gingivitis-risk-tool.git
   cd gingivitis-risk-tool
   ```
2. **Install dependencies:**
  ```bash
  flutter pub get
```

3. **Configure Firebase:**
  - Add your google-services.json (Android) in android/app/
  - Add your GoogleService-Info.plist (iOS) in ios/Runner/
  - Enable Authentication and Firestore in Firebase Console

4. **Run the app:**
  ```bash
  flutter run
```
## 📁 Project Structure
```bash
  .
├── firebase_options.dart
├── main.dart
├── components/
│   ├── bleedingcell.dart
│   ├── buttonsign.dart
│   ├── profilecard.dart
│   ├── square_tile.dart
│   └── textfield.dart
├── forms/
│   ├── bleedingindex.dart
│   ├── gingivalpage.dart
│   ├── mouthindex.dart
│   ├── ohispage.dart
│   ├── personalinfo.dart
│   ├── probingpage.dart
│   └── stresscallcompliance.dart
├── images/
│   ├── a.png
│   ├── dental_logo.png
│   ├── g.png
│   └── logo.png
├── pages/
│   ├── authpage.dart
│   ├── homepage.dart
│   ├── loginorregisterpage.dart
│   ├── loginpage.dart
│   ├── Patientrecordpage.dart
│   ├── reportpage.dart
│   ├── resetpass.dart
│   └── signuppage.dart
└── utils/
    ├── bleedingindexdata.dart
    ├── bottomnavigator.dart
    ├── gingivalindexdata.dart
    ├── ohisdata.dart
    ├── personalinfodata.dart
    ├── plaqueindexdata.dart
    ├── probingdata.dart
    ├── riskscore.dart
    └── stresscallandcomplaincedata.dart

```
## 📝 License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).

You are free to:

- Use
- Modify
- Distribute
- Share

**Under the following terms**:

- 📖 **Source Code Disclosure**: If you distribute the software or a modified version, you must make the source code available.
- 🛠️ **Same License**: Derivatives must also be licensed under GPLv3.
- 📝 **License Notice**: You must include this license in all copies or substantial portions of the software.

**No Warranty** is provided with this software.

For full license text, see: [https://www.gnu.org/licenses/gpl-3.0.html](https://www.gnu.org/licenses/gpl-3.0.html)
