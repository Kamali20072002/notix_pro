import 'package:flutter/material.dart';
import 'notix_type.dart';

class NotixTheme {
  final double borderRadius;
  final String? fontFamily;
  final bool showAccentBar;
  final Duration displayDuration;
  final Duration animationDuration;
  final NotixAnimationStyle animationStyle;
  final bool enableSound;
  final bool forceDarkMode;
  final Color? customDarkSurface;
  final Color? customLightSurface;

  const NotixTheme({
    this.borderRadius = 16.0,
    this.fontFamily,
    this.showAccentBar = true,
    this.displayDuration = const Duration(seconds: 3),
    this.animationDuration = const Duration(milliseconds: 380),
    this.animationStyle = NotixAnimationStyle.bounce,
    this.enableSound = false,
    this.forceDarkMode = false,
    this.customDarkSurface,
    this.customLightSurface,
  });

  bool isDark(BuildContext context) =>
      forceDarkMode || Theme.of(context).brightness == Brightness.dark;

  Color surfaceColor(BuildContext context) => isDark(context)
      ? (customDarkSurface ?? const Color(0xFF1C1C1E))
      : (customLightSurface ?? Colors.white);

  Color textPrimary(BuildContext context) =>
      isDark(context) ? const Color(0xFFF9FAFB) : const Color(0xFF1A1A1A);

  Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);

  static const NotixTheme defaults = NotixTheme();
  static const NotixTheme dark = NotixTheme(forceDarkMode: true);
}