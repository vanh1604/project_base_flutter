# Core Widgets

Thư viện các UI components có thể tái sử dụng cho toàn bộ ứng dụng.

## 📁 Cấu trúc

```
lib/core/widgets/
├── buttons/              # Button components
│   ├── app_button.dart
│   └── icon_button_custom.dart
├── inputs/               # Input components
│   └── text_field_custom.dart
├── cards/                # Card components
│   └── base_card.dart
├── loading/              # Loading indicators
│   └── loading_indicator.dart
├── common/               # Common UI components
│   ├── empty_state_widget.dart
│   └── error_widget_custom.dart
├── examples/             # Demo & examples
│   └── widgets_demo_screen.dart
└── widgets.dart          # Barrel file (import this)
```

## 🚀 Cách sử dụng

### Import

```dart
import 'package:your_app/core/widgets/widgets.dart';
```

### 1. Buttons

#### AppButton - Button tùy chỉnh

```dart
// Primary button
AppButton(
  text: 'Save',
  icon: Icons.save,
  type: AppButtonType.primary,
  onPressed: () => handleSave(),
)

// Secondary button
AppButton(
  text: 'Cancel',
  type: AppButtonType.secondary,
  onPressed: () => handleCancel(),
)

// Outlined button
AppButton(
  text: 'Edit',
  type: AppButtonType.outlined,
  icon: Icons.edit,
  onPressed: () => handleEdit(),
)

// Text button
AppButton(
  text: 'Skip',
  type: AppButtonType.text,
  onPressed: () => handleSkip(),
)

// Full width button
AppButton(
  text: 'Submit',
  isFullWidth: true,
  onPressed: () => handleSubmit(),
)

// Loading button
AppButton(
  text: 'Submitting...',
  isLoading: isSubmitting,
  onPressed: () => handleSubmit(),
)
```

#### IconButtonCustom - Icon button tùy chỉnh

```dart
// Standard icon button
IconButtonCustom(
  icon: Icons.favorite,
  tooltip: 'Favorite',
  onPressed: () => toggleFavorite(),
)

// Custom colors
IconButtonCustom(
  icon: Icons.share,
  iconColor: Colors.blue,
  backgroundColor: Colors.blue.withOpacity(0.1),
  onPressed: () => handleShare(),
)

// Circular icon button
CircularIconButton(
  icon: Icons.add,
  backgroundColor: Colors.green,
  onPressed: () => handleAdd(),
)
```

### 2. Input Fields

#### TextFieldCustom - Text field tùy chỉnh

```dart
// Basic text field
TextFieldCustom(
  label: 'Email',
  hintText: 'Enter your email',
  prefixIcon: Icons.email,
  controller: emailController,
)

// Password field
TextFieldCustom(
  label: 'Password',
  hintText: 'Enter password',
  prefixIcon: Icons.lock,
  obscureText: true,
  suffixIcon: Icon(Icons.visibility_off),
)

// Multiline text field
TextFieldCustom(
  label: 'Description',
  hintText: 'Enter description',
  maxLines: 3,
)

// With validation
TextFieldCustom(
  label: 'Username',
  hintText: 'Enter username',
  validator: (value) {
    if (value?.isEmpty ?? true) {
      return 'Username is required';
    }
    return null;
  },
)
```

### 3. Cards

#### BaseCard - Card cơ bản

```dart
// Simple card
BaseCard(
  child: Text('Content'),
)

// Tappable card
BaseCard(
  onTap: () => handleTap(),
  child: Row(
    children: [
      Icon(Icons.info),
      SizedBox(width: 8),
      Text('Tap me'),
    ],
  ),
)

// Elevated card
ElevatedCard(
  onTap: () => handleTap(),
  child: Text('Elevated card with stronger shadow'),
)
```

### 4. Loading Indicators

```dart
// Standard loading
LoadingIndicator()

// With message
LoadingIndicator(message: 'Loading books...')

// Small size
LoadingIndicator.small()

// Large size
LoadingIndicator.large()

// Linear progress
LinearLoadingIndicator()

// Linear with value
LinearLoadingIndicator(value: 0.5) // 50%
```

### 5. Empty State

```dart
EmptyStateWidget(
  icon: Icons.search_off,
  title: 'No results found',
  message: 'Try adjusting your search query',
  actionText: 'Clear Search',
  onAction: () => clearSearch(),
)
```

### 6. Error State

```dart
ErrorWidgetCustom(
  message: 'Failed to load data from server',
  onRetry: () => retryLoad(),
)

// Custom retry text
ErrorWidgetCustom(
  message: 'Network error',
  retryText: 'Try Again',
  onRetry: () => retryLoad(),
)
```

## 🎨 Customization

### Theme Colors

Tất cả widgets sử dụng `Colors.deepPurple` làm primary color. Để thay đổi theme:

1. Cập nhật trong từng widget file
2. Hoặc tạo theme constants trong `lib/core/constants/app_colors.dart`

### Styles

Để tùy chỉnh styles, edit các widget files trực tiếp hoặc extend classes:

```dart
class MyCustomButton extends AppButton {
  const MyCustomButton({
    super.key,
    required super.text,
    super.onPressed,
  }) : super(
    type: AppButtonType.primary,
    isFullWidth: true,
  );
}
```

## 📝 Best Practices

1. **Luôn sử dụng barrel file**: Import từ `widgets.dart` thay vì import từng file
2. **Giữ widgets stateless**: Core widgets nên stateless, state management ở ngoài
3. **Generic parameters**: Widgets nhận data qua props, không hardcode
4. **Consistent styling**: Dùng cùng border radius (12), padding, colors

## 🎯 Khi nào dùng Core Widgets?

✅ **Dùng khi:**
- Widget có thể tái sử dụng ở nhiều nơi
- UI tĩnh, không phụ thuộc business logic
- Cần consistency trong design

❌ **Không dùng khi:**
- Widget specific cho một feature
- Có business logic phức tạp
- Cần connect với BLoC/State Management

## 🔍 Demo

Xem `examples/widgets_demo_screen.dart` để thấy tất cả widgets hoạt động.

Để chạy demo:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => WidgetsDemoScreen(),
  ),
);
```
