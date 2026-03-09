import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notix_pro/notix_pro.dart';

void main() {
  group('NotixTheme Tests', () {
    test('default theme values', () {
      const theme = NotixTheme();
      expect(theme.borderRadius, 16.0);
      expect(theme.showAccentBar, true);
      expect(theme.displayDuration, const Duration(seconds: 3));
      expect(theme.animationStyle, NotixAnimationStyle.bounce);
    });

    test('force dark mode', () {
      const theme = NotixTheme(forceDarkMode: true);
      expect(theme.forceDarkMode, true);
    });
  });

  group('NotixTypeConfig Tests', () {
    test('success config', () {
      final config = NotixTypeConfig.of(NotixType.success);
      expect(config.defaultTitle, 'Success');
      expect(config.icon, Icons.check_circle_rounded);
    });

    test('error config', () {
      final config = NotixTypeConfig.of(NotixType.error);
      expect(config.defaultTitle, 'Error');
      expect(config.icon, Icons.cancel_rounded);
    });
  });
}
