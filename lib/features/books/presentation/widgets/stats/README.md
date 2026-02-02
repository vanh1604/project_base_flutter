# Stats - Books Feature Widget

Stats calculation component as part of Books feature.

## Why Part of Books Feature, Not Separate Feature?

**Reason:** Stats does NOT have independent business domain.

### Evidence:
- ❌ No entities (no Statistics entity)
- ❌ No use cases (only aggregation logic)
- ❌ No repositories (uses BooksRepository directly)
- ✅ Only calculates statistics from Books data

### From the code:
```dart
// stats_bloc.dart
import '../../../books/domain/repositories/books_repository.dart';

// Uses Books feature's BooksRepository
final BooksRepository repository;

// Only aggregation logic
final totalBooks = books.length;
final totalPages = books.fold<int>(0, (sum, book) => sum + book.pages);
```

## Classification

**Not a Feature because:**
- No business domain
- Just data aggregation/computation
- Tightly coupled to Books data

**Part of Books Feature because:**
- Operates on Books data
- Uses Books repository
- Logical grouping

## Files

- `stats_bloc.dart` - Statistics calculation BLoC
- `stats_event.dart` - Stats events
- `stats_state.dart` - Stats states

## Usage

```dart
// In composite screens
BlocProvider(
  create: (_) => StatsBloc(repository: sl<BooksRepository>()),
),

// UI
BlocBuilder<StatsBloc, StatsState>(
  builder: (context, state) {
    if (state is StatsLoaded) {
      return StatsDisplay(stats: state);
    }
  },
)
```

## Location

`features/books/presentation/widgets/stats/` - Part of Books feature
