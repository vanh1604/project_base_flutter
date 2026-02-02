# Project Structure - Hybrid Architecture

**Version:** 1.0
**Date:** 2026-02-02
**Architecture:** MVVM + BLoC + Hybrid Architecture (Folder Organization)

## Overview

This project follows **Hybrid Architecture** pattern based on Flutter best practices and industry standards. The architecture consists of three complementary layers:

1. **MVVM Pattern**: Presentation layer architecture (View ↔ ViewModel)
2. **BLoC Pattern**: State management (Events → BLoC → States)
3. **Hybrid Architecture**: Folder organization (Component-Based + Feature-First)

**Key Principle:**
Screens COMPOSE FROM features. Features remain independent and reusable.

---

## Folder Structure

```
lib/
├── core/
│   ├── di/                      # Dependency injection
│   ├── network/                 # HTTP client & interceptors
│   │   ├── dio_client.dart
│   │   └── auth_interceptor.dart
│   ├── constants/               # App constants
│   ├── errors/                  # Error handling
│   └── widgets/
│       ├── connected/           # Widgets WITH API calls
│       └── presentational/      # Pure UI widgets (NO API)
│           ├── buttons/
│           ├── inputs/
│           ├── loading/
│           ├── common/
│           └── cards/
│
├── features/                    # Business domains (Feature-First)
│   ├── books/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── repositories/
│   │   │   └── models/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/            # BLoC (State Management)
│   │       ├── pages/           # Simple screens (1 feature only)
│   │       └── widgets/         # Reusable feature components
│   │           └── stats/       # Stats widget (aggregates Books data)
│   │               ├── stats_bloc.dart
│   │               ├── stats_event.dart
│   │               └── stats_state.dart
│
└── screens/                     # Composite screens
    └── composite/
        ├── dashboard/
        │   └── dashboard_screen.dart   # Books feature + Search component + Stats widget
        └── book_list/
            └── book_list_screen.dart   # Books feature + Search component
```

---

## Decision Rules

### Rule #1: Screen Classification

**Count the number of features (BLoCs) used in the screen:**

```
Screen dùng bao nhiêu features?
│
├── 1 feature (1 BLoC) → SIMPLE SCREEN
│   └── Location: features/[name]/presentation/pages/
│
└── ≥2 features (≥2 BLoCs) → COMPOSITE SCREEN
    └── Location: screens/composite/[name]/
```

**How to count:**
Look at `MultiBlocProvider` - count the number of BLoC providers.

**Examples:**
- `LoginScreen` uses `AuthBloc` only → 1 feature → `features/auth/presentation/pages/`
- `DashboardScreen` uses `BooksBloc + SearchBloc + StatsBloc` → 1 feature + 2 components → `screens/composite/dashboard/`
  - Books = Feature (has domain)
  - Search = Connected Component (no domain, uses Books usecase)
  - Stats = Books Widget (no domain, aggregates Books data)

---

### Rule #2: Component vs Feature

**Does it have a business domain?**

```
Has independent business domain?
(entities, use cases, repositories)
│
├── YES → FEATURE
│   └── Location: features/[name]/
│
└── NO → COMPONENT
    │
    ├── Has API call? → CONNECTED COMPONENT
    │   └── Location: core/widgets/connected/
    │
    └── No API? → PRESENTATIONAL COMPONENT
        └── Location: core/widgets/presentational/
```

**Examples:**
- **Books**: Has Book entity, GetBooks usecase → Feature → `features/books/`
- **Search**: No business domain, uses Books usecase → Connected Component → `core/widgets/connected/search_bar/`
- **Stats**: No business domain, aggregates Books data → Books Widget → `features/books/presentation/widgets/stats/`
- **CustomButton**: Pure UI, no API → Presentational Component → `core/widgets/presentational/`

---

## Current Project Examples

### Composite Screens

| Screen | Components Used | Location |
|--------|----------------|----------|
| **DashboardScreen** | Books (feature) + Search (component) + Stats (widget) | `screens/composite/dashboard/` |
| **BookListScreen** | Books (feature) + Search (component) | `screens/composite/book_list/` |

### Simple Screens

| Screen | Features Used (BLoCs) | Location |
|--------|----------------------|----------|
| **BookDetailsScreen** | Books only (0 BLoC - stateless) | `features/books/presentation/pages/` |

### Features (TRUE Features with Business Domain)

| Feature | Domain | Location |
|---------|--------|----------|
| **Books** | Book management (ONLY real feature) | `features/books/` |

### Components (NOT Features)

| Component | Type | Reason | Location |
|-----------|------|--------|----------|
| **Search** | Connected Component | No business domain, uses Books usecase | `core/widgets/connected/search_bar/` |
| **Stats** | Books Widget | No business domain, aggregates Books data | `features/books/presentation/widgets/stats/` |

---

## Architecture Layers Explained

### 1. MVVM Pattern (Architecture Pattern)

Defines the relationship between View and ViewModel:
- **View**: Flutter widgets (Screens, Pages)
- **ViewModel**: Optional presentation logic layer (can be skipped)
- **Model**: Business logic (BLoC in this project)

**In this project:**
- Views directly use BLoC (no separate ViewModel layer)
- ViewModel is OPTIONAL - can be added later if needed

### 2. BLoC Pattern (State Management)

Handles business logic and state:
- **Events**: User actions
- **BLoC**: Business logic processor
- **States**: UI states

**Location:** `features/[name]/presentation/bloc/`

### 3. Hybrid Architecture (Folder Organization)

Combines Component-Based + Feature-First organization:
- **Features**: Business domains (data + domain + presentation)
- **Screens**: Compose FROM features
- **Core**: Shared utilities and components

---

## Best Practices

### ✅ DO

- Count BLoCs to determine screen location
- Keep features independent from screens
- Use composition over inheritance
- Place reusable components in `core/widgets/`
- Create features for business domains with entities/use cases

### ❌ DON'T

- Use percentage-based rules (e.g., "60% rule")
- Make screens "belong to" features
- Create features for every widget with API calls
- Couple features to specific screens

---

## Migration Guide

When creating a new screen:

1. **Count features (BLoCs):**
   ```dart
   MultiBlocProvider(
     providers: [
       BlocProvider(create: (_) => BooksBloc()),   // 1
       BlocProvider(create: (_) => SearchBloc()),  // 2
     ],
     child: MyScreen(),
   )
   ```
   → 2 BLoCs → Composite Screen → `screens/composite/my_screen/`

2. **If only 1 BLoC:**
   → Simple Screen → `features/[feature_name]/presentation/pages/`

3. **If no BLoC but displays data:**
   → Check if it's truly a simple screen or should have a BLoC

---

## References

- **Base Document**: [Composite_Screens_Best_Practices_Vietnamese.md](/Users/dreamabtme/Documents/sleepbuddy/docs/architecture/Composite_Screens_Best_Practices_Vietnamese.md)
- **Flutter Architecture Guide**: https://docs.flutter.dev/app-architecture/guide
- **Clean Architecture**: Uncle Bob's Clean Architecture principles
- **BLoC Pattern**: https://bloclibrary.dev/

---

## Quick Reference

| Scenario | Location |
|----------|----------|
| Screen uses 1 BLoC | `features/[name]/presentation/pages/` |
| Screen uses ≥2 BLoCs | `screens/composite/[name]/` |
| Widget has API + business domain | `features/[name]/` (Feature) |
| Widget has API but NO business domain | `core/widgets/connected/` (Component) |
| Widget is pure UI | `core/widgets/presentational/` (Component) |

---

**Last Updated:** 2026-02-02
**Maintained By:** Development Team
