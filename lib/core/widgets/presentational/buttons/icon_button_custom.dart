import 'package:flutter/material.dart';

/// Custom icon button with consistent styling
///
/// Usage:
/// ```dart
/// IconButtonCustom(
///   icon: Icons.favorite,
///   onPressed: () => handleFavorite(),
///   backgroundColor: Colors.red,
/// )
/// ```
class IconButtonCustom extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final String? tooltip;
  final bool showBackground;

  const IconButtonCustom({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.iconSize = 24,
    this.tooltip,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
        color: iconColor ?? Colors.deepPurple,
      ),
      tooltip: tooltip,
      style: showBackground
          ? IconButton.styleFrom(
              backgroundColor: backgroundColor ?? Colors.deepPurple.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              fixedSize: Size(size, size),
            )
          : null,
    );

    return tooltip != null
        ? Tooltip(message: tooltip!, child: button)
        : button;
  }
}

/// Circular icon button variant
class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final String? tooltip;

  const CircularIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.iconSize = 24,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: backgroundColor ?? Colors.deepPurple,
      borderRadius: BorderRadius.circular(size / 2),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Colors.white,
          ),
        ),
      ),
    );

    return tooltip != null
        ? Tooltip(message: tooltip!, child: button)
        : button;
  }
}
