import 'package:flutter/material.dart';
import 'notix_type.dart';
import 'notix_theme.dart';

/// NotiX Pro Dialog
///
/// ```dart
/// NotixDialog.show(
///   context,
///   type: NotixType.success,
///   title: 'Payment Done!',
///   message: 'Your order is confirmed.',
///   theme: NotixTheme(animationStyle: NotixAnimationStyle.bounce),
/// );
/// ```
class NotixDialog {
  static Future<bool?> show(
    BuildContext context, {
    required NotixType type,
    required String title,
    required String message,
    String confirmText = 'OK',
    String? cancelText,
    NotixTheme theme = NotixTheme.defaults,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
    Widget? customIcon,
  }) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: theme.animationDuration,
      transitionBuilder: (ctx, anim, _, child) {
        switch (theme.animationStyle) {
          case NotixAnimationStyle.bounce:
            return ScaleTransition(
              scale: Tween(begin: 0.6, end: 1.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.elasticOut),
              ),
              child: FadeTransition(opacity: anim, child: child),
            );
          case NotixAnimationStyle.flip:
            return AnimatedBuilder(
              animation: anim,
              builder: (_, c) => Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX((1 - anim.value) * 3.14159 / 2),
                child: FadeTransition(opacity: anim, child: c),
              ),
              child: child,
            );
          case NotixAnimationStyle.scale:
            return ScaleTransition(
              scale: Tween(begin: 0.85, end: 1.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
              ),
              child: FadeTransition(opacity: anim, child: child),
            );
          case NotixAnimationStyle.slide:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
              child: FadeTransition(opacity: anim, child: child),
            );
          case NotixAnimationStyle.fade:
            return FadeTransition(opacity: anim, child: child);
        }
      },
      pageBuilder: (ctx, _, __) => _NotixDialogBody(
        type: type,
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        theme: theme,
        onConfirm: onConfirm,
        onCancel: onCancel,
        customIcon: customIcon,
      ),
    );
  }
}

class _NotixDialogBody extends StatelessWidget {
  final NotixType type;
  final String title;
  final String message;
  final String confirmText;
  final String? cancelText;
  final NotixTheme theme;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? customIcon;

  const _NotixDialogBody({
    required this.type,
    required this.title,
    required this.message,
    required this.confirmText,
    this.cancelText,
    required this.theme,
    this.onConfirm,
    this.onCancel,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    final config = NotixTypeConfig.of(type);
    final isDark = theme.isDark(context);
    final surface = theme.surfaceColor(context);
    final primaryText = theme.textPrimary(context);
    final secondaryText = theme.textSecondary(context);
    final accent = config.color(isDark);
    final iconBg = config.background(isDark);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(theme.borderRadius),
            border: isDark ? Border.all(color: accent.withOpacity(0.2)) : null,
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(isDark ? 0.25 : 0.12),
                blurRadius: 50,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(theme.borderRadius),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (theme.showAccentBar)
                    Container(width: 4, color: accent),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon + title
                          Row(children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(13)),
                              child: customIcon ?? Icon(config.icon, color: accent, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(title,
                                style: TextStyle(fontFamily: theme.fontFamily, fontSize: 15.5, fontWeight: FontWeight.w700, color: primaryText)),
                            ),
                          ]),
                          const SizedBox(height: 12),
                          Text(message,
                            style: TextStyle(fontFamily: theme.fontFamily, fontSize: 13.5, color: secondaryText, height: 1.55)),
                          const SizedBox(height: 20),
                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (cancelText != null) ...[
                                GestureDetector(
                                  onTap: () { onCancel?.call(); Navigator.of(context).pop(false); },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                    child: Text(cancelText!,
                                      style: TextStyle(fontFamily: theme.fontFamily, fontSize: 14, fontWeight: FontWeight.w500, color: secondaryText)),
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                              GestureDetector(
                                onTap: () { onConfirm?.call(); Navigator.of(context).pop(true); },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: accent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(color: accent.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
                                  ),
                                  child: Text(confirmText,
                                    style: TextStyle(fontFamily: theme.fontFamily, fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}