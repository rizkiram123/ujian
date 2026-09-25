import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isPrimary;
  final IconData? icon;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.textColor,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
    this.isPrimary = false,
    this.icon,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    if (widget.isPrimary) {
      return GestureDetector(
        onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [NeumorphicColors.primaryLight, NeumorphicColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: NeumorphicColors.primary.withOpacity(0.4),
                  offset: const Offset(0, 6),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                ],
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: widget.padding,
        decoration: _isPressed
            ? NeumorphicDecoration.inset(
                isDarkMode: isDarkMode,
                borderRadius: widget.borderRadius,
                customColor: widget.color,
              )
            : NeumorphicDecoration.flat(
                isDarkMode: isDarkMode,
                borderRadius: widget.borderRadius,
                customColor: widget.color,
              ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                color: widget.textColor ?? (isDarkMode ? Colors.white70 : NeumorphicColors.textDark),
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            DefaultTextStyle(
              style: TextStyle(
                color: widget.textColor ?? (isDarkMode ? Colors.white : NeumorphicColors.textDark),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

class NeumorphicIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? iconColor;
  final String? tooltip;

  const NeumorphicIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 48.0,
    this.iconColor,
    this.tooltip,
  });

  @override
  State<NeumorphicIconButton> createState() => _NeumorphicIconButtonState();
}

class _NeumorphicIconButtonState extends State<NeumorphicIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Widget button = GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.size,
        height: widget.size,
        decoration: _isPressed
            ? NeumorphicDecoration.inset(
                isDarkMode: isDarkMode,
                borderRadius: widget.size / 2,
              )
            : NeumorphicDecoration.flat(
                isDarkMode: isDarkMode,
                borderRadius: widget.size / 2,
              ),
        child: Center(
          child: Icon(
            widget.icon,
            color: widget.iconColor ?? (isDarkMode ? Colors.white : NeumorphicColors.textDark),
            size: widget.size * 0.48,
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(message: widget.tooltip!, child: button);
    }
    return button;
  }
}
