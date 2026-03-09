import 'package:flutter/material.dart';
import 'notix_type.dart';
import 'notix_theme.dart';

enum NotixToastPosition { top, bottom }

/// NotiX Pro Toast
///
/// ```dart
/// NotixToast.show(context,
///   type: NotixType.success,
///   message: 'Saved!',
///   theme: NotixTheme(animationStyle: NotixAnimationStyle.bounce),
/// );
/// ```
class NotixToast {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required NotixType type,
    required String message,
    String? title,
    NotixTheme theme = NotixTheme.defaults,
    NotixToastPosition position = NotixToastPosition.bottom,
    bool dismissOnTap = true,
  }) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context);
    final isDark = theme.isDark(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _NotixToastWidget(
        type: type,
        message: message,
        title: title,
        theme: theme,
        position: position,
        dismissOnTap: dismissOnTap,
        isDark: isDark,
        onDismiss: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    _current?.remove();
    _current = null;
  }
}

class _NotixToastWidget extends StatefulWidget {
  final NotixType type;
  final String message;
  final String? title;
  final NotixTheme theme;
  final NotixToastPosition position;
  final bool dismissOnTap;
  final VoidCallback onDismiss;
  final bool isDark;

  const _NotixToastWidget({
    required this.type, required this.message, this.title,
    required this.theme, required this.position,
    required this.dismissOnTap, required this.onDismiss, required this.isDark,
  });

  @override
  State<_NotixToastWidget> createState() => _NotixToastWidgetState();
}

class _NotixToastWidgetState extends State<_NotixToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.theme.animationDuration);

    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    final isBottom = widget.position == NotixToastPosition.bottom;
    _slide = Tween<Offset>(
      begin: Offset(0, isBottom ? 0.8 : -0.8), end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));

    _scale = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));

    _ctrl.forward();
    Future.delayed(widget.theme.displayDuration, () { if (mounted) _dismiss(); });
  }

  void _dismiss() async {
    if (!mounted) return;
    await _ctrl.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final config = NotixTypeConfig.of(widget.type);
    final isBottom = widget.position == NotixToastPosition.bottom;
    final surface = widget.theme.surfaceColor(context);
    final accent = config.color(widget.isDark);
    final iconBg = config.background(widget.isDark);

    Widget child = Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(widget.theme.borderRadius),
          border: Border.all(color: accent.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(color: accent.withOpacity(0.18), blurRadius: 28, offset: const Offset(0, 6)),
            BoxShadow(color: Colors.black.withOpacity(widget.isDark ? 0.3 : 0.07), blurRadius: 12, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(config.icon, color: accent, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.title != null) ...[
                  Text(widget.title!,
                    style: TextStyle(fontFamily: widget.theme.fontFamily, fontSize: 13, fontWeight: FontWeight.w700, color: widget.theme.textPrimary(context))),
                  const SizedBox(height: 2),
                ],
                Text(widget.message,
                  style: TextStyle(fontFamily: widget.theme.fontFamily, fontSize: 13,
                    color: widget.title != null ? widget.theme.textSecondary(context) : widget.theme.textPrimary(context), height: 1.4)),
              ],
            ),
          ),
          GestureDetector(
            onTap: _dismiss,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.close_rounded, size: 17, color: widget.theme.textSecondary(context)),
            ),
          ),
        ]),
      ),
    );

    return Positioned(
      bottom: isBottom ? 40 : null,
      top: isBottom ? null : 60,
      left: 16, right: 16,
      child: GestureDetector(
        onTap: widget.dismissOnTap ? _dismiss : null,
        child: SlideTransition(
          position: _slide,
          child: ScaleTransition(
            scale: _scale,
            child: FadeTransition(opacity: _opacity, child: child),
          ),
        ),
      ),
    );
  }
}