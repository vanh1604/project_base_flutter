# Connected Widgets

Widgets with API calls or external state management.

## Characteristics

- ✅ **Has API calls**: Direct communication with backend
- ✅ **State management**: Often uses BLoC/Provider/Cubit
- ✅ **Not a Feature**: No business domain (entities, use cases)
- ✅ **Reusable**: Used across multiple features
- ❌ **NOT domain-specific**: Generic functionality

## Examples (Future)

- **SearchBar**: Widget with search API calls
- **UserPicker**: Widget to select users from API
- **LocationPicker**: Widget with maps API
- **FileUploader**: Widget with upload API

## Connected vs Feature

| Aspect | Connected Component | Feature |
|--------|-------------------|---------|
| Business Domain | ❌ No | ✅ Yes |
| Entities | ❌ No | ✅ Yes |
| Use Cases | ❌ No | ✅ Yes |
| API Calls | ✅ Yes | ✅ Yes |
| Location | `core/widgets/connected/` | `features/[name]/` |

## When to use

Use connected widgets when:
- Widget needs API calls
- Reusable across features
- NO business domain (no entities/use cases)
- Generic UI functionality

If widget has business domain, create a Feature instead!

## Folder Structure

```
connected/
└── (widgets will be added here when needed)
```
