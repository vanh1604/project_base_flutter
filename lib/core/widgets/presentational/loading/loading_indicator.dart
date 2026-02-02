import 'package:flutter/material.dart';

/// A reusable loading indicator widget
///
/// Usage:
/// ```dart
/// LoadingIndicator()
/// LoadingIndicator.small()
/// LoadingIndicator(message: 'Loading books...')
/// ```
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 40,
    this.color,
  });

  const LoadingIndicator.small({
    super.key,
    this.message,
    this.color,
  }) : size = 24;

  const LoadingIndicator.large({
    super.key,
    this.message,
    this.color,
  }) : size = 60;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: size > 40 ? 4 : 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Colors.deepPurple,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Linear loading indicator (progress bar)
class LinearLoadingIndicator extends StatelessWidget {
  final double? value;
  final Color? color;
  final Color? backgroundColor;

  const LinearLoadingIndicator({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: value,
      backgroundColor: backgroundColor ?? Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? Colors.deepPurple,
      ),
    );
  }
}
