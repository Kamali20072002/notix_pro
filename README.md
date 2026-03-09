# Notix Pro

<p align="center">
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/coverimage/notix_pro_cover.png" width="900"/>
</p>

Premium Flutter notification kit with **dark mode, 5 animation styles, bottom sheets, toasts, banners, and dialogs**.

---

## ✨ Features

- ✅ **NotixDialog** – animated popup alerts with dark mode + animations
- ✅ **NotixToast** – floating toast notifications (top or bottom)
- ✅ **NotixBanner** – full-width banner notifications with action button
- ✅ **NotixSheet** – bottom sheet alerts with multiple actions (PRO)

### 🎨 Built-in Capabilities

- 🌙 **Auto dark mode detection**
- 🎬 **5 animation styles**
  - bounce
  - flip
  - blur
  - slide
  - scale
- 🎨 **4 alert types**
  - success
  - error
  - warning
  - info
- 💡 **Zero dependencies**

---

## 📸 Screenshots

<p float="left">
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image1.jpg" width="200"/>
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image2.jpg" width="200"/>
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image3.jpg" width="200"/>
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image4.jpg" width="200"/>
</p>

<p float="left">
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image5.jpg" width="200"/>
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image6.jpg" width="200"/>
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image7.jpg" width="200"/>
  <img src="https://raw.githubusercontent.com/Kamali20072002/notix_pro/main/images/Screenshots/image8.jpg" width="200"/>
</p>

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  notix_pro: ^0.0.2
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Usage

### Import

```dart
import 'package:notix_pro/notix_pro.dart';
```

### Dialog

```dart
NotixDialog.show(
  context,
  type: NotixType.success,
  title: 'Payment Successful',
  message: 'Your order #1234 has been confirmed.',
  confirmText: 'Great!',
  cancelText: 'Cancel',
  theme: NotixTheme(
    animationStyle: NotixAnimationStyle.bounce,
  ),
);
```

### Toast

```dart
NotixToast.show(
  context,
  type: NotixType.error,
  title: 'Upload Failed',
  message: 'File exceeds the 10MB limit.',
  position: NotixToastPosition.top,
);
```

### Banner

```dart
NotixBanner.show(
  context,
  type: NotixType.warning,
  title: 'Session Expiring',
  message: 'Your session expires in 5 minutes.',
  actionLabel: 'Extend',
  onAction: () => extendSession(),
);
```

### Bottom Sheet ⭐ PRO

```dart
NotixSheet.show(
  context,
  type: NotixType.error,
  title: 'Delete Account?',
  message: 'This action is permanent and cannot be undone.',
  actions: [
    NotixSheetAction(
      label: 'Delete Everything',
      onTap: () => deleteAccount(),
      isDestructive: true,
    ),
    NotixSheetAction(
      label: 'Cancel',
      onTap: () {},
      isSecondary: true,
    ),
  ],
);
```

---

## 🎬 Animation Styles

```dart
NotixAnimationStyle.bounce  // Spring elastic entrance (default)
NotixAnimationStyle.flip    // 3D card flip effect
NotixAnimationStyle.blur    // Soft focus-in effect
NotixAnimationStyle.slide   // Clean directional slide
NotixAnimationStyle.scale   // Smooth scale-up
```

---

## 🌙 Dark Mode

Auto detects from system theme — no extra code needed:

```dart
// Auto uses dark or light based on your app theme
NotixDialog.show(context, type: NotixType.success, ...);

// Or force dark mode
NotixDialog.show(
  context,
  type: NotixType.success,
  theme: NotixTheme(forceDarkMode: true),
  ...
);
```

---

## 🎨 Full Theme Customization

```dart
const myTheme = NotixTheme(
  borderRadius: 20.0,
  fontFamily: 'Poppins',
  showAccentBar: true,
  displayDuration: Duration(seconds: 4),
  animationDuration: Duration(milliseconds: 400),
  animationStyle: NotixAnimationStyle.flip,
  forceDarkMode: false,
);
```

---

## 🆓 Free Version

Looking for a free version? Check out
[notify_kit](https://pub.dev/packages/notify_kit) —
basic dialogs, toasts and banners with no pro features.

---

## 📄 License

MIT License — free for personal and commercial use.