# EduMate - Educational Learning Platform

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.8.1-blue?style=for-the-badge&logo=flutter" alt="Flutter Version">
  <img src="https://img.shields.io/badge/Dart-3.8.1-blue?style=for-the-badge&logo=dart" alt="Dart Version">
  <img src="https://img.shields.io/badge/Firebase-Auth-orange?style=for-the-badge&logo=firebase" alt="Firebase Auth">
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-green?style=for-the-badge" alt="Architecture">
</div>

## 📱 Overview

EduMate is a modern, feature-rich educational learning platform built with Flutter. It provides users with access to a wide variety of courses, interactive learning experiences, and personalized learning paths. The app features a clean, responsive design that adapts to different screen sizes and supports both light and dark themes.

## ✨ Features

### 🔐 Authentication & User Management
- **Secure Authentication**: Firebase Authentication integration for user registration and login
- **User Profiles**: Personalized user profiles with display names and email management
- **Session Management**: Automatic session persistence and secure logout functionality
- **Form Validation**: Comprehensive input validation for registration and login forms

### 📚 Course Management
- **Course Discovery**: Browse and search through a comprehensive catalog of courses
- **Course Categories**: Organized course categories for easy navigation
- **Course Details**: Detailed course information including:
  - Course title, description, and category
  - Instructor information (name and title)
  - Course duration and rating
  - Course content outline
  - Course thumbnail images

### 🎥 Interactive Learning
- **YouTube Video Integration**: Embedded YouTube video player for course content
- **Video Controls**: Full video player controls with play, pause, and seek functionality
- **Responsive Video Player**: Optimized video viewing experience across different devices

### 🎨 User Experience
- **Responsive Design**: Adaptive UI that works seamlessly on mobile, tablet, and desktop
- **Theme Support**: Light and dark theme modes with automatic switching
- **Smooth Animations**: Engaging loading animations and transitions
- **Toast Notifications**: User-friendly success and error notifications
- **Skeleton Loading**: Elegant loading states with skeleton animations

### 🔍 Search & Navigation
- **Course Search**: Real-time search functionality to find specific courses
- **Bottom Navigation**: Intuitive navigation between different app sections
- **My Courses**: Dedicated section for enrolled courses
- **Profile Management**: Easy access to user profile and settings

## 🏗️ Architecture

EduMate follows Clean Architecture principles with a well-organized folder structure:

```
lib/
├── core/                    # Core functionality
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── helper/             # Utility helpers
│   ├── network/            # Network layer
│   ├── Responsive/         # Responsive design utilities
│   ├── routing/            # App routing
│   ├── theme/              # Theme management
│   └── widgets/            # Shared widgets
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data layer
│   │   └── presentation/  # UI layer
│   ├── courses/           # Courses feature
│   │   ├── data/          # Data layer
│   │   └── presentation/  # UI layer
│   └── splash/            # Splash screen
└── main.dart              # App entry point
```

### 🎯 State Management
- **BLoC Pattern**: Uses Flutter BLoC for state management
- **Cubit Implementation**: Lightweight state management with Cubits
- **Dependency Injection**: GetIt for service locator pattern
- **Injectable**: Code generation for dependency injection

## 🛠️ Technology Stack

### Core Technologies
- **Flutter**: 3.8.1 - Cross-platform UI framework
- **Dart**: 3.8.1 - Programming language
- **Firebase**: Authentication and backend services

### Key Dependencies
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **go_router**: Navigation and routing
- **firebase_auth**: Firebase authentication
- **youtube_player_flutter**: YouTube video integration
- **dio**: HTTP client for API calls
- **cherry_toast**: Toast notifications
- **skeletonizer**: Loading skeleton animations
- **connectivity_plus**: Network connectivity monitoring
- **url_launcher**: External URL handling

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Abdullah-T3/edu_mate
   cd edu_mate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication with Email/Password
   - Download `google-services.json` for Android
   - Download `GoogleService-Info.plist` for iOS
   - Place the files in their respective platform directories

4. **Generate dependency injection code**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Platform Setup

#### Android
- Minimum SDK: 21
- Target SDK: 33
- Place `google-services.json` in `android/app/`

## 📱 App Screens

### Authentication Screens
- **Splash Screen**: App loading and authentication check
- **Login Screen**: User login with email and password
- **Register Screen**: New user registration

### Main App Screens
- **Home Screen**: Course discovery and search
- **Course Details**: Detailed course information with video player
- **My Courses**: Enrolled courses management
- **Profile Screen**: User profile and settings

## 🎨 UI/UX Features

### Design System
- **Material Design 3**: Modern design principles
- **Responsive Layout**: Adaptive design for all screen sizes
- **Accessibility**: WCAG compliant design elements

### Interactive Elements
- **Gradient Buttons**: Beautiful gradient-styled action buttons
- **Skeleton Loading**: Smooth loading animations
- **Toast Notifications**: User feedback system
- **Form Validation**: Real-time input validation

## 🔧 Configuration

### Environment Variables
The app uses Firebase configuration files for authentication:
- Android: `android/app/google-services.json`
- iOS: `ios/Runner/GoogleService-Info.plist`

### Build Configuration
- **Version**: 1.0.0+1
- **Target Platforms**: Android, iOS
- **Architecture**: Clean Architecture with BLoC pattern

## 📊 Project Structure

```
edu_mate/
├── android/                 # Android platform files
├── ios/                    # iOS platform files
├── lib/                    # Main application code
│   ├── core/              # Core functionality
│   ├── features/          # Feature modules
│   └── main.dart          # App entry point
├── test/                  # Test files
├── pubspec.yaml           # Dependencies
└── README.md             # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License


## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- All contributors and maintainers

## 📞 Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the development team
- Check the documentation for common issues

---

<div align="center">
  <p>Made with ❤️ using Flutter</p>
  <p>EduMate - Empowering Education Through Technology</p>
</div>

