# PROJECT STRUCTURE - Clean Architecture với MVVM + BLoC

Created: February 4, 2026

## Tổng quan (Overview)

Dự án này được xây dựng dựa trên kiến trúc **Clean Architecture** kết hợp **MVVM (Model-View-ViewModel)** với **BLoC (Business Logic Component)** theo cấu trúc **Feature-First**. Mục tiêu là tạo ra một ứng dụng có khả năng:

- **Bảo trì cao:** Cấu trúc rõ ràng, dễ mở rộng
- **Dễ kiểm thử:** "Testable by Design" - mọi thành phần kiểm chứng độc lập
- **Mở rộng đội ngũ:** Cấu trúc Feature-First giảm xung đột code

## Kiến trúc 3 Layers (Three-Tier Architecture)

Kiến trúc tuân thủ nguyên tắc **Dependency Rule**: Sự phụ thuộc chỉ đi từ ngoài vào trong (Outside → Inside).

```
┌─────────────────────────────────────────────────────────┐
│         PRESENTATION LAYER (UI & State)                 │
│  - Widgets, Pages                                       │
│  - BLoC/Cubit (ViewModel)                              │
│  - User Interaction                                     │
└────────────────────┬────────────────────────────────────┘
                     │ depends on ↓
┌────────────────────▼────────────────────────────────────┐
│         DOMAIN LAYER (Business Logic)                   │
│  - Entities (Pure Dart Objects)                        │
│  - Repository Interfaces                               │
│  - Use Cases (Interactors)                             │
└────────────────────┬────────────────────────────────────┘
                     │ depends on ↓
┌────────────────────▼────────────────────────────────────┐
│         DATA LAYER (Infrastructure)                     │
│  - Repository Implementations                          │
│  - Data Models (JSON Parsing)                          │
│  - Data Sources (API, Local DB)                        │
└─────────────────────────────────────────────────────────┘
```

### Layer Responsibilities

| Layer | Trách nhiệm | Đặc điểm |
|-------|------------|----------|
| **Presentation** | Hiển thị UI và quản lý trạng thái | - BLoC nhận Events, phát ra States<br>- View lắng nghe States và rebuild<br>- Không chứa logic nghiệp vụ |
| **Domain** | Chứa logic nghiệp vụ cốt lõi | - Hoàn toàn độc lập với Flutter<br>- Không biết về UI, Database, API<br>- Entities là POJO (Plain Old Dart Objects) |
| **Data** | Cung cấp dữ liệu cho Domain | - Giao tiếp với API, Database<br>- Parse JSON ↔ Models<br>- Implement Repository Interfaces |

---

## Cấu trúc Thư mục Tổng thể (Project Structure)

```
lib/
├── main_common.dart              # Cấu hình khởi chạy chung
├── main_dev.dart                 # Entry point môi trường Development
├── main_prod.dart                # Entry point môi trường Production
│
├── app/                          # Cấu hình toàn cục ứng dụng
│   ├── app.dart                  # Root Widget (MaterialApp/CupertinoApp)
│   ├── app_bloc_observer.dart    # Giám sát toàn bộ Events/States (Logging)
│   ├── theme/                    # Design System
│   │   ├── app_colors.dart       # Bảng màu ứng dụng
│   │   ├── app_text_styles.dart  # Typography system
│   │   └── app_theme.dart        # ThemeData configuration
│   └── routes/                   # Cấu hình điều hướng trung tâm
│       ├── app_router.dart       # Router configuration (GoRouter/AutoRoute)
│       └── app_routes.dart       # Định nghĩa tên routes (constants)
│
├── core/                         # Shared Kernel - Code dùng chung
│   ├── config/                   # Cấu hình môi trường
│   │   └── flavor_config.dart    # Dev/Staging/Production configs
│   │
│   ├── constants/                # Hằng số hệ thống
│   │   ├── api_constants.dart    # API URLs, endpoints
│   │   └── app_constants.dart    # Timeout, limits, defaults
│   │
│   ├── error/                    # Hệ thống xử lý lỗi
│   │   ├── exceptions.dart       # Lỗi kỹ thuật (ServerException, CacheException)
│   │   └── failures.dart         # Lỗi nghiệp vụ (ServerFailure, NetworkFailure)
│   │
│   ├── injections/               # Dependency Injection
│   │   └── service_locator.dart  # GetIt/Injectable configuration
│   │
│   ├── network/                  # Network Layer cơ sở
│   │   ├── api_client.dart       # Dio/Http Client configuration
│   │   ├── interceptors/         # HTTP Interceptors
│   │   │   ├── auth_interceptor.dart
│   │   │   └── logging_interceptor.dart
│   │   └── network_info.dart     # Internet connection checker
│   │
│   ├── usecases/                 # Base UseCase interface
│   │   └── usecase.dart          # Abstract class UseCase<Type, Params>
│   │
│   ├── utils/                    # Tiện ích bổ trợ
│   │   ├── date_converter.dart   # Date formatting utilities
│   │   ├── input_validator.dart  # Input validation helpers
│   │   └── extensions/           # Dart extensions
│   │       ├── string_ext.dart
│   │       ├── context_ext.dart
│   │       └── date_ext.dart
│   │
│   └── widgets/                  # Shared Widgets (Atomic Design)
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── loading_indicator.dart
│       └── error_widget.dart
│
├── features/                     # Feature Modules (Domain-Driven)
│   ├── books/                    # Ví dụ: Module quản lý sách
│   ├── auth/                     # Module xác thực
│   ├── home/                     # Module trang chủ
│   └── profile/                  # Module hồ sơ cá nhân
│
└── l10n/                         # Localization - Đa ngôn ngữ
    ├── arb/                      # Application Resource Bundle files
    │   ├── app_en.arb           # English translations
    │   └── app_vi.arb           # Vietnamese translations
    └── l10n.dart                 # Generated localization delegates
```

---

## Cấu trúc Chi tiết Feature Module

Mỗi feature là một **vertical slice** (lát cắt dọc) của ứng dụng, chứa đầy đủ 3 tầng Clean Architecture. Điều này đảm bảo tính đóng gói và khả năng tách module thành package riêng biệt.

### Ví dụ: Feature Books

```
features/books/
│
├── data/                                   # DATA LAYER
│   ├── datasources/                        # Nguồn dữ liệu thô
│   │   ├── book_remote_data_source.dart    # API calls (Retrofit/Dio)
│   │   └── book_local_data_source.dart     # Local storage (Hive/Isar/SQLite)
│   │
│   ├── models/                             # Data Transfer Objects (DTO)
│   │   └── book_model.dart                 # extends BookEntity + JSON parsing
│   │
│   └── repositories/                       # Repository Implementation
│       └── book_repository_impl.dart       # implements IBookRepository
│
├── domain/                                 # DOMAIN LAYER
│   ├── entities/                           # Business Objects
│   │   └── book_entity.dart                # Pure Dart class (Equatable, NO JSON)
│   │
│   ├── repositories/                       # Repository Interfaces
│   │   └── i_book_repository.dart          # Abstract class (Contract)
│   │
│   └── usecases/                           # Business Logic (Interactors)
│       ├── get_books_usecase.dart          # Logic lấy danh sách sách
│       ├── get_book_detail_usecase.dart    # Logic lấy chi tiết sách
│       ├── add_book_usecase.dart           # Logic thêm sách mới
│       └── delete_book_usecase.dart        # Logic xóa sách
│
└── presentation/                           # PRESENTATION LAYER
    ├── bloc/                               # State Management (ViewModel)
    │   ├── book_bloc.dart                  # Logic xử lý Event → State
    │   ├── book_event.dart                 # Events (LoadBooks, FilterBooks)
    │   └── book_state.dart                 # States (Initial, Loading, Loaded, Error)
    │
    ├── pages/                              # Screens
    │   ├── book_list_page.dart             # Màn hình danh sách
    │   └── book_detail_page.dart           # Màn hình chi tiết
    │
    └── widgets/                            # Feature-specific widgets
        ├── book_card.dart                  # Widget hiển thị book item
        └── book_filter_bar.dart            # Widget filter/search
```

---

## Chi tiết Từng Layer

### 1. DOMAIN LAYER - Lõi Bất biến (The Immutable Core)

Domain Layer là **trái tim** của ứng dụng, chứa toàn bộ logic nghiệp vụ. Layer này hoàn toàn độc lập với Flutter, UI, Database, hay Network.

#### 1.1. Entities (Thực thể)

**Vai trò:** Đại diện cho các đối tượng nghiệp vụ cốt lõi.

**Đặc điểm:**
- Pure Dart classes (POJO - Plain Old Dart Objects)
- Sử dụng `Equatable` để so sánh giá trị (value equality)
- **KHÔNG** chứa logic `fromJson` / `toJson`
- **KHÔNG** phụ thuộc vào bất kỳ package nào khác ngoài Dart core

**Ví dụ:**
```dart
import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  final String id;
  final String title;
  final String author;
  final int publishYear;

  const BookEntity({
    required this.id,
    required this.title,
    required this.author,
    required this.publishYear,
  });

  @override
  List<Object?> get props => [id, title, author, publishYear];
}
```

#### 1.2. Repositories (Interfaces)

**Vai trò:** Định nghĩa ranh giới (boundary) giữa Domain và Data Layer.

**Đặc điểm:**
- Là `abstract class` (Interface/Contract)
- Trả về `Future<Either<Failure, Type>>` (Functional Error Handling)
- Không chứa implementation, chỉ định nghĩa hành vi

**Tại sao dùng Either?**
- Buộc xử lý cả hai trường hợp: Success và Failure
- Loại bỏ việc ném Exception (không dùng try-catch ở Presentation)
- Type-safe error handling

**Ví dụ:**
```dart
import 'package:fpdart/fpdart.dart';
import '../entities/book_entity.dart';

abstract class IBookRepository {
  Future<Either<Failure, List<BookEntity>>> getBooks();
  Future<Either<Failure, BookEntity>> getBookById(String id);
  Future<Either<Failure, Unit>> addBook(BookEntity book);
  Future<Either<Failure, Unit>> deleteBook(String id);
}
```

#### 1.3. Use Cases (Interactors)

**Vai trò:** Đóng gói một hành động nghiệp vụ cụ thể.

**Tại sao cần Use Case?**
- Giúp BLoC trở nên gọn nhẹ, chỉ cần gọi `useCase.call()`
- Tái sử dụng logic nghiệp vụ ở nhiều BLoC khác nhau
- Tách biệt logic nghiệp vụ khỏi Presentation

**Ví dụ:**
```dart
class GetBooksUseCase extends UseCase<List<BookEntity>, NoParams> {
  final IBookRepository repository;

  GetBooksUseCase(this.repository);

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) async {
    return await repository.getBooks();
  }
}
```

---

### 2. DATA LAYER - Cơ sở Hạ tầng (The Infrastructure)

Data Layer là "người phục vụ" cho Domain Layer. Mọi thay đổi về công nghệ (REST → GraphQL, SQLite → Hive) chỉ nên gói gọn trong layer này.

#### 2.1. Models (Data Transfer Objects)

**Vai trò:** Mở rộng Entity với khả năng serialize/deserialize.

**Đặc điểm:**
- `extends` Entity tương ứng
- Chứa logic `fromJson` / `toJson`
- Sử dụng `json_serializable` để tự động sinh code

**Ví dụ:**
```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/book_entity.dart';

part 'book_model.g.dart';

@JsonSerializable()
class BookModel extends BookEntity {
  const BookModel({
    required String id,
    required String title,
    required String author,
    required int publishYear,
  }) : super(
          id: id,
          title: title,
          author: author,
          publishYear: publishYear,
        );

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
```

#### 2.2. Data Sources (Nguồn dữ liệu)

**Vai trò:** Thực hiện các giao tiếp vật lý với API/Database.

##### Remote Data Source (API)
- Sử dụng Retrofit hoặc Dio
- Bắt các HTTP Exception và ném ra custom Exception

**Ví dụ:**
```dart
abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks();
  Future<BookModel> getBookById(String id);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final ApiClient client;

  BookRemoteDataSourceImpl(this.client);

  @override
  Future<List<BookModel>> getBooks() async {
    try {
      final response = await client.get('/books');
      return (response.data as List)
          .map((json) => BookModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message);
    }
  }
}
```

##### Local Data Source (Cache/Database)
- Sử dụng Hive, Isar, SQLite, hoặc SharedPreferences
- Bắt các Cache Exception

#### 2.3. Repository Implementation

**Vai trò:** Phối hợp dữ liệu từ nhiều nguồn và xử lý lỗi.

**Logic:**
1. Kiểm tra kết nối mạng
2. Nếu có mạng: gọi Remote Data Source → lưu vào Local → return
3. Nếu không có mạng: đọc từ Local Data Source
4. Convert Exception → Failure
5. Convert Model → Entity

**Ví dụ:**
```dart
class BookRepositoryImpl implements IBookRepository {
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BookEntity>>> getBooks() async {
    if (await networkInfo.isConnected) {
      try {
        final books = await remoteDataSource.getBooks();
        await localDataSource.cacheBooks(books);
        return Right(books); // Success
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message)); // Failure
      }
    } else {
      try {
        final cachedBooks = await localDataSource.getCachedBooks();
        return Right(cachedBooks);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

---

### 3. PRESENTATION LAYER - Giao diện và Quản lý Trạng thái

Presentation Layer là nơi MVVM + BLoC phát huy tác dụng, tách biệt hoàn toàn logic hiển thị khỏi UI.

#### 3.1. BLoC (Business Logic Component) - ViewModel

**Vai trò:** Quản lý State, xử lý Events, và giao tiếp với Domain Layer.

**Luồng hoạt động:**
1. View gửi **Event** → BLoC
2. BLoC xử lý Event → gọi **UseCase**
3. UseCase trả về kết quả
4. BLoC emit **State** mới
5. View lắng nghe State → rebuild UI

**Đặc điểm:**
- Sử dụng `freezed` để tạo Union Types cho State/Event
- **KHÔNG** chứa `BuildContext`
- **KHÔNG** gọi `Navigator` hay `ScaffoldMessenger` trực tiếp
- Chỉ giao tiếp với Domain Layer thông qua Use Cases

**Ví dụ Event:**
```dart
@freezed
class BookEvent with _$BookEvent {
  const factory BookEvent.loadBooks() = LoadBooks;
  const factory BookEvent.filterBooks(String query) = FilterBooks;
  const factory BookEvent.deleteBook(String id) = DeleteBook;
}
```

**Ví dụ State:**
```dart
@freezed
class BookState with _$BookState {
  const factory BookState.initial() = Initial;
  const factory BookState.loading() = Loading;
  const factory BookState.loaded(List<BookEntity> books) = Loaded;
  const factory BookState.error(String message) = Error;
}
```

**Ví dụ BLoC:**
```dart
class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooksUseCase getBooksUseCase;

  BookBloc({required this.getBooksUseCase}) : super(const BookState.initial()) {
    on<LoadBooks>(_onLoadBooks);
  }

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(const BookState.loading());

    final result = await getBooksUseCase(NoParams());

    result.fold(
      (failure) => emit(BookState.error(failure.message)),
      (books) => emit(BookState.loaded(books)),
    );
  }
}
```

#### 3.2. Pages (Screens)

**Vai trò:** Hiển thị UI và phản ứng với State từ BLoC.

**Đặc điểm:**
- Sử dụng `BlocProvider` để inject BLoC
- Sử dụng `BlocBuilder` để rebuild UI khi State thay đổi
- Sử dụng `BlocListener` cho side effects (navigation, snackbar)
- Sử dụng `BlocConsumer` khi cần cả hai

**Ví dụ:**
```dart
class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookBloc>()..add(const BookEvent.loadBooks()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Books')),
        body: BlocBuilder<BookBloc, BookState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const LoadingIndicator(),
              loaded: (books) => ListView.builder(
                itemCount: books.length,
                itemBuilder: (_, index) => BookCard(book: books[index]),
              ),
              error: (message) => ErrorWidget(message: message),
            );
          },
        ),
      ),
    );
  }
}
```

#### 3.3. Widgets (Feature-specific)

**Vai trò:** Các widget chỉ dùng cho feature cụ thể.

**Nguyên tắc:**
- Nếu widget dùng chung toàn app → đưa vào `core/widgets/`
- Nếu widget chỉ dùng trong feature → giữ trong `features/[feature]/presentation/widgets/`

---

## Data Flow - Luồng Dữ liệu Chi tiết

### Kịch bản: User nhấn nút "Load Books"

```
┌──────────────────────────────────────────────────────────────────┐
│ 1. USER INTERACTION                                              │
│    BookListPage → add(BookEvent.loadBooks())                     │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 2. PRESENTATION LAYER (BLoC)                                     │
│    BookBloc receives event                                       │
│    → emit(BookState.loading())                                   │
│    → call GetBooksUseCase(NoParams())                           │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 3. DOMAIN LAYER (Use Case)                                       │
│    GetBooksUseCase.call()                                        │
│    → call IBookRepository.getBooks()                            │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 4. DATA LAYER (Repository Implementation)                        │
│    BookRepositoryImpl.getBooks()                                 │
│    → Check network connection                                    │
│    → Call BookRemoteDataSource.getBooks()                       │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 5. DATA LAYER (Remote Data Source)                              │
│    BookRemoteDataSource.getBooks()                               │
│    → API call: GET /books                                        │
│    → Parse JSON → List<BookModel>                               │
│    → Return to Repository                                        │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 6. DATA LAYER (Repository - Return Path)                        │
│    BookRepositoryImpl receives List<BookModel>                   │
│    → Cache to LocalDataSource                                    │
│    → Convert Model → Entity                                      │
│    → Return Right(List<BookEntity>)                             │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 7. DOMAIN LAYER (Use Case - Return)                             │
│    GetBooksUseCase returns Either<Failure, List<BookEntity>>    │
│    → Pass to BLoC                                                │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 8. PRESENTATION LAYER (BLoC - Return)                           │
│    BookBloc receives result                                      │
│    → result.fold(...)                                            │
│    → emit(BookState.loaded(books))                              │
└────────────────────────┬─────────────────────────────────────────┘
                         ↓
┌────────────────────────▼─────────────────────────────────────────┐
│ 9. UI UPDATE                                                     │
│    BlocBuilder rebuilds                                          │
│    → Display list of books                                       │
└──────────────────────────────────────────────────────────────────┘
```

---

## Best Practices - Quy tắc Vàng

### 1. Dependency Injection

**Sử dụng:** GetIt + Injectable

**Scope:**
- `@singleton`: API Client, Storage (tồn tại suốt đời app, khởi tạo ngay)
- `@lazySingleton`: Repositories, UseCases (khởi tạo khi cần, tồn tại suốt đời)
- `@injectable/@factory`: BLoC (tạo mới mỗi lần inject, hủy khi Widget dispose)

**Ví dụ:**
```dart
@module
abstract class RegisterModule {
  @singleton
  ApiClient get apiClient => ApiClient();
}

@lazySingleton
class BookRepositoryImpl implements IBookRepository {
  final BookRemoteDataSource remoteDataSource;
  // ...
}

@injectable
class BookBloc extends Bloc<BookEvent, BookState> {
  // ...
}
```

### 2. State Immutability (Tính Bất biến)

**Quy tắc:**
- State phải luôn là Immutable
- **KHÔNG** thay đổi trực tiếp thuộc tính: `state.count++` ❌
- **PHẢI** tạo bản sao mới: `state.copyWith(count: state.count + 1)` ✅

**Công cụ:** Sử dụng `freezed` để tự động sinh `copyWith`, `==`, `toString`

### 3. Error Handling (Xử lý Lỗi)

**Functional Error Handling:**
- Sử dụng `Either<Failure, Success>` thay vì try-catch
- Buộc xử lý cả hai trường hợp
- Lỗi là giá trị, không phải Exception

**Ví dụ:**
```dart
final result = await useCase(params);
result.fold(
  (failure) => emit(State.error(failure.message)), // Handle error
  (data) => emit(State.success(data)),             // Handle success
);
```

### 4. Side Effects (Navigation, Dialogs)

**Vấn đề:** BLoC không nên chứa UI code (BuildContext, Navigator).

**Giải pháp:** Sử dụng `BlocListener` cho one-time events.

**Ví dụ:**
```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.whenOrNull(
      success: (_) => Navigator.pushReplacementNamed(context, '/home'),
      error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      ),
    );
  },
  child: YourWidget(),
)
```

### 5. BLoC-to-BLoC Communication

**Vấn đề:** BLoC A cần dữ liệu từ BLoC B.

**Giải pháp SAI:** ❌ Truyền BLoC A vào constructor của BLoC B (tạo coupling)

**Giải pháp ĐÚNG:** ✅ Reactive Repository Pattern
- Repository expose `Stream<Data>`
- Cả hai BLoC đều lắng nghe Stream từ Repository
- Khi một BLoC cập nhật, Repository emit event → BLoC kia tự động nhận

### 6. Multi-BLoC trên một Screen

**Vấn đề:** Màn hình phức tạp cần nhiều nguồn dữ liệu.

**Giải pháp:** Sử dụng `MultiBlocProvider`

**Ví dụ:**
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => getIt<CartBloc>()),
    BlocProvider(create: (_) => getIt<AddressBloc>()),
    BlocProvider(create: (_) => getIt<PaymentBloc>()),
  ],
  child: CheckoutView(),
)
```

### 7. Testing Strategy

**Unit Test:**
- Test UseCases với mock Repository
- Test BLoC với mock UseCase (sử dụng `bloc_test`)
- Test Entities logic

**Widget Test:**
- Test Widget với mock BLoC
- Verify UI renders correctly for each State

**Integration Test:**
- Test toàn bộ flow từ UI → Data Layer

---

## Anti-Patterns - Những điều KHÔNG nên làm

| ❌ Anti-Pattern | ✅ Cách đúng |
|----------------|-------------|
| Parse JSON trong Entity | Parse JSON trong Model (Data Layer) |
| BLoC gọi API trực tiếp | BLoC → UseCase → Repository → DataSource → API |
| Widget gọi Repository | Widget → BLoC → UseCase → Repository |
| State có thuộc tính mutable | State hoàn toàn immutable (final fields) |
| BLoC chứa BuildContext | BLoC emit State, UI dùng BlocListener để navigate |
| Một BLoC xử lý nhiều features | Mỗi feature có BLoC riêng |
| Lồng nhiều BlocProvider | Dùng MultiBlocProvider |
| Ném Exception từ Repository | Trả về `Either<Failure, Data>` |

---

## Tổng kết

Cấu trúc này đảm bảo:

1. **Separation of Concerns**: Mỗi layer có trách nhiệm rõ ràng
2. **Testability**: Mọi component có thể test độc lập
3. **Scalability**: Dễ dàng mở rộng team và features
4. **Maintainability**: Dễ đọc, dễ sửa, dễ refactor
5. **Independence**: Domain Layer hoàn toàn độc lập với Framework

**Dependency Rule:**
```
Presentation → Domain ← Data
(Only inward dependencies)
```

Khi cần thêm feature mới:
1. Tạo folder trong `features/`
2. Tạo 3 layers: `domain/`, `data/`, `presentation/`
3. Implement từ trong ra ngoài: Domain → Data → Presentation
4. Đăng ký dependencies trong `service_locator.dart`

---

**References:**
- Clean Architecture - Robert C. Martin
- BLoC Pattern Documentation
- Flutter Official Architecture Guide
- Báo cáo Kiến trúc Kỹ thuật: Thiết kế Hệ thống Flutter Quy mô Lớn với MVVM, BLoC và Clean Architecture
