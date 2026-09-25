import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class NeumorphicCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isPressed;
  final Color? backgroundColor;
  final Border? border;
  final double? width;
  final double? height;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = 20.0,
    this.padding = const EdgeInsets.all(18.0),
    this.isPressed = false,
    this.backgroundColor,
    this.border,
    this.width,
    this.height,
  });

  @override
  State<NeumorphicCard> createState() => _NeumorphicCardState();
}

class _NeumorphicCardState extends State<NeumorphicCard> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final pressed = widget.isPressed || _isTapped;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => setState(() => _isTapped = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _isTapped = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _isTapped = false) : null,
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: pressed
            ? NeumorphicDecoration.inset(
                isDarkMode: isDarkMode,
                borderRadius: widget.borderRadius,
                customColor: widget.backgroundColor,
              )
            : NeumorphicDecoration.flat(
                isDarkMode: isDarkMode,
                borderRadius: widget.borderRadius,
                customColor: widget.backgroundColor,
                border: widget.border,
              ),
        child: widget.child,
      ),
    );
  }
}
