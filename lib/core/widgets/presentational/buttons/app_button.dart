import 'package:flutter/material.dart';

/// Enum defining button types
enum AppButtonType { primary, secondary, outlined, text }

/// A customizable reusable button widget
///
/// Usage:
/// ```dart
/// AppButton(
///   text: 'Save',
///   icon: Icons.save,
///   type: AppButtonType.primary,
///   onPressed: () => handleSave(),
/// )
/// ```
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = _buildPrimaryButton();
        break;
      case AppButtonType.secondary:
        button = _buildSecondaryButton();
        break;
      case AppButtonType.outlined:
        button = _buildOutlinedButton();
        break;
      case AppButtonType.text:
        button = _buildTextButton();
        break;
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 48,
      child: button,
    );
  }

  Widget _buildPrimaryButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.deepPurple.withOpacity(0.6),
        disabledForegroundColor: Colors.white.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(Colors.white),
    );
  }

  Widget _buildSecondaryButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.grey[800],
        disabledBackgroundColor: Colors.grey[100],
        disabledForegroundColor: Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(Colors.grey[800]!),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        disabledForegroundColor: Colors.deepPurple.withOpacity(0.5),
        side: BorderSide(
          color: isLoading
              ? Colors.deepPurple.withOpacity(0.5)
              : Colors.deepPurple,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: _buildButtonContent(Colors.deepPurple),
    );
  }

  Widget _buildTextButton() {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Colors.deepPurple,
        disabledForegroundColor: Colors.deepPurple.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: _buildButtonContent(Colors.deepPurple),
    );
  }

  Widget _buildButtonContent(Color defaultColor) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == AppButtonType.primary ? Colors.white : Colors.deepPurple,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
