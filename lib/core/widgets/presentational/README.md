# Presentational Widgets

Pure UI components without API calls or external state management.

## Characteristics

- ✅ **Pure UI**: Only display data passed via props
- ✅ **Stateless or Simple StatefulWidget**: No complex state
- ✅ **No API calls**: No direct communication with backend
- ✅ **No BLoC/Provider**: No state management integration
- ✅ **Highly reusable**: Can be used anywhere

## Examples

- **Buttons**: AppButton, IconButtonCustom
- **Inputs**: TextFieldCustom
- **Loading**: LoadingIndicator
- **Common**: EmptyStateWidget, ErrorWidgetCustom
- **Cards**: BaseCard

## When to use

Use presentational widgets when:
- Widget only needs to display data
- No API calls required
- No business logic involved
- Maximum reusability desired

## Folder Structure

```
presentational/
├── buttons/
├── inputs/
├── loading/
├── common/
└── cards/
```
