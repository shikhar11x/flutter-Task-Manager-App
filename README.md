<div align="center">

# ✅ TaskFlow — Flutter Task Manager App

### *Stay focused. Stay productive. Never miss a task.*

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth_%26_Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge)

</div>

---

## 📱 Screenshots

<table>
  <tr>
    <td align="center"><b>Sign Up</b></td>
    <td align="center"><b>Login</b></td>
    <td align="center"><b>Home</b></td>
    <td align="center"><b>Add Task</b></td>
  </tr>
  <tr>
    <td><img src="screenshots/signuppage.jpeg" width="180"/></td>
    <td><img src="screenshots/Login.jpeg" width="180"/></td>
    <td><img src="screenshots/Homepage.jpeg" width="180"/></td>
    <td><img src="screenshots/addtaskpage.jpeg" width="180"/></td>
  </tr>
</table>

---

## 🚀 Features

- 🔐 **Firebase Authentication** — Sign Up, Login & Logout
- 📋 **Task CRUD** — Add, Edit, Delete & Mark tasks as Done
- 📊 **Dashboard Stats** — Total, Done & Pending task counters with progress bar
- 💬 **Daily Motivation** — Fresh motivational quote fetched from REST API with one-tap refresh
- 🎨 **Glassmorphism UI** — Frosted glass cards, smooth gradients, animated checkbox
- ⚡ **Real-time Sync** — Powered by Cloud Firestore streams
- ♻️ **Reusable Widgets** — Fully componentized clean widget architecture

---

## 🏗️ Folder Structure

```
lib/
├── models/
│   └── task.dart                # Task data model
├── screens/
│   ├── login_screen.dart        # Login UI
│   ├── signup_screen.dart       # Sign Up UI
│   ├── home_screen.dart         # Dashboard with task list
│   ├── add_task_screen.dart     # Add new task
│   └── edit_task_screen.dart    # Edit existing task
├── services/
│   ├── auth_service.dart        # Firebase Auth logic
│   ├── firestore_service.dart   # Firestore CRUD operations
│   └── quote_service.dart       # REST API — DummyJSON Quotes
├── widgets/                     # Reusable UI components
│   ├── app_background.dart
│   ├── date_picker_field.dart
│   ├── delete_dialog.dart
│   ├── glass_container.dart
│   ├── glass_text_field.dart
│   ├── gradient_button.dart
│   ├── logout_button.dart
│   ├── quote_card.dart
│   ├── stat_card.dart
│   ├── task_card.dart
│   └── user_avatar.dart
└── main.dart
```

---

## ⚙️ Setup & Installation

### 🔧 Step 1 — Clone the Repository

```bash
git clone https://github.com/shikhar11x/flutter-Task-Manager-App.git
cd flutter-Task-Manager-App
```

### 📦 Step 2 — Install Dependencies

```bash
flutter pub get
```

### 🔥 Step 3 — Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project
2. Enable **Email/Password** under Authentication → Sign-in methods
3. Create a **Cloud Firestore** database (start in test mode)
4. Add an **Android App** to your Firebase project
   - Use your app's package name (e.g., `com.example.task_manager_app`)
   - Download `google-services.json` and place it in `android/app/`

**Firestore Security Rules:**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### ▶️ Step 4 — Run the App

```bash
flutter run
```

To build a release APK:

```bash
flutter build apk --release
```

APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter + Dart |
| Authentication | Firebase Authentication |
| Database | Cloud Firestore |
| REST API | DummyJSON Quotes API |
| State Management | setState + StreamBuilder |
| Platform | Android & iOS |

---

## 🌐 API Used

**Motivational Quote API**

```
GET https://dummyjson.com/quotes/random
```

Response used:

```json
{
  "quote": "Stay focused and never give up!",
  "author": "Unknown"
}
```

---

## 🗄️ Firestore Data Structure

```
tasks (collection)
└── {taskId} (document)
    ├── title        : String
    ├── description  : String
    ├── date         : String
    ├── isCompleted  : Boolean
    └── userId       : String
```

---

## 📁 APK Download

📥 [Download Latest APK](https://github.com/shikhar11x/flutter-Task-Manager-App/releases/tag/v1.0)

---

## 🎥 Demo Video

🎬 [Watch Demo on YouTube / Drive](https://your-demo-link-here)

---

## 👨‍💻 Author

**Shikhar**

[![GitHub](https://img.shields.io/badge/GitHub-shikhar11x-181717?style=flat&logo=github)](https://github.com/shikhar11x)
[![Email](https://img.shields.io/badge/Email-shikhar11x@gmail.com-D14836?style=flat&logo=gmail&logoColor=white)](mailto:shikhar11x@gmail.com)

---

<div align="center">

Made with ❤️ using Flutter & Firebase

</div>
