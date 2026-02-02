# Project Structure - Hybrid Architecture

**Version:** 1.0
**Date:** 2026-02-02
**Architecture:** MVVM + BLoC + Hybrid Architecture (Folder Organization)

## Overview

This project follows **MVVM + BLoC Pattern** with **Hybrid Architecture** for folder organization. The architecture consists of **2 main layers**:

1. **Data Layer**: Data management (Models, DataSources, Repositories)
2. **Presentation Layer**: UI & State Management (BLoC, Pages, Widgets)

**Key Principles:**
- ✅ BLoC Pattern for state management
- ✅ Repository Pattern for data access
- ✅ Hybrid Architecture for folder organization (Component-Based + Feature-First)
- ✅ Screens COMPOSE FROM features - features remain independent and reusable

---

## Folder Structure

```
lib/
├── core/                           # 🔧 Shared utilities & components
│   ├── constants/                  # App-wide constants
│   │   └── api_constants.dart
│   ├── di/                         # Dependency Injection (GetIt)
│   │   └── injection_container.dart
│   ├── network/                    # HTTP client & interceptors
│   │   ├── dio_client.dart
│   │   └── auth_interceptor.dart
│   ├── errors/                     # Error handling
│   │   ├── exceptions.dart         # Technical errors (Data Layer)
│   │   └── failures.dart           # Business errors (Presentation)
│   └── widgets/                    # Reusable widgets
│       ├── connected/              # Widgets WITH API calls (NO domain)
│       │   └── search_bar/         # Search component with BLoC
│       │       ├── search_bar_widget.dart
│       │       ├── search_bloc.dart
│       │       ├── search_event.dart
│       │       └── search_state.dart
│       ├── presentational/         # Pure UI widgets (NO API)
│       │   ├── buttons/
│       │   │   ├── app_button.dart
│       │   │   └── icon_button_custom.dart
│       │   ├── cards/
│       │   │   └── base_card.dart
│       │   ├── common/
│       │   │   ├── empty_state_widget.dart
│       │   │   └── error_widget_custom.dart
│       │   ├── inputs/
│       │   │   └── text_field_custom.dart
│       │   └── loading/
│       │       └── loading_indicator.dart
│       └── widgets.dart            # Barrel export
│
├── features/                       # 🎯 Business Features (MVVM + BLoC)
│   └── books/                      # 📚 Books Feature (ONLY real feature)
│       ├── data/                   # DATA LAYER
│       │   ├── datasources/
│       │   │   └── books_remote_datasource.dart  # API calls
│       │   ├── models/
│       │   │   └── book_model.dart               # Business object + Data transfer
│       │   └── repositories/
│       │       └── books_repository.dart         # Concrete repository
│       └── presentation/           # PRESENTATION LAYER
│           ├── bloc/               # BLoC (State Management)
│           │   ├── books_event.dart
│           │   ├── books_state.dart
│           │   └── books_bloc.dart
│           ├── pages/              # Simple screens (1 feature only)
│           │   └── book_details_screen.dart
│           └── widgets/            # Feature-specific widgets
│               ├── book_card.dart
│               ├── book_list_shimmer.dart
│               └── stats/          # Stats widget (aggregates Books data)
│                   ├── stats_bloc.dart
│                   ├── stats_event.dart
│                   └── stats_state.dart
│
├── screens/                        # 📱 Composite Screens (≥2 features)
│   └── composite/
│       ├── dashboard/
│       │   └── dashboard_screen.dart    # Books + Search + Stats
│       └── book_list/
│           └── book_list_screen.dart    # Books + Search
│
└── main.dart                       # App entry point
```

---

## Architecture Layers Explained

### Layer 1: Data Layer (Data Management)

**Vai trò:** Quản lý data từ API, Database, Cache

**Components:**
- **DataSources**: API calls, local storage
- **Models**: Data models với JSON parsing (serve as both business objects và DTOs)
- **Repositories**: Concrete repository classes (NOT interfaces)

**Đặc điểm:**
- ✅ Handle API calls, caching
- ✅ Handle technical errors (Exceptions)
- ✅ Repository pattern - concrete classes
- ✅ Models ARE business objects (không tách Entity riêng)

**Example:**
```dart
// Data Source
class BooksRemoteDataSource {
  Future<List<BookModel>> getAllBooks() async {
    // API call
  }
}

// Repository (Concrete class)
class BooksRepository {
  final BooksRemoteDataSource remoteDataSource;

  Future<Either<Failure, List<BookModel>>> getAllBooks() async {
    try {
      final books = await remoteDataSource.getAllBooks();
      return Right(books);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
```

---

### Layer 2: Presentation Layer (UI & State Management)

**Vai trò:** UI components và BLoC state management

**Components:**
- **BLoC**: Business logic & state management (Events, States, BLoC)
- **Pages**: Full screens
- **Widgets**: Reusable UI components

**Đặc điểm:**
- ✅ BLoC Pattern cho state management
- ✅ BLoC gọi Repository trực tiếp (NO Use Cases layer)
- ✅ Reactive UI với Streams
- ✅ Handle business errors (Failures)

**Example:**
```dart
// BLoC
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final BooksRepository repository;

  Future<void> _onLoadBooks(...) async {
    emit(BooksLoading());
    final result = await repository.getAllBooks();
    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books)),
    );
  }
}

// View
BlocBuilder<BooksBloc, BooksState>(
  builder: (context, state) {
    if (state is BooksLoading) return LoadingIndicator();
    if (state is BooksLoaded) return BooksList(state.books);
    if (state is BooksError) return ErrorWidget(state.message);
  },
)
```

---

## Decision Rules

### Rule #1: Screen Classification

**Count the number of BLoCs used in the screen:**

```
Screen dùng bao nhiêu BLoCs?
│
├── 0 BLoCs (Stateless) → SIMPLE SCREEN
│   └── Location: features/[name]/presentation/pages/
│
├── 1 BLoC → SIMPLE SCREEN
│   └── Location: features/[name]/presentation/pages/
│
└── ≥2 BLoCs → COMPOSITE SCREEN
    └── Location: screens/composite/[name]/
```

**How to count:**
Look at `BlocProvider` or `MultiBlocProvider` - count the number of BLoC providers.

**Current Examples:**

| Screen | BLoCs Used | Count | Location |
|--------|-----------|-------|----------|
| **BookDetailsScreen** | None (Stateless) | 0 | `features/books/presentation/pages/` |
| **DashboardScreen** | BooksBloc + SearchBloc + StatsBloc | 3 | `screens/composite/dashboard/` |
| **BookListScreen** | BooksBloc + SearchBloc | 2 | `screens/composite/book_list/` |

---

### Rule #2: Component vs Feature

**Does it have a business domain?**

```
Has independent business domain?
(models, repositories, datasources)
│
├── YES → FEATURE
│   └── Location: features/[name]/
│   └── Structure: data/ + presentation/
│
└── NO → COMPONENT
    │
    ├── Has API call + BLoC? → CONNECTED COMPONENT
    │   └── Location: core/widgets/connected/[name]/
    │
    ├── Aggregates feature data? → FEATURE WIDGET
    │   └── Location: features/[name]/presentation/widgets/
    │
    └── Pure UI only? → PRESENTATIONAL COMPONENT
        └── Location: core/widgets/presentational/[category]/
```

**Current Examples:**

| Name | Type | Reason | Location |
|------|------|--------|----------|
| **Books** | Feature | Has business domain (Book model, Repository, DataSource) | `features/books/` |
| **Search** | Connected Component | Has BLoC but NO business domain, reusable | `core/widgets/connected/search_bar/` |
| **Stats** | Feature Widget | Aggregates Books data, specific to Books feature | `features/books/presentation/widgets/stats/` |
| **AppButton** | Presentational Component | Pure UI, no API | `core/widgets/presentational/buttons/` |

---

## Core Folders Explained

### core/constants/
App-wide constants và configuration

**Files:**
- `api_constants.dart` - API URLs, endpoints, timeouts

### core/di/
Dependency Injection setup với GetIt

**Files:**
- `injection_container.dart` - Register all dependencies

**Pattern:**
```dart
// Singleton
sl.registerLazySingleton(() => http.Client());
sl.registerLazySingleton(() => BooksRepository(...));

// Factory (new instance mỗi lần)
sl.registerFactory(() => BooksBloc(...));
```

### core/network/
HTTP client và interceptors

**Files:**
- `dio_client.dart` - Configured Dio client
- `auth_interceptor.dart` - Authentication interceptor

### core/errors/
Error handling classes

**Files:**
- `exceptions.dart` - Technical errors cho Data Layer (ServerException, CacheException)
- `failures.dart` - Business errors cho Presentation (ServerFailure, CacheFailure)

**Pattern:**
```dart
// Data Layer throws Exceptions
throw ServerException();

// Repository catches và returns Failures
return Left(ServerFailure());
```

### core/widgets/
Reusable widgets

#### connected/
Widgets WITH API calls nhưng KHÔNG có business domain

**Current:**
- `search_bar/` - Search component với SearchBloc

**Characteristics:**
- ✅ Has BLoC for state management
- ✅ Makes API calls hoặc uses repositories
- ❌ NO business domain (no models/repositories of its own)
- ✅ Reusable across features

#### presentational/
Pure UI widgets, NO API calls

**Categories:**
- `buttons/` - AppButton, IconButtonCustom
- `cards/` - BaseCard
- `common/` - ErrorWidgetCustom, EmptyStateWidget
- `inputs/` - TextFieldCustom
- `loading/` - LoadingIndicator

**Characteristics:**
- ✅ Pure UI components
- ❌ NO API calls
- ❌ NO BLoC
- ✅ Highly reusable

---

## Features Folder Structure

### When to Create a Feature?

Create a feature khi có **business domain** với:
- ✅ Business models (Book, User, Order, etc.)
- ✅ Data sources (API calls, local storage)
- ✅ Repositories (data access logic)
- ✅ Business logic (BLoC)

### Feature Structure (2 Layers)

```
features/
└── [feature_name]/
    ├── data/                    # DATA LAYER
    │   ├── datasources/         # API calls, local storage
    │   ├── models/              # Data models (JSON parsing)
    │   └── repositories/        # Concrete repositories
    └── presentation/            # PRESENTATION LAYER
        ├── bloc/                # BLoC (Events, States, BLoC)
        ├── pages/               # Simple screens (1 BLoC only)
        └── widgets/             # Feature-specific widgets
```

### Current Feature: Books

**Structure:**
```
features/books/
├── data/
│   ├── datasources/
│   │   └── books_remote_datasource.dart
│   ├── models/
│   │   └── book_model.dart
│   └── repositories/
│       └── books_repository.dart
└── presentation/
    ├── bloc/
    │   ├── books_event.dart
    │   ├── books_state.dart
    │   └── books_bloc.dart
    ├── pages/
    │   └── book_details_screen.dart
    └── widgets/
        ├── book_card.dart
        ├── book_list_shimmer.dart
        └── stats/
            ├── stats_bloc.dart
            ├── stats_event.dart
            └── stats_state.dart
```

**Why Stats is a Feature Widget?**
- ❌ NOT a separate feature (no own data/repositories)
- ✅ Aggregates Books data
- ✅ Specific to Books feature
- ✅ Has own BLoC for stats calculation

---

## Screens Folder Structure

### When to Use screens/composite/?

Use `screens/composite/` when screen uses **≥2 BLoCs**

### Current Composite Screens

#### 1. DashboardScreen
**Location:** `screens/composite/dashboard/dashboard_screen.dart`

**Uses 3 BLoCs:**
1. `BooksBloc` - Books feature
2. `SearchBloc` - Search component
3. `StatsBloc` - Stats widget

**Structure:**
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => sl<BooksBloc>()..add(LoadBooksEvent())),
    BlocProvider(create: (_) => SearchBloc(repository: sl())),
    BlocProvider(create: (_) => StatsBloc()..add(LoadStatsEvent())),
  ],
  child: DashboardScreen(),
)
```

#### 2. BookListScreen
**Location:** `screens/composite/book_list/book_list_screen.dart`

**Uses 2 BLoCs:**
1. `BooksBloc` - Books feature
2. `SearchBloc` - Search component

**Structure:**
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => sl<BooksBloc>()..add(LoadBooksEvent())),
    BlocProvider(create: (_) => SearchBloc(repository: sl())),
  ],
  child: BookListScreen(),
)
```

---

## Best Practices

### ✅ DO

**Architecture:**
- ✅ Use 2-layer architecture (Data + Presentation)
- ✅ Use BLoC for ALL state management
- ✅ Use Repository pattern for data access
- ✅ Use Either type (dartz) for error handling
- ✅ Models serve as both business objects và DTOs

**Organization:**
- ✅ Count BLoCs to determine screen location
- ✅ Keep features independent from screens
- ✅ Use composition over inheritance
- ✅ Place reusable widgets in `core/widgets/`
- ✅ Create features only for business domains

**Naming:**
- ✅ Use descriptive names (BooksBloc, SearchBloc)
- ✅ Follow Dart naming conventions
- ✅ Use barrel exports (widgets.dart)

### ❌ DON'T

**Architecture:**
- ❌ Don't create Domain layer (no Use Cases, no Entities)
- ❌ Don't separate Entity và Model (Models ARE business objects)
- ❌ Don't use percentage-based rules for screen classification

**Organization:**
- ❌ Don't make screens "belong to" features
- ❌ Don't create features for every widget with API calls
- ❌ Don't couple features to specific screens
- ❌ Don't put composite screens in features/

**Code:**
- ❌ Don't mix business logic in widgets
- ❌ Don't access repositories directly from widgets
- ❌ Don't skip error handling

---

## Migration Guide

### Creating a New Screen

**Step 1: Count BLoCs**
```dart
// Check MultiBlocProvider
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => FeatureABloc()),   // 1
    BlocProvider(create: (_) => FeatureBBloc()),   // 2
  ],
  child: MyScreen(),
)
```

**Step 2: Determine Location**
- **0-1 BLoC** → Simple Screen → `features/[feature_name]/presentation/pages/`
- **≥2 BLoCs** → Composite Screen → `screens/composite/[screen_name]/`

**Step 3: Create File**
```dart
// Simple screen
features/books/presentation/pages/my_simple_screen.dart

// Composite screen
screens/composite/my_composite_screen/my_composite_screen.dart
```

### Creating a New Feature

**Step 1: Check if it's truly a feature**
- ✅ Has business domain? (models, repositories, datasources)
- ✅ Has independent business logic?
- ✅ Will be used across multiple screens?

**Step 2: Create folder structure**
```
features/
└── [new_feature]/
    ├── data/
    │   ├── datasources/
    │   │   └── [feature]_remote_datasource.dart
    │   ├── models/
    │   │   └── [model]_model.dart
    │   └── repositories/
    │       └── [feature]_repository.dart
    └── presentation/
        ├── bloc/
        │   ├── [feature]_event.dart
        │   ├── [feature]_state.dart
        │   └── [feature]_bloc.dart
        ├── pages/
        └── widgets/
```

**Step 3: Register dependencies in DI**
```dart
// injection_container.dart
// Data Sources
sl.registerLazySingleton(() => FeatureRemoteDataSource(client: sl()));

// Repositories
sl.registerLazySingleton(() => FeatureRepository(dataSource: sl()));

// BLoCs
sl.registerFactory(() => FeatureBloc(repository: sl()));
```

### Creating a Reusable Component

**Step 1: Determine component type**

**Has API call?**
- YES → Connected Component → `core/widgets/connected/[name]/`
- NO → Presentational Component → `core/widgets/presentational/[category]/`

**Step 2: Create structure**

**Connected Component:**
```
core/widgets/connected/
└── [component_name]/
    ├── [component]_widget.dart
    ├── [component]_bloc.dart
    ├── [component]_event.dart
    └── [component]_state.dart
```

**Presentational Component:**
```
core/widgets/presentational/
└── [category]/
    └── [component]_widget.dart
```

---

## Data Flow

### Complete Data Flow (API → UI)

```
User Action (Tap button)
    ↓
Widget dispatches Event
    ↓
BLoC receives Event
    ↓
BLoC calls Repository
    ↓
Repository calls DataSource
    ↓
DataSource makes API call
    ↓
API returns JSON
    ↓
DataSource parses to Model
    ↓
Repository returns Either<Failure, Model>
    ↓
BLoC emits new State
    ↓
Widget rebuilds with new data
```

### Example: Loading Books

```dart
// 1. User action
ElevatedButton(
  onPressed: () {
    context.read<BooksBloc>().add(LoadBooksEvent());
  },
)

// 2. BLoC receives event
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  Future<void> _onLoadBooks(...) async {
    emit(BooksLoading());                          // 3. Emit loading state
    final result = await repository.getAllBooks(); // 4. Call repository
    result.fold(
      (failure) => emit(BooksError(failure.message)),  // 5a. Error
      (books) => emit(BooksLoaded(books)),             // 5b. Success
    );
  }
}

// 6. Widget rebuilds
BlocBuilder<BooksBloc, BooksState>(
  builder: (context, state) {
    if (state is BooksLoading) return LoadingIndicator();
    if (state is BooksLoaded) return BooksList(state.books);
    if (state is BooksError) return ErrorWidget(state.message);
  },
)
```

---

## Quick Reference

### Screen Location Guide

| BLoC Count | Screen Type | Location |
|------------|-------------|----------|
| 0 BLoCs (Stateless) | Simple Screen | `features/[name]/presentation/pages/` |
| 1 BLoC | Simple Screen | `features/[name]/presentation/pages/` |
| ≥2 BLoCs | Composite Screen | `screens/composite/[name]/` |

### Component Location Guide

| Component Type | Location |
|---------------|----------|
| Feature (has business domain) | `features/[name]/` |
| Connected Component (API + BLoC, no domain) | `core/widgets/connected/[name]/` |
| Feature Widget (aggregates feature data) | `features/[name]/presentation/widgets/` |
| Presentational Component (pure UI) | `core/widgets/presentational/[category]/` |

### File Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| BLoC | `[name]_bloc.dart` | `books_bloc.dart` |
| Event | `[name]_event.dart` | `books_event.dart` |
| State | `[name]_state.dart` | `books_state.dart` |
| Model | `[name]_model.dart` | `book_model.dart` |
| Repository | `[name]_repository.dart` | `books_repository.dart` |
| DataSource | `[name]_datasource.dart` | `books_remote_datasource.dart` |
| Screen | `[name]_screen.dart` | `dashboard_screen.dart` |
| Widget | `[name]_widget.dart` | `search_bar_widget.dart` |

---

## Common Patterns

### Error Handling Pattern

```dart
// Data Layer - Throw Exceptions
class BooksRemoteDataSource {
  Future<List<BookModel>> getAllBooks() async {
    try {
      final response = await client.get(url);
      if (response.statusCode == 200) {
        return parseBooks(response.body);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}

// Repository - Convert to Failures
class BooksRepository {
  Future<Either<Failure, List<BookModel>>> getAllBooks() async {
    try {
      final books = await remoteDataSource.getAllBooks();
      return Right(books);
    } on ServerException {
      return Left(ServerFailure('Failed to fetch books'));
    }
  }
}

// BLoC - Handle Failures
Future<void> _onLoadBooks(...) async {
  emit(BooksLoading());
  final result = await repository.getAllBooks();
  result.fold(
    (failure) => emit(BooksError(failure.message)),
    (books) => emit(BooksLoaded(books)),
  );
}
```

### Dependency Injection Pattern

```dart
// 1. Register in injection_container.dart
Future<void> initializeDependencies() async {
  // External
  sl.registerLazySingleton(() => http.Client());

  // Data Sources (Singleton)
  sl.registerLazySingleton<BooksRemoteDataSource>(
    () => BooksRemoteDataSourceImpl(client: sl()),
  );

  // Repositories (Singleton)
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepository(remoteDataSource: sl()),
  );

  // BLoCs (Factory - new instance each time)
  sl.registerFactory(() => BooksBloc(repository: sl()));
  sl.registerFactory(() => SearchBloc(repository: sl()));
}

// 2. Use in widgets
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BooksBloc>()..add(LoadBooksEvent()),
      child: MyScreenView(),
    );
  }
}
```

### BLoC Pattern

```dart
// Event
abstract class BooksEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadBooksEvent extends BooksEvent {}

// State
abstract class BooksState extends Equatable {
  @override
  List<Object> get props => [];
}

class BooksInitial extends BooksState {}
class BooksLoading extends BooksState {}
class BooksLoaded extends BooksState {
  final List<BookModel> books;
  BooksLoaded(this.books);

  @override
  List<Object> get props => [books];
}
class BooksError extends BooksState {
  final String message;
  BooksError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final BooksRepository repository;

  BooksBloc({required this.repository}) : super(BooksInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(BooksLoading());
    final result = await repository.getAllBooks();
    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books)),
    );
  }
}
```

---

## Testing Strategy

### Unit Tests

**Test Hierarchy:**
```
test/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
└── presentation/
    └── bloc/
```

**What to Test:**
- ✅ BLoC logic (events → states)
- ✅ Repository logic (data fetching, error handling)
- ✅ Model parsing (JSON → Model)
- ✅ DataSource calls (API integration)

### Widget Tests

**What to Test:**
- ✅ UI rendering với different states
- ✅ User interactions (tap, scroll, input)
- ✅ State changes trigger UI updates

### Integration Tests

**What to Test:**
- ✅ Complete user flows
- ✅ Multiple features working together
- ✅ Navigation between screens

---

## References

### Documentation
- **Flutter Architecture Guide**: https://docs.flutter.dev/app-architecture/guide
- **BLoC Pattern**: https://bloclibrary.dev/
- **MVVM Pattern**: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel
- **Repository Pattern**: https://docs.flutter.dev/app-architecture/design-patterns/repository

### Packages
- **flutter_bloc**: https://pub.dev/packages/flutter_bloc
- **get_it**: https://pub.dev/packages/get_it
- **dartz**: https://pub.dev/packages/dartz
- **equatable**: https://pub.dev/packages/equatable

---

## Project Statistics

| Metric | Count |
|--------|-------|
| **Total Features** | 1 (Books) |
| **Total Screens** | 3 (2 Composite + 1 Simple) |
| **Total BLoCs** | 3 (Books, Search, Stats) |
| **Total Connected Components** | 1 (SearchBar) |
| **Total Presentational Components** | 7 |
| **Architecture Layers** | 2 (Data + Presentation) |

---

**Last Updated:** 2026-02-02
**Maintained By:** Development Team
