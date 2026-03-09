import 'package:flutter/material.dart';
import 'notix_type.dart';
import 'notix_theme.dart';

class NotixSheetAction {
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool isSecondary;

  const NotixSheetAction({
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.isSecondary = false,
  });
}

/// NotiX Pro Bottom Sheet Alert
///
/// ```dart
/// NotixSheet.show(context,
///   type: NotixType.error,
///   title: 'Delete Account?',
///   message: 'This cannot be undone.',
///   actions: [
///     NotixSheetAction(label: 'Delete', onTap: () {}, isDestructive: true),
///     NotixSheetAction(label: 'Cancel', onTap: () {}, isSecondary: true),
///   ],
/// );
/// ```
class NotixSheet {
  static Future<void> show(
    BuildContext context, {
    required NotixType type,
    required String title,
    required String message,
    List<NotixSheetAction> actions = const [],
    NotixTheme theme = NotixTheme.defaults,
    Widget? customIcon,
    bool showDragHandle = true,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _NotixSheetBody(
        type: type, title: title, message: message,
        actions: actions, theme: theme,
        customIcon: customIcon, showDragHandle: showDragHandle,
      ),
    );
  }
}

class _NotixSheetBody extends StatelessWidget {
  final NotixType type;
  final String title;
  final String message;
  final List<NotixSheetAction> actions;
  final NotixTheme theme;
  final Widget? customIcon;
  final bool showDragHandle;

  const _NotixSheetBody({
    required this.type, required this.title, required this.message,
    required this.actions, required this.theme,
    this.customIcon, required this.showDragHandle,
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
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: isDark ? Border.all(color: accent.withOpacity(0.15)) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
            blurRadius: 40, offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(24, 20, 24, bottomPad + 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon row
                Row(children: [
                  Container(width: 3, height: 48,
                    decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2))),
                  const SizedBox(width: 14),
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(14)),
                    child: customIcon ?? Icon(config.icon, color: accent, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(title,
                      style: TextStyle(fontFamily: theme.fontFamily, fontSize: 16, fontWeight: FontWeight.w700, color: primaryText)),
                  ),
                ]),
                const SizedBox(height: 14),
                Text(message,
                  style: TextStyle(fontFamily: theme.fontFamily, fontSize: 14, color: secondaryText, height: 1.55)),
                const SizedBox(height: 24),
                // Action buttons
                ...actions.map((action) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () { Navigator.of(context).pop(); action.onTap(); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: action.isDestructive
                              ? const Color(0xFFE53935).withOpacity(isDark ? 0.2 : 0.08)
                              : action.isSecondary
                                  ? (isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04))
                                  : accent,
                          borderRadius: BorderRadius.circular(theme.borderRadius - 4),
                          border: action.isSecondary
                              ? Border.all(color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08))
                              : null,
                          boxShadow: (!action.isDestructive && !action.isSecondary)
                              ? [BoxShadow(color: accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))]
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(action.label,
                          style: TextStyle(
                            fontFamily: theme.fontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: action.isDestructive
                                ? const Color(0xFFE53935)
                                : action.isSecondary ? secondaryText : Colors.white,
                          )),
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}