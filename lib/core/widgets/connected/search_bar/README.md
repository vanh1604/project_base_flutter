# SearchBar - Connected Component

Connected component with BLoC state management for search functionality.

## Why Connected Component, Not Feature?

**Reason:** Search does NOT have independent business domain.

### Evidence:
- ❌ No entities (uses Book entity from Books feature)
- ❌ No use cases (uses SearchBooks from Books feature)
- ❌ No repositories (depends on Books repository)
- ✅ Only presentation logic with BLoC

### From the code:
```dart
// search_bloc.dart
import '../../../books/domain/usecases/search_books.dart';

// Uses Books feature's SearchBooks usecase
final SearchBooks searchBooks;
```

## Classification (Decision #4 from Architecture Guide)

> Widget có API call + state management = **Connected Component**, NOT Feature

## Files

- `search_bar_widget.dart` - UI widget with debounce logic
- `search_bloc.dart` - BLoC state management
- `search_event.dart` - Search events
- `search_state.dart` - Search states

## Usage

```dart
// In composite screens
BlocProvider(
  create: (_) => SearchBloc(searchBooks: sl()),
),

// UI
SearchBarWidget(
  onSearch: (query) {
    context.read<SearchBloc>().add(SearchBooksEvent(query));
  },
)
```

## Location

`core/widgets/connected/search_bar/` - Reusable across multiple screens
