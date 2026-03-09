import 'package:flutter/material.dart';

enum NotixType { success, error, warning, info }

enum NotixAnimationStyle { fade, bounce, flip, scale, slide }

class NotixTypeConfig {
  final Color lightColor;
  final Color lightBackground;
  final Color darkColor;
  final Color darkBackground;
  final IconData icon;
  final String defaultTitle;

  const NotixTypeConfig({
    required this.lightColor,
    required this.lightBackground,
    required this.darkColor,
    required this.darkBackground,
    required this.icon,
    required this.defaultTitle,
  });

  Color color(bool isDark) => isDark ? darkColor : lightColor;
  Color background(bool isDark) => isDark ? darkBackground : lightBackground;

  static NotixTypeConfig of(NotixType type) {
    switch (type) {
      case NotixType.success:
        return const NotixTypeConfig(
          lightColor: Color(0xFF1DB954),
          lightBackground: Color(0xFFE8FAF0),
          darkColor: Color(0xFF4ADE80),
          darkBackground: Color(0xFF052E16),
          icon: Icons.check_circle_rounded,
          defaultTitle: 'Success',
        );
      case NotixType.error:
        return const NotixTypeConfig(
          lightColor: Color(0xFFE53935),
          lightBackground: Color(0xFFFFEBEE),
          darkColor: Color(0xFFF87171),
          darkBackground: Color(0xFF2D0A0A),
          icon: Icons.cancel_rounded,
          defaultTitle: 'Error',
        );
      case NotixType.warning:
        return const NotixTypeConfig(
          lightColor: Color(0xFFF59E0B),
          lightBackground: Color(0xFFFFFBEB),
          darkColor: Color(0xFFFBBF24),
          darkBackground: Color(0xFF2D1A00),
          icon: Icons.warning_rounded,
          defaultTitle: 'Warning',
        );
      case NotixType.info:
        return const NotixTypeConfig(
          lightColor: Color(0xFF1E88E5),
          lightBackground: Color(0xFFE3F2FD),
          darkColor: Color(0xFF60A5FA),
          darkBackground: Color(0xFF0A1E2D),
          icon: Icons.info_rounded,
          defaultTitle: 'Info',
        );
    }
  }
}