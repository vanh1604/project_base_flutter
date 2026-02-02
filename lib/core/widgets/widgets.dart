/// Core reusable widgets
///
/// This barrel file exports all core widgets for easy importing
///
/// Organized by Hybrid Architecture:
/// - presentational/: Pure UI widgets (no API calls)
/// - connected/: Widgets with API calls or external state
///
/// Usage:
/// ```dart
/// import 'package:your_app/core/widgets/widgets.dart';
///
/// AppButton(text: 'Save', onPressed: () {})
/// LoadingIndicator()
/// EmptyStateWidget(icon: Icons.search_off, title: 'No results')
/// ```

// Presentational Widgets (Pure UI, no API calls)

// Buttons
export 'presentational/buttons/app_button.dart';
export 'presentational/buttons/icon_button_custom.dart';

// Inputs
export 'presentational/inputs/text_field_custom.dart';

// Loading
export 'presentational/loading/loading_indicator.dart';

// Common
export 'presentational/common/empty_state_widget.dart';
export 'presentational/common/error_widget_custom.dart';

// Cards
export 'presentational/cards/base_card.dart';

// Connected Widgets (With API calls or external state)
// (Empty for now - widgets will be added here when needed)
