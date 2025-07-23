# YouTube Player and URL Launcher Setup

This document explains how to use the YouTube player and URL launcher functionality in the Edu-Mate app.

## Dependencies Added

The following dependencies have been added to `pubspec.yaml`:

```yaml
dependencies:
  url_launcher: ^6.2.5
  youtube_player_flutter: ^9.1.1
```

## Android Permissions

The following permissions have been added to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

## Features Implemented

### 1. YouTube Player Integration

The course details screen now includes a YouTube player that can:
- Play videos directly within the app
- Show video progress indicator with custom styling
- Handle video controls (play, pause, seek)
- Automatically fallback to URL launcher if player fails

### 2. URL Launcher Integration

The app can also open YouTube videos in the external YouTube app or browser using URL launcher as a fallback.

### 3. Smart Video ID Extraction

The implementation includes robust video ID extraction that supports:
- Standard YouTube URLs: `https://www.youtube.com/watch?v=VIDEO_ID`
- Short YouTube URLs: `https://youtu.be/VIDEO_ID`
- Manual fallback extraction if package method fails

## How to Use

### 1. Course Model

Make sure your `Course` model has a `video` field with a YouTube URL:

```dart
class Course {
  // ... other fields
  String video; // YouTube URL like "https://www.youtube.com/watch?v=VIDEO_ID"
}
```

### 2. Video Section Behavior

The video section in `CourseDetailsScreen` works as follows:

- **If YouTube player is available**: Tapping the play button will start the video player within the app
- **If YouTube player is not available**: Tapping the play button will open the video in the external YouTube app or browser
- **Loading state**: Shows a loading indicator while initializing or opening the video
- **Error handling**: Automatically falls back to URL launcher if YouTube player fails

### 3. YouTube Button

The "Watch Video on YouTube" button in the "About this course" section will always open the video in the external YouTube app or browser.

## Sample Usage

```dart
// Create a course with a YouTube video URL
final course = Course(
  id: 1,
  title: 'Flutter Development Course',
  description: 'Learn Flutter development',
  category: 'Programming',
  image: 'https://example.com/image.jpg',
  video: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
);

// Navigate to course details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CourseDetailsScreen(course: course),
  ),
);
```

## Video URL Formats Supported

The YouTube player supports various YouTube URL formats:
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `https://www.youtube.com/embed/VIDEO_ID`

## Error Handling

The implementation includes error handling for:
- Invalid YouTube URLs
- Network connectivity issues
- URL launcher failures

## Troubleshooting

### Common Issues and Solutions

1. **Platform View Error**: If you see errors like "Trying to create a platform view of unregistered type", the app will automatically fallback to using URL launcher only.

2. **YouTube Player Not Loading**: The implementation includes automatic fallback to URL launcher if the YouTube player fails to initialize.

3. **Android Back Button**: Added `android:enableOnBackInvokedCallback="true"` to fix back button warnings.

4. **Video ID Extraction**: The implementation includes manual fallback extraction if the package's method fails.

### Error Handling

The implementation includes robust error handling:
- Automatic fallback to URL launcher if YouTube player fails
- Graceful handling of invalid YouTube URLs
- Network connectivity checks
- User-friendly error messages
- Loading states for better UX
- Delayed initialization to ensure widget is fully built

## Notes

1. Run `flutter pub get` after adding the dependencies
2. The YouTube player requires internet connectivity
3. Some YouTube videos may not be available for embedded playback due to content restrictions
4. The URL launcher will open the video in the user's preferred YouTube app or browser
5. If YouTube player fails to initialize, the app will automatically use URL launcher only
6. Added `multiDexEnabled = true` and NDK configuration to Android configuration for better compatibility
7. The implementation provides a smooth user experience with loading states and error handling
8. Delayed initialization ensures the widget is fully built before initializing the YouTube player 