# Composite Screens

Screens that use ≥2 features (BLoCs) according to Hybrid Architecture.

## Folder Purpose

According to Hybrid Architecture:
- **Simple Screen (1 feature)** → `features/[name]/presentation/pages/`
- **Composite Screen (≥2 features)** → `screens/composite/[name]/`

## Classification Rule

Count the number of features (BLoCs) in MultiBlocProvider:
- 1 BLoC → Simple Screen → `features/[name]/presentation/pages/`
- ≥2 BLoCs → Composite Screen → `screens/composite/[name]/`

## Current Composite Screens

### DashboardScreen (3 features)
- Location: `screens/composite/dashboard/`
- Features used:
  - BooksBloc (Books feature)
  - SearchBloc (Search feature)
  - StatsBloc (Stats feature)

### BookListScreen (2 features)
- Location: `screens/composite/book_list/`
- Features used:
  - BooksBloc (Books feature)
  - SearchBloc (Search feature)

## MVVM Pattern (Optional)

Composite screens can optionally use ViewModel layer:
- `[screen_name]_screen.dart`: View layer
- `[screen_name]_viewmodel.dart`: ViewModel layer (optional)

ViewModel coordinates multiple BLoCs if needed.

## Composition Pattern

Screens COMPOSE FROM features:
- ✅ Screens use feature components (widgets)
- ✅ Screens coordinate multiple features
- ✅ Features remain independent
- ❌ Screens DO NOT "belong to" features
