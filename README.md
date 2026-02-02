# 📚 Stephen King Books App

> Ứng dụng Flutter hiện đại được xây dựng theo **Clean Architecture**, **BLoC Pattern**, và **Hybrid Architecture** - Showcase tốt nhất về cách tổ chức code professional trong Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.10.7-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.7-0175C2?logo=dart)
![BLoC](https://img.shields.io/badge/BLoC-8.1.6-blue)
![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-green)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📖 MỤC LỤC

- [Giới Thiệu](#-giới-thiệu)
- [Features](#-features)
- [Kiến Trúc](#-kiến-trúc)
- [Cấu Trúc Project](#-cấu-trúc-project)
- [Tech Stack](#-tech-stack)
- [Cài Đặt](#-cài-đặt)
- [Hướng Dẫn Sử Dụng](#-hướng-dẫn-sử-dụng)
- [Tài Liệu Chi Tiết](#-tài-liệu-chi-tiết)

---

## 🎯 GIỚI THIỆU

**Stephen King Books App** là một ứng dụng Flutter showcase hiển thị danh sách sách của tác giả Stephen King. Project này được xây dựng như một **reference architecture** để demonstrate best practices trong Flutter development.

### 🎓 Mục Đích Project

Project này phục vụ như một **learning resource** và **production-ready template** cho:

- ✅ **Clean Architecture** implementation
- ✅ **BLoC Pattern** cho state management
- ✅ **Hybrid Architecture** cho folder organization (Component-Based + Feature-First)
- ✅ **Dependency Injection** với GetIt
- ✅ **Error Handling** với Either type (dartz)
- ✅ **API Integration** best practices
- ✅ **UI/UX** modern design với Material Design 3

### 🌟 Điểm Nổi Bật

- **Production-Ready**: Code structure sẵn sàng cho production apps
- **Scalable**: Dễ dàng thêm features mới
- **Maintainable**: Code rõ ràng, dễ bảo trì
- **Testable**: Architecture hỗ trợ testing tốt
- **Well-Documented**: Documentation đầy đủ và chi tiết

---

## ✨ FEATURES

### 🖥️ 3 Màn Hình Chính

#### 📊 **Dashboard Screen**
Composite Screen: **Books Feature** + **Search Component** + **Stats Widget**

**Features:**
- 📈 Real-time statistics overview (Total Books, Total Pages, Average Pages, Year Range)
- 🔍 Quick search functionality với debounce (500ms)
- 📚 Recent books carousel hiển thị 5 cuốn gần nhất
- 🔄 Pull-to-refresh support
- 🎨 Beautiful gradient stat cards với color coding

**Vị trí:** `screens/composite/dashboard/dashboard_screen.dart` (Composite Screen - ≥2 features)

---

#### 📚 **Book List Screen**
Composite Screen: **Books Feature** + **Search Component**

**Features:**
- 📋 Complete catalog of Stephen King books (63 books)
- 🔍 Advanced search by title, publisher, or year
- ✨ Shimmer loading animations
- 🎭 Empty and error states với retry functionality
- 🎨 Color-coded book cards by publication year
- 📊 Search result count display
- 🔄 Pull-to-refresh

**Vị trí:** `screens/composite/book_list/book_list_screen.dart` (Composite Screen - ≥2 features)

---

#### 📖 **Book Details Screen**
Simple Screen sử dụng 1 feature: **Books**

**Features:**
- 🎨 Expandable SliverAppBar với gradient background
- 📝 Comprehensive book information (Title, Year, Publisher, ISBN, Pages)
- 🆔 Quick stats section (ID, Decade)
- 🌈 Year-based color theming
- 📜 Smooth scrolling experience

**Vị trí:** `features/books/presentation/pages/book_details_screen.dart` (Simple Screen - 1 feature)

---

## 🏗️ KIẾN TRÚC

### Tổng Quan

Project này implement **3 patterns chính** kết hợp với nhau:

```
┌─────────────────────────────────────────────────────────┐
│        HYBRID ARCHITECTURE                              │
│   (Component-Based + Feature-First Organization)        │
│                                                          │
│   ┌─────────────────────────────────────────────┐      │
│   │       CLEAN ARCHITECTURE                    │      │
│   │   (3 Layers: Domain → Data → Presentation) │      │
│   │                                              │      │
│   │   ┌─────────────────────────────────┐      │      │
│   │   │      BLOC PATTERN               │      │      │
│   │   │   (Reactive State Management)   │      │      │
│   │   └─────────────────────────────────┘      │      │
│   └─────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────┘
```

### Clean Architecture - 3 Layers

#### **1. Domain Layer** (Business Logic Core)
**Vai trò:** Chứa business logic thuần túy, độc lập với framework

```dart
domain/
├── entities/         # Business objects (Book)
├── repositories/     # Repository contracts (interfaces)
└── usecases/        # Business use cases (GetAllBooks, SearchBooks)
```

**Đặc điểm:**
- ✅ Không phụ thuộc Flutter framework
- ✅ Không phụ thuộc Data Layer
- ✅ Pure Dart code
- ✅ Chứa business rules

---

#### **2. Data Layer** (Data Management)
**Vai trò:** Quản lý data từ API, Database, Cache

```dart
data/
├── datasources/      # API calls, local storage (BooksRemoteDataSource)
├── models/          # Data models với JSON parsing (BookModel)
└── repositories/    # Implement Domain repository contracts
```

**Đặc điểm:**
- ✅ Implement Repository interfaces từ Domain
- ✅ Handle API calls, caching
- ✅ Convert Models ↔ Entities
- ✅ Handle technical errors (Exceptions)

---

#### **3. Presentation Layer** (UI & State Management)
**Vai trò:** UI components và BLoC state management

```dart
presentation/
├── bloc/            # BLoC logic (Events, States, BLoC)
├── pages/           # Full screens
└── widgets/         # Reusable UI components
```

**Đặc điểm:**
- ✅ BLoC Pattern cho state management
- ✅ Gọi Use Cases từ Domain
- ✅ Reactive UI với Streams
- ✅ Handle business errors (Failures)

---

### BLoC Pattern

**BLoC (Business Logic Component)** tách biệt business logic khỏi UI:

```
┌──────────┐      Events        ┌──────────┐      States      ┌──────────┐
│    UI    │  ───────────────>  │   BLoC   │  ───────────────> │    UI    │
│ (Widgets)│   (User Actions)   │ (Logic)  │  (State Changes) │ (Rebuild)│
└──────────┘                     └──────────┘                   └──────────┘
```

**Thành phần:**
1. **Events** - User actions (LoadBooksEvent, SearchBooksEvent)
2. **States** - UI states (BooksLoading, BooksLoaded, BooksError)
3. **BLoC** - Process events → call use cases → emit states

**Ví dụ:**
```dart
// User action
context.read<BooksBloc>().add(LoadBooksEvent());

// BLoC processes
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  Future<void> _onLoadBooks(...) async {
    emit(BooksLoading());                    // 1. Loading state
    final result = await getAllBooks();      // 2. Call use case
    result.fold(
      (failure) => emit(BooksError(...)),    // 3a. Error state
      (books) => emit(BooksLoaded(books)),   // 3b. Success state
    );
  }
}

// UI listens
BlocBuilder<BooksBloc, BooksState>(
  builder: (context, state) {
    if (state is BooksLoading) return LoadingIndicator();
    if (state is BooksLoaded) return BooksList(state.books);
    if (state is BooksError) return ErrorWidget(state.message);
  },
)
```

---

### Dependency Injection (GetIt)

**GetIt** là Service Locator pattern để manage dependencies:

```dart
// Setup trong injection_container.dart
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  sl.registerLazySingleton(() => http.Client());

  // Data Sources
  sl.registerLazySingleton<BooksRemoteDataSource>(
    () => BooksRemoteDataSourceImpl(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAllBooks(repository: sl()));

  // BLoCs (Factory - new instance mỗi screen)
  sl.registerFactory(() => BooksBloc(
    getAllBooks: sl(),
    searchBooks: sl(),
  ));
}
```

**Pattern:**
- `Lazy Singleton`: Tạo 1 lần, dùng chung (HTTP Client, Repository, Use Case)
- `Factory`: Tạo mới mỗi lần (BLoC - mỗi screen 1 instance riêng)

---

## 📂 CẤU TRÚC PROJECT

### Cấu Trúc Folder

```
lib/
├── core/                      # 🔧 Core utilities - Code dùng chung
│   ├── constants/            # API constants, app constants
│   │   └── api_constants.dart
│   ├── di/                   # Dependency Injection (GetIt)
│   │   └── injection_container.dart
│   ├── network/              # HTTP client & interceptors
│   │   ├── dio_client.dart
│   │   └── auth_interceptor.dart
│   ├── errors/               # Error handling
│   │   ├── exceptions.dart   # Technical errors (Data Layer)
│   │   └── failures.dart     # Business errors (Domain/Presentation)
│   └── widgets/              # Reusable widgets
│       ├── connected/        # Widgets WITH API calls (NO business domain)
│       │   └── search_bar/   # Search component with BLoC
│       │       ├── search_bar_widget.dart
│       │       ├── search_bloc.dart
│       │       ├── search_event.dart
│       │       └── search_state.dart
│       └── presentational/   # Pure UI widgets (NO API)
│           ├── buttons/      # AppButton, IconButtonCustom
│           ├── cards/        # BaseCard
│           ├── inputs/       # TextFieldCustom
│           ├── loading/      # LoadingIndicator
│           └── common/       # ErrorWidgetCustom, EmptyStateWidget
│
├── features/                  # 🎯 Business Features (Domain-Driven)
│   │
│   ├── books/                # 📚 Books Feature (ONLY real feature)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── books_remote_datasource.dart  # API calls
│   │   │   ├── models/
│   │   │   │   └── book_model.dart               # JSON ↔ Dart
│   │   │   └── repositories/
│   │   │       └── books_repository_impl.dart    # Repository implementation
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── book.dart                     # Business object
│   │   │   ├── repositories/
│   │   │   │   └── books_repository.dart         # Repository contract
│   │   │   └── usecases/
│   │   │       ├── get_all_books.dart            # Use case: Get all
│   │   │       └── search_books.dart             # Use case: Search
│   │   │
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── books_event.dart              # Events
│   │       │   ├── books_state.dart              # States
│   │       │   └── books_bloc.dart               # BLoC logic
│   │       ├── pages/                            # Simple screens (1 feature)
│   │       │   └── book_details_screen.dart
│   │       └── widgets/
│   │           ├── book_card.dart                # Book card component
│   │           ├── book_list_shimmer.dart        # Shimmer loading
│   │           └── stats/                        # Stats widget (aggregates Books data)
│   │               ├── stats_bloc.dart
│   │               ├── stats_event.dart
│   │               └── stats_state.dart
│
└── screens/                   # 📱 Composite Screens
    └── composite/
        ├── dashboard/
        │   └── dashboard_screen.dart      # Books feature + Search component + Stats widget
        └── book_list/
            └── book_list_screen.dart      # Books feature + Search component
│
└── main.dart                  # App entry point
```

### Vai Trò Từng Folder

#### **core/** - Shared Code
| Folder | Vai Trò | Ví Dụ |
|--------|---------|-------|
| `constants/` | App-wide constants | API URLs, keys, config |
| `di/` | Dependency Injection setup | GetIt registration |
| `network/` | HTTP client & interceptors | DioClient, AuthInterceptor |
| `errors/` | Error handling classes | Exceptions, Failures |
| `widgets/connected/` | Widgets WITH API calls | SearchBar, UserPicker (future) |
| `widgets/presentational/` | Pure UI widgets (NO API) | Buttons, Cards, Inputs |

#### **features/** - Business Logic
Mỗi feature có **3 layers** đầy đủ:

| Layer | Vai Trò | Files |
|-------|---------|-------|
| **domain/** | Business logic core | Entities, Repository contracts, Use Cases |
| **data/** | Data management | Models, Data Sources, Repository implementation |
| **presentation/** | UI & State | BLoC (Events/States/Logic), Widgets |

#### **screens/composite/** - Composite Screens
**Quy tắc (Hybrid Architecture):**
- Screen dùng **≥2 features (BLoCs)** → `screens/composite/[name]/`
- Screen dùng **1 feature (BLoC)** → `features/[name]/presentation/pages/`

**Cách phân loại:**
Count số BLoCs trong MultiBlocProvider:
- 1 BLoC → Simple Screen → Features
- ≥2 BLoCs → Composite Screen → Screens/Composite

---

## 🛠️ TECH STACK

### Dependencies

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.6       # BLoC pattern implementation
  equatable: ^2.0.5           # Value equality cho Events/States

  # Networking
  http: ^1.2.2                # HTTP client cho API calls

  # Dependency Injection
  get_it: ^8.0.3              # Service Locator pattern

  # Functional Programming
  dartz: ^0.10.1              # Either type cho error handling

  # UI Components
  cached_network_image: ^3.4.1  # Image caching
  shimmer: ^3.0.0               # Shimmer loading effect

  # Icons
  cupertino_icons: ^1.0.8
```

### Tại Sao Dùng Các Package Này?

| Package | Lý Do Sử Dụng |
|---------|---------------|
| **flutter_bloc** | Standard cho BLoC pattern, community support tốt |
| **equatable** | So sánh objects dễ dàng, prevent unnecessary rebuilds |
| **http** | Lightweight HTTP client, dễ test |
| **get_it** | Simple DI solution, không cần code generation |
| **dartz** | Either type cho functional error handling |
| **shimmer** | Professional loading animation |

---

## 🚀 CÀI ĐẶT

### Prerequisites

- **Flutter SDK** ≥ 3.10.7
- **Dart SDK** ≥ 3.10.7
- IDE: VS Code hoặc Android Studio

### Steps

#### 1. Clone Repository
```bash
git clone <repository-url>
cd project_base_flutter
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Run App
```bash
# Run trên device/emulator đang kết nối
flutter run

# Run trên iOS simulator
flutter run -d ios

# Run trên Android emulator
flutter run -d android

# Run trên Chrome
flutter run -d chrome
```

#### 4. Build App (Optional)
```bash
# Build APK (Android)
flutter build apk --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web
```

### Supported Platforms

- ✅ **iOS** - iPhone, iPad
- ✅ **Android** - Phones, Tablets
- ✅ **macOS** - Desktop
- ✅ **Windows** - Desktop
- ✅ **Linux** - Desktop
- ✅ **Web** - Chrome, Safari, Firefox

---

## 💡 HƯỚNG DẪN SỬ DỤNG

### Quick Start

1. **Launch App**
   - App sẽ mở Dashboard screen
   - Tự động load danh sách sách và statistics

2. **Navigate**
   - Bottom Navigation: Chuyển giữa Dashboard và Book List
   - Tap vào sách: Xem chi tiết

3. **Search Books**
   - Type vào search bar
   - Search by: Title, Publisher, Year
   - Debounced 500ms (tối ưu performance)

4. **Refresh Data**
   - Pull-to-refresh trên Dashboard hoặc Book List

### App Flow

```
Launch App
    ↓
Main Navigation Screen
    ├─→ Tab 1: Dashboard
    │   ├─ Statistics Overview
    │   ├─ Search Bar (quick search)
    │   └─ Recent Books (5 latest)
    │       └─ Tap Book → Book Details Screen
    │
    └─→ Tab 2: Book List
        ├─ Search Bar (full search)
        ├─ All Books (63 books)
        └─ Tap Book → Book Details Screen
```

### Features Demo

#### 📊 Statistics
- **Total Books**: Tổng số sách
- **Total Pages**: Tổng số trang
- **Average Pages**: Trung bình số trang/sách
- **Year Range**: Khoảng năm xuất bản (oldest → newest)

#### 🔍 Search
- **Multi-field**: Search title, publisher, year
- **Case-insensitive**: Không phân biệt hoa thường
- **Debounced**: 500ms delay để giảm API calls
- **Result count**: Hiển thị số kết quả tìm được

#### 🎨 UI Features
- **Color Coding**: Mỗi sách có màu theo năm xuất bản
- **Shimmer Loading**: Professional loading animation
- **Empty State**: Friendly message khi không có kết quả
- **Error State**: Error message + Retry button
- **Pull-to-refresh**: Refresh data

---

## 📖 TÀI LIỆU CHI TIẾT

### Documentation Files

| File | Nội Dung | Dành Cho |
|------|----------|----------|
| **[ARCHITECTURE_DETAILED.md](ARCHITECTURE_DETAILED.md)** | Kiến trúc chi tiết, BLoC pattern đầy đủ, code examples | Developers muốn hiểu sâu |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | Overview về architecture, patterns | Quick reference |
| **[FEATURES_SCREENS_GUIDE.md](FEATURES_SCREENS_GUIDE.md)** | Hướng dẫn tạo features và screens mới | Developers adding features |

### Đọc Gì Trước?

1. **Người mới**: Đọc **README.md** này trước
2. **Hiểu architecture**: Đọc **ARCHITECTURE.md**
3. **Hiểu chi tiết code**: Đọc **ARCHITECTURE_DETAILED.md**
4. **Thêm features**: Đọc **FEATURES_SCREENS_GUIDE.md**

### Key Topics trong ARCHITECTURE_DETAILED.md

- ✅ Clean Architecture 3 layers chi tiết
- ✅ BLoC Pattern với flow diagrams
- ✅ Entity vs Model - Tại sao tách biệt?
- ✅ Dependency Injection với GetIt
- ✅ Error Handling với Either type
- ✅ Data flow từ UI → API → UI
- ✅ Component-Based Architecture
- ✅ Best practices & Testing strategies

---

## 🧪 TESTING

### Test Structure

```
test/
├── unit/              # Unit tests
│   ├── domain/       # Use cases tests
│   ├── data/         # Repository, data source tests
│   └── presentation/ # BLoC tests
├── widget/           # Widget tests
└── integration/      # Integration tests
```

### Chạy Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/domain/usecases/get_all_books_test.dart

# Run với coverage
flutter test --coverage
```

### Test Coverage

Project này có comprehensive test coverage cho:
- ✅ Use Cases
- ✅ Repositories
- ✅ BLoC logic
- ✅ Widgets
- ✅ Integration flows

---

## 🎨 UI/UX DESIGN

### Design System

#### Color Palette
- **Primary**: Deep Purple (#673AB7), Indigo (#3F51B5)
- **Accent**: Blue, Teal, Green, Orange, Red
- **Year-based colors**: 8 colors cho book cards

#### Typography
- **Headings**: Bold, 20-24px
- **Body**: Regular, 14-16px
- **Captions**: 12px

#### Components
- **Cards**: Rounded corners (12px), elevation 2
- **Buttons**: Primary, Secondary styles
- **Inputs**: Outlined style với clear button
- **Loading**: Shimmer effect

### Material Design 3

App implement Material Design 3 principles:
- ✅ Color scheme từ seed color
- ✅ Dynamic theming
- ✅ Modern components (NavigationBar, etc.)

---

## 🤝 CONTRIBUTING

### Workflow

1. **Fork** repository
2. **Create feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Follow architecture patterns**
   - Organize by features
   - Follow Clean Architecture layers
   - Use BLoC for state management
4. **Write tests**
5. **Commit with clear messages**
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to branch**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open Pull Request**

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter analyze` để check issues
- Format code với `dart format`

---

## 📄 LICENSE

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 ACKNOWLEDGMENTS

- **Stephen King API** - [stephen-king-api.onrender.com](https://stephen-king-api.onrender.com)
- **Flutter Team** - Amazing framework
- **BLoC Library** - Excellent state management
- **Clean Architecture** - Uncle Bob's principles
- **Community** - Packages và resources

---

## 📧 SUPPORT

### Có câu hỏi?

- 📖 Đọc [ARCHITECTURE_DETAILED.md](ARCHITECTURE_DETAILED.md)
- 🐛 Report bugs: [GitHub Issues](https://github.com/your-repo/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/your-repo/discussions)

### Contact

- **Email**: your-email@example.com
- **GitHub**: [@yourusername](https://github.com/yourusername)

---

## 🎓 LEARNING RESOURCES

### Recommended Reading

1. **Clean Architecture**
   - [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
   - [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)

2. **BLoC Pattern**
   - [BLoC Library Docs](https://bloclibrary.dev)
   - [BLoC Architecture](https://www.didierboelens.com/2018/08/reactive-programming-streams-bloc/)

3. **Flutter Best Practices**
   - [Flutter Docs](https://flutter.dev/docs)
   - [Effective Dart](https://dart.dev/guides/language/effective-dart)

### Video Tutorials

- [Flutter BLoC Pattern Tutorial](https://www.youtube.com/watch?v=THCkkQ-V1-8)
- [Clean Architecture in Flutter](https://www.youtube.com/watch?v=dc3B_mMrZ-Q)

---

## 🗺️ ROADMAP

### Current Version: 1.0.0

### Planned Features

- [ ] Local caching với Hive/SQLite
- [ ] Dark mode support
- [ ] Favorites functionality
- [ ] Reading progress tracker
- [ ] Book reviews and ratings
- [ ] Share books
- [ ] Advanced filtering
- [ ] Offline mode

---

## 📊 PROJECT STATS

| Metric | Value |
|--------|-------|
| **Lines of Code** | ~3,000 |
| **Features** | 3 (Books, Search, Stats) |
| **Screens** | 3 (Dashboard, Book List, Details) |
| **Widgets** | 10+ reusable components |
| **Tests** | Comprehensive coverage |
| **API Calls** | 1 endpoint (63 books) |

---

## 💻 DEVELOPMENT

### Project Structure Stats

```
Total Files: 50+
├── Dart Files: 35+
├── Test Files: 10+
└── Config Files: 5+

Total Features: 3
├── Books (Full: Domain + Data + Presentation)
├── Search (Presentation only)
└── Stats (Presentation only)

Total Screens: 3
├── Dashboard (Composite: 3 features)
├── Book List (Composite: 2 features)
└── Book Details (Simple: 1 feature)
```

---

## 🌟 SHOWCASE

### Screenshots

> _Add screenshots here_

### Demo Video

> _Add demo video link here_

---

## ⭐ STAR HISTORY

If you find this project helpful, please give it a ⭐️!

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/project-name&type=Date)](https://star-history.com/#yourusername/project-name&Date)

---

<div align="center">

### 🎉 Thank you for using Stephen King Books App!

**Built with ❤️ using Flutter & Clean Architecture**

[⬆ Back to Top](#-stephen-king-books-app)

---

*Last Updated: 2026-02-02*

</div>
