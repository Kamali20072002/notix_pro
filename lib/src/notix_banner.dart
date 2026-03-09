import 'package:flutter/material.dart';
import 'notix_type.dart';
import 'notix_theme.dart';

enum NotixBannerPosition { top, bottom }

/// NotiX Pro Banner
///
/// ```dart
/// NotixBanner.show(context,
///   type: NotixType.warning,
///   message: 'Session expiring in 5 minutes.',
///   actionLabel: 'Extend',
///   onAction: () => extendSession(),
/// );
/// ```
class NotixBanner {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required NotixType type,
    required String message,
    String? title,
    String? actionLabel,
    VoidCallback? onAction,
    NotixTheme theme = NotixTheme.defaults,
    NotixBannerPosition position = NotixBannerPosition.top,
    bool autoDismiss = true,
  }) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context);
    final isDark = theme.isDark(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _NotixBannerWidget(
        type: type, message: message, title: title,
        actionLabel: actionLabel, onAction: onAction,
        theme: theme, position: position, autoDismiss: autoDismiss,
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

class _NotixBannerWidget extends StatefulWidget {
  final NotixType type;
  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onAction;
  final NotixTheme theme;
  final NotixBannerPosition position;
  final bool autoDismiss;
  final VoidCallback onDismiss;
  final bool isDark;

  const _NotixBannerWidget({
    required this.type, required this.message, this.title,
    this.actionLabel, this.onAction, required this.theme,
    required this.position, required this.autoDismiss,
    required this.onDismiss, required this.isDark,
  });

  @override
  State<_NotixBannerWidget> createState() => _NotixBannerWidgetState();
}

class _NotixBannerWidgetState extends State<_NotixBannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.theme.animationDuration);

    final isTop = widget.position == NotixBannerPosition.top;
    _slide = Tween<Offset>(begin: Offset(0, isTop ? -1 : 1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.forward();
    if (widget.autoDismiss) {
      Future.delayed(widget.theme.displayDuration, () { if (mounted) _dismiss(); });
    }
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
    final isTop = widget.position == NotixBannerPosition.top;
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final surface = widget.theme.surfaceColor(context);
    final accent = config.color(widget.isDark);

    return Positioned(
      top: isTop ? 0 : null,
      bottom: isTop ? null : 0,
      left: 0, right: 0,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.only(
                top: isTop ? topPad + 12 : 12,
                bottom: isTop ? 12 : bottomPad + 12,
                left: 16, right: 16,
              ),
              decoration: BoxDecoration(
                color: surface,
                border: Border(
                  bottom: isTop ? BorderSide(color: accent.withOpacity(0.2)) : BorderSide.none,
                  top: !isTop ? BorderSide(color: accent.withOpacity(0.2)) : BorderSide.none,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(widget.isDark ? 0.3 : 0.08),
                    blurRadius: 20,
                    offset: Offset(0, isTop ? 4 : -4),
                  ),
                ],
              ),
              child: Row(children: [
                Container(
                  width: 3,
                  height: widget.title != null ? 40 : 22,
                  decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(2)),
                ),
                const SizedBox(width: 12),
                Icon(config.icon, color: accent, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.title != null)
                        Text(widget.title!,
                          style: TextStyle(fontFamily: widget.theme.fontFamily, fontSize: 13, fontWeight: FontWeight.w700, color: widget.theme.textPrimary(context))),
                      Text(widget.message,
                        style: TextStyle(fontFamily: widget.theme.fontFamily, fontSize: 13,
                          color: widget.title != null ? widget.theme.textSecondary(context) : widget.theme.textPrimary(context))),
                    ],
                  ),
                ),
                if (widget.actionLabel != null)
                  GestureDetector(
                    onTap: () { widget.onAction?.call(); _dismiss(); },
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(widget.actionLabel!,
                        style: TextStyle(fontFamily: widget.theme.fontFamily, fontSize: 12, fontWeight: FontWeight.w700, color: accent)),
                    ),
                  ),
                GestureDetector(
                  onTap: _dismiss,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(Icons.close_rounded, size: 18, color: widget.theme.textSecondary(context)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}