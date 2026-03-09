# notix_pro

Premium Flutter notification kit with dark mode, 5 animation styles,
bottom sheets, toasts, banners and dialogs.

## Features

- ✅ NotixDialog – animated popup alerts with dark mode + animations
- ✅ NotixToast – floating toast notifications (top or bottom)
- ✅ NotixBanner – full-width banner notifications with action button
- ✅ NotixSheet – bottom sheet alerts with multiple actions (PRO)
- 🌙 Auto dark mode detection
- 🎬 5 animation styles: bounce, flip, blur, slide, scale
- 🎨 4 alert types: success, error, warning, info
- 💡 Zero dependencies

## Installation
```yaml
dependencies:
  notix_pro: ^0.0.1
```

## Usage
```dart
import 'package:notix_pro/notix_pro.dart';

// Dialog
NotixDialog.show(context,
  type: NotixType.success,
  title: 'Payment Successful',
  message: 'Your order is confirmed.',
);

// Toast
NotixToast.show(context,
  type: NotixType.error,
  message: 'Upload failed.',
);

// Banner
NotixBanner.show(context,
  type: NotixType.warning,
  message: 'Session expiring soon.',
  actionLabel: 'Extend',
);

// Bottom Sheet
NotixSheet.show(context,
  type: NotixType.error,
  title: 'Delete Account?',
  message: 'This cannot be undone.',
  actions: [
    NotixSheetAction(label: 'Delete', onTap: () {}, isDestructive: true),
    NotixSheetAction(label: 'Cancel', onTap: () {}, isSecondary: true),
  ],
);
```

## License

MIT License — free for personal and commercial use.