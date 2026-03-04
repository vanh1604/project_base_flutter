# Flutter Project Base — Tài liệu Kỹ thuật

---

**Phiên bản:** 1.0.0
**Ngày tạo:** 2026-03-02
**Mục đích:** Hướng dẫn kiến trúc và pattern cho bất kỳ Flutter developer nào muốn hiểu, sử dụng, hoặc mở rộng project base này
**Audience:** Flutter developer, bao gồm cả người mới vào dự án

---

## Mục lục

- [PHẦN 1 — PREAMBLE](#phần-1--preamble)
  - [Tại sao Tài liệu Này Tồn tại](#tại-sao-tài-liệu-này-tồn-tại)
  - [Ai Cần Đọc?](#ai-cần-đọc)
  - [Cách Đọc Tài liệu Này](#cách-đọc-tài-liệu-này)
  - [Điều kiện Tiên quyết](#điều-kiện-tiên-quyết)
- [PHẦN 2 — EXECUTIVE SUMMARY](#phần-2--executive-summary)
  - [Project Base là Gì?](#project-base-là-gì)
  - [Số liệu Quan trọng](#số-liệu-quan-trọng)
  - [Mental Model Nhanh](#mental-model-nhanh)
- [PHẦN 3 — NỘI DUNG CHÍNH](#phần-3--nội-dung-chính)
  - [Danh sách Diagram](#danh-sách-diagram)
  - [A. Tổng quan Kiến trúc](#a-tổng-quan-kiến-trúc)
  - [B. Clean Architecture: 4 Tầng trong Thực tế](#b-clean-architecture-4-tầng-trong-thực-tế)
  - [C. Dependency Injection với Riverpod](#c-dependency-injection-với-riverpod)
  - [D. Networking Layer: Dio & Interceptors (AuthInterceptor, Completer)](#d-networking-layer-dio--interceptors)
  - [E. Token Security: flutter_secure_storage](#e-token-security-flutter_secure_storage)
  - [F. Error Handling: Sealed AppException](#f-error-handling-sealed-appexception)
  - [G. State Management: AsyncNotifier Pattern](#g-state-management-asyncnotifier-pattern)
  - [H. Navigation: GoRouter + RouterNotifier](#h-navigation-gorouter--routernotifier)
  - [I. Authentication Flow End-to-End](#i-authentication-flow-end-to-end)
  - [J. Code Generation Workflow](#j-code-generation-workflow)
  - [K. Shared UI Layer](#k-shared-ui-layer)
- [PHẦN 4 — REFERENCE & GUIDES](#phần-4--reference--guides)
  - [L. Bản đồ Dependency Hoàn chỉnh](#l-bản-đồ-dependency-hoàn-chỉnh)
- [PHẦN 5 — APPENDIX](#phần-5--appendix)
  - [N. Hướng dẫn Mở rộng: Thêm Feature Mới](#n-hướng-dẫn-mở-rộng-thêm-feature-mới)
  - [O. Quick Reference Tables](#o-quick-reference-tables)
  - [P. Quy ước Đặt tên](#p-quy-ước-đặt-tên)
  - [Q. Checklist trước khi Code](#q-checklist-trước-khi-code)

---

## PHẦN 1 — PREAMBLE

---

### Tại sao Tài liệu Này Tồn tại

Khi một Flutter developer mới join team, họ gặp phải bộ khung code với hơn 40 file, 9 Riverpod provider, 20+ pattern phức tạp. Không có tài liệu, họ mất 1–2 tuần mới hiểu tại sao code được tổ chức theo cách này.

Tài liệu này giải quyết vấn đề đó. Nó giải thích **lý do** đằng sau mỗi quyết định kiến trúc — không chỉ mô tả code làm gì, mà giải thích tại sao nó làm như vậy.

---

### Ai Cần Đọc?

| Đối tượng                          | Mục tiêu khi đọc                         | Ưu tiên đọc            |
| ---------------------------------- | ---------------------------------------- | ---------------------- |
| **Developer mới join**             | Hiểu toàn bộ kiến trúc, bắt đầu đóng góp | Đọc theo thứ tự từ đầu |
| **Developer cần debug networking** | Hiểu AuthInterceptor, token refresh      | Đọc D → E → I          |
| **Developer cần thêm feature**     | Biết tạo đúng 4 tầng, đúng provider      | Đọc B → C → N          |
| **Tech lead review architecture**  | Đánh giá quyết định kiến trúc            | Đọc A2 → B6 → L → Q    |

---

### Cách Đọc Tài liệu Này

Tài liệu có 5 phần — đọc theo mục tiêu của bạn:

```
PHẦN 1 (Preamble)       → Bạn đang đọc — định hướng trước khi bắt đầu
PHẦN 2 (Summary)        → Mental model nhanh trong 5 phút
PHẦN 3 (Main Content)   → Kiến thức chi tiết theo từng chủ đề (A → K)
PHẦN 4 (Reference)     → Bản đồ dependency, câu hỏi ôn tập, hướng dẫn mở rộng
PHẦN 5 (Appendix)       → Tra cứu nhanh khi đang code
```

---

### Điều kiện Tiên quyết

Bạn cần biết trước:

- **Dart cơ bản:** class, interface, async/await, Future, Stream
- **Flutter cơ bản:** Widget, StatefulWidget, BuildContext
- **Không cần biết trước:** Clean Architecture, Riverpod, GoRouter, Dio — tài liệu này giải thích từ đầu

---

## PHẦN 2 — EXECUTIVE SUMMARY

### Project Base là Gì?

Project base là **bộ khung khởi động** (scaffold) giải quyết sẵn các bài toán cơ sở mà mọi Flutter app đều cần — authentication, networking, navigation, state management, secure storage, error handling. Team clone repo này làm điểm khởi đầu, rồi thêm business logic cụ thể của từng sản phẩm. Chi tiết phạm vi xem **A1**.

---

### Số liệu Quan trọng

| Thứ                     | Con số                                                     |
| ----------------------- | ---------------------------------------------------------- |
| Packages chính          | 5 (GoRouter, Riverpod, Dio, FlutterSecureStorage, Freezed) |
| Tầng kiến trúc          | 4 (Domain → Data → Application → Presentation)             |
| Providers trong DI tree | 9 (5 keepAlive + 4 auto-dispose)                           |
| Interceptors trong Dio  | 2 (AppLogInterceptor + AuthInterceptor)                    |
| Diagrams trong tài liệu | 23 (ký hiệu Section.Number — A.1, B.1…D.5…H.3…L.1)         |
| Files source code chính | ~40                                                        |

---

### Mental Model Nhanh

Trước khi đọc chi tiết, hình dung app như sau:

```
User nhấn nút
      ↓
  [Presentation Layer]   LoginScreen / HomeScreen
  Widget & Controller    "UI không biết gì ngoài show/hide"
      ↓
  [Application Layer]   AuthService
  Điều phối nghiệp vụ   "Thêm analytics, permission — không sửa tầng khác"
      ↓
  [Domain Layer]        AuthRepository (interface) / User (entity)
  Hợp đồng thuần Dart   "Định nghĩa CÁI GÌ cần làm, không biết LÀM THẾ NÀO"
      ↑ implements
  [Data Layer]          AuthRepositoryImpl / AuthRemoteDatasource
  Thực thi hợp đồng     "Biết Dio, biết JSON, biết SecureStorage"
      ↓
  [Backend API]         HTTP over TLS
```

**3 điểm chốt để nhớ:**

1. **Dependency Rule:** Mũi tên chỉ đi vào trong (Presentation → Domain ← Data), không bao giờ ngược lại
2. **DI bằng Riverpod:** Mọi object được tạo và inject qua provider — không khởi tạo trực tiếp
3. **Completer Lock:** AuthInterceptor dùng Completer để 3 request 401 đồng thời chỉ gọi refresh 1 lần

---

## PHẦN 3 — NỘI DUNG CHÍNH

---

### Danh sách Diagram

Tất cả diagram trong tài liệu được đánh số theo format **Section.N** — nhìn số biết ngay thuộc phần nào.

| Diagram | Tiêu đề                                           | Section                                |
| ------- | ------------------------------------------------- | -------------------------------------- |
| **A.1** | Kiến trúc Tổng thể                                | A.4 — Phép ẩn dụ Tòa nhà               |
| **B.1** | Dependency Rule (4 Tầng)                          | B.1 — Nguyên tắc Cốt lõi               |
| **B.2** | Data Flow qua Data Layer                          | B.3 — Data Layer                       |
| **C.1** | Annotation → build_runner → Output                | C.2.6 — Cơ chế Code Generation         |
| **C.2** | Provider Dependency Tree                          | C.3 — keepAlive vs Non-keepAlive       |
| **C.3** | Startup Initialization Chain                      | C.3 — keepAlive (tiếp)                 |
| **D.1** | Interceptor Pipeline                              | D.2 — Environment System               |
| **D.2** | Happy Path — Request Thành công                   | D.4 — AuthInterceptor                  |
| **D.3** | Xử lý 401 Đơn giản (Single Request)               | D.4 — AuthInterceptor                  |
| **D.4** | 401 Đồng thời — Completer Lock Pattern            | D.4 — AuthInterceptor ⭐               |
| **D.5** | Forced Logout — Khi Refresh Thất bại              | D.4 — AuthInterceptor                  |
| **E.1** | Token Lifecycle                                   | E.2 — TokenStorage Wrapper             |
| **F.1** | AppException Hierarchy                            | F.1 — Tại sao Sealed Class             |
| **F.2** | Error Propagation (DioException → SnackBar)       | F.2 — Bảng Mapping                     |
| **G.1** | AsyncValue State Machine                          | G — State Management                   |
| **H.1** | Route Tree                                        | H.1 — Tại sao GoRouter                 |
| **H.2** | RouterNotifier Bridge (Riverpod → GoRouter)       | H.1 — GoRouter                         |
| **H.3** | ScaffoldWithNestedNavigation — Luồng Tap → Render | H.3 — Nested Navigation                |
| **I.1** | Cold Start Full Flow                              | I — Authentication End-to-End          |
| **I.2** | Login Full Flow                                   | I — Authentication End-to-End          |
| **I.3** | Logout Flow                                       | I — Authentication End-to-End          |
| **K.1** | AsyncValueWidget Flow                             | K.2 — PrimaryButton & AsyncValueWidget |
| **L.1** | Full Dependency Map (tất cả file & provider)      | L — Bản đồ Dependency                  |

> **⭐ D.4** là diagram quan trọng nhất — đọc D4.0 trước để hiểu cơ chế Completer.

---

## A. Tổng quan Kiến trúc

### A1. Mục đích & Phạm vi Project Base

Project base này là **bộ khung khởi động** (scaffold) cho mọi ứng dụng Flutter mới. Thay vì mỗi dự án phải tự giải quyết các bài toán cơ sở như authentication, networking, state management, navigation — project base giải quyết một lần và để các team sao chép & mở rộng.

**Phạm vi bao gồm:**

- Kiến trúc Clean Architecture 4 tầng áp dụng sẵn qua feature auth
- Hệ thống networking với interceptor tự động refresh token
- Token storage an toàn sử dụng hardware-backed encryption
- Navigation declarative với kiểm soát auth-guard
- State management type-safe với code generation
- Error handling đồng nhất xuyên suốt app

**Phạm vi không bao gồm:** Business logic cụ thể của từng sản phẩm, theme design system, localization đầy đủ — những thứ này mỗi team tự thêm.

---

### A2. 5 Quyết định Kiến trúc Quan trọng

| #   | Quyết định                             | Lý do                                                                                                                                                |
| --- | -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | **GoRouter** cho navigation            | Declarative routing, URL-based, hỗ trợ nested navigation và deep links native. Navigator 1.0 không đáp ứng được khi app có bottom nav phức tạp       |
| 2   | **Riverpod** (code gen) cho DI & state | Type-safe, không context, mockable trong test, code gen loại bỏ boilerplate. Provider cũ thiếu compile-time safety                                   |
| 3   | **Clean Architecture** với 4 tầng      | Tách biệt concern: UI không biết API, domain không biết framework. Swap networking library hoặc thay state management không ảnh hưởng business logic |
| 4   | **Dio** với Interceptor pipeline       | Middleware pattern: auth token, logging, retry đều là interceptor độc lập. Dễ thêm/bỏ mà không sửa code gọi API                                      |
| 5   | **Sealed AppException**                | Compiler check exhaustive switch. Không parse string lỗi. Presentation layer xử lý từng loại lỗi đúng cách                                           |

---

### A3. Thuật ngữ & Định nghĩa

| Thuật ngữ                  | Định nghĩa                                                                                                                             |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| **Entity**                 | Object thuần Dart đại diện cho khái niệm domain (User, Product). Không biết JSON, không biết Dio                                       |
| **Model**                  | Phiên bản data của Entity, có thêm `fromJson` / `toJson` để parse API                                                                  |
| **Repository (interface)** | Hợp đồng (contract) định nghĩa những gì domain cần từ data layer                                                                       |
| **Repository (impl)**      | Lớp thực thi hợp đồng, biết datasource và token storage                                                                                |
| **Datasource**             | Lớp chỉ biết HTTP call, không biết business logic                                                                                      |
| **Service**                | Application layer: điều phối giữa Presentation và Domain                                                                               |
| **Provider**               | Đơn vị DI trong Riverpod — là factory tạo ra và quản lý object                                                                         |
| **AsyncNotifier**          | Provider kiêm state machine, state là `AsyncValue<T>` (loading/data/error)                                                             |
| **AsyncValue**             | Wrapper 3 trạng thái: `AsyncLoading`, `AsyncData`, `AsyncError`                                                                        |
| **Interceptor**            | Middleware của Dio — xử lý request/response/error trước khi đến code gọi                                                               |
| **Completer**              | Dart primitive đại diện cho "lời hứa kết quả", giải quyết sau. Dùng để share kết quả async giữa nhiều caller                           |
| **keepAlive**              | Flag trên Riverpod provider — nếu `true`, provider sống mãi dù không ai watch. Nếu `false`, provider bị dispose khi không còn listener |

---

### A4. Phép Ẩn dụ Toà nhà

Hãy hình dung app như một toà nhà:

- **Domain Layer = Bản vẽ kiến trúc:** Định nghĩa hình dạng (entity), quy tắc (repository interface). Không cần biết nguyên liệu xây bằng gì.
- **Data Layer = Xưởng sản xuất:** Nhận nguyên liệu thô (JSON từ API), gia công thành thành phẩm (entity), lưu kho (token storage).
- **Application Layer = Ban quản lý tòa nhà:** Điều phối yêu cầu, thêm quy trình (analytics, permission check) mà không cần thay bản vẽ hay xưởng.
- **Presentation Layer = Mặt tiền khách tham quan:** Hiển thị thông tin, nhận tương tác. Không biết gì về bên trong.

Khách đến (user) chỉ thấy mặt tiền (UI). Mặt tiền giao việc cho ban quản lý (service). Ban quản lý điều phối xưởng (data layer) theo quy tắc của bản vẽ (domain).

---

### Diagram A.1: Kiến trúc Tổng thể

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Flutter App                                 │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  PRESENTATION LAYER  (features/*/presentation/)              │   │
│  │  LoginScreen · HomeScreen · SettingScreen · LoginController  │   │
│  └───────────────────────────┬──────────────────────────────────┘   │
│                              │ ref.read(authServiceProvider)        │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  APPLICATION LAYER   (features/*/application/)               │   │
│  │  AuthService                                                 │   │
│  └───────────────────────────┬──────────────────────────────────┘   │
│                              │ _repository.login()                  │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  DOMAIN LAYER        (features/*/domain/)                    │   │
│  │  User (entity) · AuthRepository (interface)                  │   │
│  └──────────────────────────────────────────────────────────────┘   │
│        ↑ implements                                                  │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  DATA LAYER          (features/*/data/)                      │   │
│  │  UserModel · LoginResponseModel · AuthRemoteDatasource       │   │
│  │  AuthRepositoryImpl · TokenStorage                           │   │
│  └───────────────────────────┬──────────────────────────────────┘   │
│                              │ Dio (HTTP)                           │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  CORE (Shared)       (core/)                                 │   │
│  │  AuthInterceptor · AppLogInterceptor · AppException          │   │
│  │  AppEnvironment · ApiEndpoints · CoreProviders               │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────┬───────────────────────────────┘
                                      │ HTTPS / TLS
                               ┌──────┴──────┐
                               │  Backend    │
                               │  REST API   │
                               └─────────────┘
```

**Giải thích:** Mũi tên đi từ trên xuống (Presentation → Application → Domain ← Data). Đây là Dependency Rule: tầng ngoài phụ thuộc vào tầng trong, không bao giờ ngược lại. Core là tầng chia sẻ ngang — bất kỳ tầng nào cũng có thể dùng. Duy nhất Data Layer mới giao tiếp với Backend qua Dio.

---

### A5. Bảng Tất cả Packages

| Package                           | Vai trò                                                     | Layer sử dụng         |
| --------------------------------- | ----------------------------------------------------------- | --------------------- |
| `go_router: ^17.1.0`              | Declarative navigation, URL-based routing, redirect guard   | Presentation, Routing |
| `flutter_riverpod: ^3.0.3`        | State management runtime, widget ref injection              | Tất cả                |
| `riverpod_annotation: ^3.0.3`     | Annotation `@riverpod`, `@Riverpod(keepAlive)` cho code gen | Tất cả                |
| `riverpod_generator: ^3.0.3`      | Build tool tạo `.g.dart` cho provider                       | Dev dependency        |
| `flutter_secure_storage: ^10.0.0` | Keychain (iOS) / Keystore (Android) hardware-backed storage | Data, Utils           |
| `dio: ^5.8.0`                     | HTTP client với Interceptor pipeline                        | Data, Core            |
| `freezed_annotation: ^3.0.0`      | Annotation `@freezed` cho immutable data class              | Domain, Data          |
| `freezed: ^3.0.0`                 | Build tool tạo `.freezed.dart` (copyWith, ==, hashCode)     | Dev dependency        |
| `json_annotation: ^4.8.1`         | Annotation `@JsonKey(name:)` cho JSON mapping               | Data                  |
| `json_serializable: ^6.7.1`       | Build tool tạo `.g.dart` cho `fromJson` / `toJson`          | Dev dependency        |
| `build_runner: ^2.4.8`            | Runner thực thi tất cả build tools trên                     | Dev dependency        |

---

### A6. Cấu trúc Thư mục (Annotated)

> **Đây là nơi duy nhất** trong tài liệu này mô tả cấu trúc thư mục. Các phần khác chỉ refer đến file cụ thể.

```
lib/
└── src/
    ├── app.dart                         # Root widget: MaterialApp.router + goRouterProvider
    │
    ├── core/                            # Shared infrastructure — không thuộc feature nào
    │   ├── api_endpoints.dart           # Registry path constants (không lưu full URL)
    │   ├── app_environment.dart         # dev / staging / prod URL switcher
    │   ├── exceptions/
    │   │   └── app_exception.dart       # Sealed class: 6 typed exceptions
    │   ├── interceptors/
    │   │   ├── auth_interceptor.dart    # Token attach + 401 refresh + Completer lock
    │   │   └── log_interceptor.dart     # Debug-only request/response logger
    │   └── providers/
    │       ├── core_providers.dart      # DI root: tokenStorageProvider + dioProvider
    │       └── core_providers.g.dart    # Generated — KHÔNG sửa tay
    │
    ├── common/                          # Shared UI widgets — dùng ở ≥2 features
    │   ├── async_value_widget.dart      # Tái sử dụng loading/error/data rendering
    │   ├── primary_button.dart          # ElevatedButton chuẩn với loading state
    │   ├── error_message_widget.dart    # Widget hiển thị error message
    │   ├── alert_dialogs.dart           # Dialog utilities
    │   ├── action_text_button.dart      # TextButton với action
    │   ├── custom_text_button.dart      # Custom TextButton
    │   ├── custom_image.dart            # Image widget với placeholder
    │   ├── empty_placeholder_widget.dart# Empty state placeholder
    │   ├── decorated_box_with_shadow.dart # Container với shadow
    │   └── responsive_center.dart       # Center widget cho responsive layout
    │
    ├── constants/
    │   ├── app_sizes.dart               # Design tokens: Sizes.p4 → Sizes.p64 + gap helpers
    │   └── breakpoints.dart             # Responsive breakpoints: tablet=600, desktop=900
    │
    ├── localization/
    │   └── string_hardcoded.dart        # Marker cho string cần localize sau
    │
    ├── features/                        # Features-first: mỗi tính năng 1 folder tự trị
    │   ├── auth/
    │   │   ├── domain/
    │   │   │   ├── entities/
    │   │   │   │   ├── user.dart        # User entity: id, name, email (thuần Dart)
    │   │   │   │   └── user.freezed.dart # Generated — KHÔNG sửa tay
    │   │   │   └── repositories/
    │   │   │       └── auth_repository.dart # Interface: login / logout / getCurrentUser
    │   │   ├── data/
    │   │   │   ├── models/
    │   │   │   │   ├── user_model.dart          # UserModel + toEntity() + fromJson()
    │   │   │   │   ├── login_response_model.dart# LoginResponseModel (access/refresh token)
    │   │   │   │   └── *.freezed.dart / *.g.dart # Generated — KHÔNG sửa tay
    │   │   │   ├── datasources/
    │   │   │   │   ├── auth_remote_datasource.dart # HTTP calls only: login/logout/profile
    │   │   │   │   └── auth_remote_datasource.g.dart # Generated
    │   │   │   └── repositories/
    │   │   │       ├── auth_repository_impl.dart  # Impl interface + error mapping
    │   │   │       └── auth_repository_impl.g.dart # Generated
    │   │   ├── application/
    │   │   │   ├── auth_service.dart    # AuthService + authServiceProvider + authStateProvider
    │   │   │   └── auth_service.g.dart  # Generated
    │   │   └── presentation/
    │   │       ├── controllers/
    │   │       │   ├── login_controller.dart  # AsyncNotifier<User?> — session restore + login
    │   │       │   └── login_controller.g.dart # Generated
    │   │       └── screens/
    │   │           └── login_screen.dart    # ConsumerStatefulWidget: form + ref.listen
    │   ├── home/
    │   │   └── presentation/screens/
    │   │       ├── home_screen.dart     # Home tab màn hình chính
    │   │       └── detail_screen.dart   # Detail screen trong home stack
    │   └── settings/
    │       └── presentation/screens/
    │           ├── setting_screen.dart  # Settings tab màn hình chính
    │           └── setting_detail_screen.dart # Detail screen trong settings stack
    │
    ├── routing/
    │   ├── app_router.dart              # GoRouter config: routes + redirect logic
    │   ├── app_router.g.dart            # Generated
    │   ├── router_notifier.dart         # RouterNotifier: bridge Riverpod → GoRouter
    │   └── router_notifier.g.dart       # Generated
    │
    └── utils/
        ├── token_storage.dart           # Wrapper over FlutterSecureStorage
        └── scaffold_with_nested_navigation.dart # Bottom nav + StatefulNavigationShell
```

---

## B. Clean Architecture: 4 Tầng trong Thực tế

### B1. Nguyên tắc Cốt lõi: Dependency Rule

**Quy tắc duy nhất:** Dependency (phụ thuộc) chỉ đi từ ngoài vào trong.

- Presentation biết Application. Application biết Domain. Data biết Domain.
- Domain **không biết gì cả** — không import Dio, không import Riverpod, không import bất kỳ framework nào.
- Kết quả: có thể thay thế Data layer (đổi từ REST sang GraphQL), thay thế Presentation layer (đổi từ Flutter sang web) mà Domain layer vẫn nguyên vẹn.

---

### Diagram B.1: Dependency Rule (4 Tầng với Feature Auth)

```
        ┌─────────────────────────────────────────┐
        │         PRESENTATION LAYER              │
        │  LoginScreen · LoginController          │
        │  (biết Application, không biết Domain)  │
        └──────────────────┬──────────────────────┘
                           │ depends on
        ┌──────────────────▼──────────────────────┐
        │         APPLICATION LAYER               │
        │  AuthService                            │
        │  (biết Domain interface, không biết Dio)│
        └──────────────────┬──────────────────────┘
                           │ depends on
        ┌──────────────────▼──────────────────────┐
        │           DOMAIN LAYER                  │ ← Trung tâm
        │  User (entity) · AuthRepository (iface) │   Không biết
        │  Thuần Dart — không import gì ngoài     │   bên ngoài
        └──────────────────▲──────────────────────┘
                           │ implements
        ┌──────────────────┴──────────────────────┐
        │            DATA LAYER                   │
        │  AuthRepositoryImpl · UserModel         │
        │  AuthRemoteDatasource · TokenStorage    │
        │  (biết Dio, biết SecureStorage)         │
        └─────────────────────────────────────────┘

Mũi tên = "depends on" / "biết về"
Domain ở trung tâm không có mũi tên đi ra ngoài
```

**Giải thích:** Data layer "implements" (implements interface của Domain) — nhưng điều đó không có nghĩa là Domain biết về Data. Interface nằm trong Domain, Implementation nằm trong Data. Đây là Dependency Inversion Principle: Domain định nghĩa contract, Data thực thi.

---

### B2. Domain Layer: Thuần Dart

Domain layer chứa hai loại object:

**Entity (ví dụ: User):** Đại diện cho khái niệm business. Chỉ chứa các trường và business rules đơn giản. Không có `fromJson`, không có annotation của bất kỳ thư viện nào. Sử dụng `@freezed` từ `freezed_annotation` cho immutability — đây là annotation Dart thuần, không kéo theo framework.

**Repository Interface (ví dụ: AuthRepository):** Hợp đồng. Định nghĩa những phương thức mà domain cần. Khai báo bằng `abstract interface class`. Return type là Entity, không bao giờ là Model. Throw Exception, không phải HTTP error.

---

### B3. Data Layer: JSON → Entity

Data layer là cầu nối giữa world bên ngoài (API JSON) và domain.

**Model (ví dụ: UserModel):** Là phiên bản "biết JSON" của Entity. Có `fromJson` để parse. Có `toEntity()` để chuyển thành Entity. Đây là điểm duy nhất trong codebase nơi JSON được xử lý.

**LoginResponseModel:** Model đặc biệt cho response của API login — chứa cả `accessToken`, `refreshToken`, và nested `UserModel`. Sử dụng `@JsonKey(name: 'access_token')` để map snake_case API sang camelCase Dart.

**RemoteDatasource (ví dụ: AuthRemoteDatasource):** Lớp chỉ biết gọi HTTP. Nhận Dio qua constructor. Return raw Model. Không xử lý business logic, không biết token storage.

**RepositoryImpl (ví dụ: AuthRepositoryImpl):** Thực thi hợp đồng của Domain. Biết cả datasource lẫn token storage. Gọi `model.toEntity()` trước khi trả về. Map `DioException` thành `AppException` — đây là ranh giới quan trọng: bên trên impl không bao giờ thấy `DioException`.

---

### Diagram B.2: Data Flow qua Data Layer

```
 API Server
     │
     │  HTTP Response (JSON)
     │  {
     │    "access_token": "abc123",
     │    "refresh_token": "xyz789",
     │    "user": { "id": "1", "name": "An", "email": "an@email.com" }
     │  }
     ▼
 AuthRemoteDatasource.login()
     │  dio.post('/api/signin') → raw Map<String, dynamic>
     │
     ▼
 LoginResponseModel.fromJson(json)
     │  Freezed + json_serializable parse:
     │  @JsonKey(name: 'access_token') → accessToken
     │  @JsonKey(name: 'refresh_token') → refreshToken
     │  UserModel.fromJson(json['user']) → UserModel
     │
     ▼
 AuthRepositoryImpl.login()
     │  Nhận LoginResponseModel từ datasource
     │  → tokenStorage.saveTokens(accessToken, refreshToken)
     │  → response.user.toEntity()
     │
     ▼
 User (Domain Entity)
     User(id: '1', name: 'An', email: 'an@email.com')
     │
     │  Từ đây trở lên, không còn JSON, không còn DioException
     │  Chỉ còn pure Dart objects và AppException
     ▼
 AuthService → LoginController → LoginScreen
```

**Giải thích:** Có hai lần biến đổi quan trọng. Lần 1: JSON → Model (parsing). Lần 2: Model → Entity (toEntity()). Sau lần 2, mọi lớp bên trên chỉ làm việc với domain entity. Nếu backend đổi cấu trúc JSON, chỉ sửa Model — không đụng đến Entity hay bất kỳ tầng nào khác.

---

### B4. Application Layer: Lớp Trung gian

`AuthService` là Application layer. Có thể tự hỏi: tại sao cần thêm lớp này giữa Presentation và Domain?

**Lý do:** Application layer là điểm duy nhất để thêm cross-cutting concerns mà không ảnh hưởng đến Controller hay Repository:

- **Analytics:** Ghi nhận sự kiện "user đã login" mà không sửa Controller
- **Permission check:** Kiểm tra quyền trước khi gọi API mà không sửa Repository
- **Caching:** Lưu kết quả vào cache mà không thay đổi interface của Repository
- **Feature flags:** Bật/tắt chức năng mà không sửa UI

Nếu không có Application layer, analytics sẽ nằm trong Controller (Presentation biết analytics — sai) hoặc Repository (Data layer biết analytics — sai hơn).

---

### B5. Presentation Layer: Controller + Screen

**LoginController (AsyncNotifier):** Quản lý state của authentication. `build()` method tự động restore session khi app khởi động bằng cách watch `authStateProvider`. `login()` method gọi qua AuthService, wrap trong `AsyncValue.guard()` để chuyển Exception thành AsyncError.

**LoginScreen (ConsumerStatefulWidget):** Widget lắng nghe state qua `ref.listen` để navigate hoặc show SnackBar. Read state qua `ref.watch` để disable button khi loading. Không chứa business logic — chỉ render state và gọi controller.

---

### B5.1 ConsumerWidget vs ConsumerStatefulWidget

| Loại                     | Khi nào dùng                                                                      | Ví dụ trong project           |
| ------------------------ | --------------------------------------------------------------------------------- | ----------------------------- |
| `ConsumerWidget`         | Stateless — chỉ cần đọc Riverpod provider, không có local state                   | `HomeScreen`, `SettingScreen` |
| `ConsumerStatefulWidget` | Có local state (TextEditingController, FocusNode, animation) kết hợp với Riverpod | `LoginScreen`                 |

**LoginScreen phải dùng `ConsumerStatefulWidget` vì:**

- Cần `TextEditingController` cho email field và password field — local state phải được `dispose()` khi widget bị remove khỏi tree
- Cần `FocusNode` cho keyboard navigation — cũng là local state cần `dispose()`
- Đồng thời cần `ref.listen` để navigate và show SnackBar — cần Riverpod

`ConsumerWidget` không có `State` và không có `initState()`/`dispose()`. Nếu cố tạo `TextEditingController` bên trong `build()` của `ConsumerWidget`, controller bị recreate mỗi lần rebuild (mất nội dung đang nhập, mất focus).

**Quy tắc thực tế:** Bắt đầu với `ConsumerWidget`. Chỉ đổi sang `ConsumerStatefulWidget` khi cần `initState()`/`dispose()` cho local resource (controller, animation, stream subscription). Tuyệt đối không dùng StatefulWidget thuần nếu cần đọc Riverpod — dùng `ConsumerStatefulWidget`.

---

### B6. Bảng Dependency Rule

| Tầng             | Được import                                                                     | Không được import                             |
| ---------------- | ------------------------------------------------------------------------------- | --------------------------------------------- |
| **Domain**       | Dart core, `freezed_annotation`                                                 | Dio, Riverpod, Flutter widgets, Data layer    |
| **Data**         | Domain layer, Dio, `freezed_annotation`, `json_annotation`, Riverpod annotation | Application layer, Presentation layer         |
| **Application**  | Domain layer, Riverpod annotation                                               | Dio, Data layer trực tiếp (chỉ qua interface) |
| **Presentation** | Application layer, Riverpod, Flutter widgets                                    | Domain repositories, Data layer               |

---

### B7. Tác động của Clean Architecture

| Kịch bản                          | Có Clean Architecture                   | Không có Clean Architecture           |
| --------------------------------- | --------------------------------------- | ------------------------------------- |
| Thay REST API bằng GraphQL        | Chỉ sửa Data layer (datasource + model) | Sửa khắp nơi trong UI                 |
| Viết unit test cho business logic | Test Domain/Application với mock        | Phải mock cả UI framework             |
| Thêm cache layer                  | Thêm vào Application Service            | Cần refactor controller và API call   |
| Đổi Riverpod sang khác            | Chỉ sửa Presentation + Application      | Cần refactor toàn bộ                  |
| Thêm analytics event              | Thêm vào Application Service            | Dán thẳng vào button handler trong UI |

---

## C. Dependency Injection với Riverpod

### C1. Tại sao Riverpod?

**Bước 1 — Ba vấn đề cần giải quyết**

Trước khi xem bảng so sánh, hãy hiểu rõ ba vấn đề thực tế mà dự án này phải đối mặt. Nếu không có vấn đề, không cần giải pháp.

---

*Vấn đề 1 — AuthInterceptor không có BuildContext*

`AuthInterceptor` là một class Dart thuần — không phải Widget, không có `BuildContext`. Nhưng nó cần đọc `TokenStorage` để đính kèm access token vào mỗi request, và cần gọi `logout()` khi token hết hạn.

```
HTTP Request
    │
    ▼
AuthInterceptor (class Dart thuần)
    │
    ├── Cần: TokenStorage để đọc access_token
    └── Cần: LoginController để gọi logout()

Nhưng AuthInterceptor không phải Widget
→ Không có BuildContext
→ Provider.of<TokenStorage>(context)  ← KHÔNG THỂ DÙNG
→ GetIt.instance<TokenStorage>()      ← Được, nhưng xem vấn đề 3
```

Khi access token hết hạn và cần logout, `AuthInterceptor` phải thông báo cho app biết. Chuỗi thông báo đi qua 4 component, không có component nào là Widget:

```
AuthInterceptor
    │ logout()
    ▼
LoginController  (state: AsyncData(null))
    │ notifyListeners()
    ▼
RouterNotifier   (ChangeNotifier)
    │ redirect
    ▼
GoRouter         → navigate to /login
```

`setState()` chỉ hoạt động bên trong một Widget. Cả 4 component trên đều là class Dart thuần — `setState()` không đủ để truyền tín hiệu xuyên suốt chuỗi này.

---

*Vấn đề 2 — State thay đổi cần lan ra nhiều Widget cùng lúc*

Khi user đăng nhập thành công, nhiều Widget trên màn hình cần cập nhật đồng thời: AppBar hiển thị tên user, ProfileScreen hiển thị ảnh avatar, BottomNavBar unlock các tab bị ẩn.

```
loginController.state = AsyncData(user)
      │
      ├── AppBar          ← cần rebuild
      ├── ProfileScreen   ← cần rebuild
      └── BottomNavBar    ← cần rebuild
```

`setState()` chỉ rebuild Widget gọi nó và con cháu của nó. Nếu AppBar, ProfileScreen, BottomNavBar không cùng một Widget subtree, `setState()` không thể notify tất cả cùng lúc. Phải có cơ chế observable tách biệt khỏi widget tree.

---

*Vấn đề 3 — Test khó vì dependency bị hardcode*

Khi viết unit test cho `LoginController`, bạn không muốn gọi API thật. Bạn muốn swap `AuthRepository` bằng một `FakeAuthRepository` trả về data giả.

```
Unit test thực tế:
   LoginController.login('email', 'pass')
       │
       └── gọi AuthRepository.login()  ← muốn dùng FakeAuthRepository ở đây

Với GetIt (service locator):
   GetIt.instance.registerSingleton<AuthRepository>(FakeAuthRepository())
   // Phải unregister sau test, nhớ reset, dễ ảnh hưởng test khác

Với Riverpod:
   ProviderScope(
     overrides: [authRepositoryProvider.overrideWith(() => FakeAuthRepository())],
     child: ...
   )
   // Scope riêng biệt, test này không ảnh hưởng test khác
```

Riverpod dùng `ProviderContainer` — một container độc lập với widget tree. Mỗi test có thể tạo container riêng với override riêng, không bao giờ xung đột.

---

**Bước 2 — So sánh các lựa chọn**

| Tiêu chí            | GetIt (service locator) | Provider    | Riverpod (code gen)      |
| ------------------- | ----------------------- | ----------- | ------------------------ |
| Compile-time safety | Không (runtime crash)   | Partial     | Có — type-safe hoàn toàn |
| Cần BuildContext    | Không                   | Có          | Không                    |
| Mockable trong test | Cần setup thêm          | Khó         | Override provider        |
| Scoping (lifetime)  | Manual                  | Widget tree | keepAlive flag           |
| Code boilerplate    | Thấp                    | Trung bình  | Thấp (code gen)          |
| Watch reactive      | Không                   | Có          | Có + select()            |

---

**Bước 3 — Riverpod giải quyết cả ba như thế nào**

*Vấn đề 1 (không có context):* Riverpod dùng `ProviderContainer` — một object Dart thuần, không phụ thuộc widget tree. `AuthInterceptor` nhận `Ref` (tham chiếu đến container) qua constructor. Từ `Ref`, nó gọi `ref.read(tokenStorageProvider)` và `ref.read(loginControllerProvider.notifier)` — không cần một `BuildContext` nào cả.

```
ProviderContainer (Dart object, không phải Widget)
    │
    ├── tokenStorageProvider  → TokenStorage instance
    ├── loginControllerProvider → LoginController instance
    └── dioProvider → Dio instance (có AuthInterceptor bên trong)

AuthInterceptor nhận Ref → đọc provider → không cần context
```

*Vấn đề 2 (state lan ra nhiều Widget):* Mọi Widget gọi `ref.watch(loginControllerProvider)` đều tự động subscribe vào provider đó. Khi `loginController.state` thay đổi, Riverpod notify tất cả subscriber — dù chúng ở bất kỳ đâu trong widget tree.

*Vấn đề 3 (test):* `ProviderScope(overrides: [...])` tạo container mới với dependency được swap. Swap 1 dòng, test toàn bộ `LoginController` mà không gọi API thật, không ảnh hưởng test khác.

---

### C2. Cơ chế Code Generation

#### C2.0 build_runner là Gì?

`build_runner` là **Dart CLI tool chạy trước compiler** — không phải bộ phận của Dart compiler. Nhiệm vụ duy nhất: quét source file, tìm annotation đặc biệt, gọi đúng "builder" tương ứng, ghi ra file Dart mới (`.g.dart`, `.freezed.dart`). Dart compiler chỉ chạy sau đó, compile tất cả file (gốc + generated) cùng nhau.

**Cơ chế tự động phát hiện builder:**

Mỗi package sinh code (`freezed`, `json_serializable`, `riverpod_generator`) đều đi kèm một file `build.yaml` bên trong package — file này đăng ký builder với build_runner: "annotation nào tôi xử lý, file nào tôi tạo ra". Khi bạn thêm package vào `pubspec.yaml`, build_runner tự tìm và đọc `build.yaml` đó. Bạn không cần cấu hình thủ công.

**Tại sao pubspec.yaml tách thành 2 nhóm package?**

| Nhóm               | Package                                                              | Lý do                                                                              |
| ------------------ | -------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `dependencies`     | `freezed_annotation`, `riverpod_annotation`, `json_annotation`       | Annotation được viết **trong source file** → compile vào app → phải có lúc runtime |
| `dev_dependencies` | `freezed`, `riverpod_generator`, `json_serializable`, `build_runner` | Chỉ cần lúc build để sinh code → **không** compile vào app → không tăng app size   |

Đây là lý do dự án luôn có 2 package cho mỗi tính năng: một để annotate, một để generate.

---

#### C2.1 Vấn đề mà Code Gen giải quyết

**Bước 1 — Vấn đề khi viết provider thủ công**

Riverpod có nhiều loại provider: `Provider`, `FutureProvider`, `StreamProvider`, `NotifierProvider`, `AsyncNotifierProvider`... Khi không dùng code gen, developer phải tự quyết định đúng loại, tự điền đúng generic, và mọi sai sót chỉ bị phát hiện lúc app chạy — không phải lúc compile.

*Kịch bản thực tế:* Bạn cần khai báo `tokenStorageProvider` và `loginControllerProvider` thủ công:

```
Không có code gen — viết tay:

final tokenStorageProvider = Provider<TokenStorage>(         ← phải tự chọn đúng loại
  (ref) => TokenStorage(ref.read(secureStorageProvider)),
);

final loginControllerProvider =
  AsyncNotifierProvider<LoginController, User?>(             ← sai 1 generic → crash lúc runtime
    () => LoginController(),
  );
```

Vấn đề với cách viết tay:

```
Lỗi 1 — Chọn sai loại provider:
  Dùng Provider thay vì AsyncNotifierProvider cho LoginController
  → App compile được → crash lúc chạy: "type mismatch"
  → Không có lỗi ở bước compile

Lỗi 2 — Sai generic:
  AsyncNotifierProvider<LoginController, User>  ← thiếu dấu ?
  → LoginController trả về null khi chưa login
  → Runtime null check exception

Lỗi 3 — Quên autoDispose:
  Provider không có .autoDispose → TokenStorage tồn tại mãi
  → Memory leak nếu dùng trong feature tạm thời
  → Không có cảnh báo nào từ compiler
```

*Cùng kết quả với code gen:*

```
Có code gen — chỉ viết logic:

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) =>       ← tool tự chọn loại Provider
  TokenStorage(ref.read(secureStorageProvider));

@riverpod
class LoginController extends _$LoginController {  ← tool tự tạo AsyncNotifierProvider<LoginController, User?>
  @override
  Future<User?> build() async { ... }
}
```

Tool đọc annotation, đọc kiểu trả về, tự quyết định loại provider đúng và sinh boilerplate. Sai annotation → lỗi compile ngay, không chờ đến lúc chạy.

---

**Bước 2 — Ba vấn đề thủ công và tool giải quyết**

Ba loại boilerplate trong dự án này đều có nguy cơ gây lỗi âm thầm — nghĩa là code compile được nhưng hành vi sai lúc runtime:

| Vấn đề khi viết thủ công | Hậu quả | Tool giải quyết |
| ------------------------- | ------- | --------------- |
| Khai báo provider sai loại hoặc sai generic | Runtime crash, type mismatch | `riverpod_generator` |
| `fromJson` viết tay quên field hoặc sai kiểu | Field null lúc runtime, app crash khi parse API response | `json_serializable` |
| `copyWith` / `==` / `hashCode` viết tay, quên update khi thêm field | Widget không rebuild khi state đổi, bug khó tìm | `freezed` |

Cả ba tool đều hoạt động theo cùng một nguyên tắc: developer chỉ viết phần quan trọng (logic, schema, field), tool sinh ra phần dễ sai (boilerplate, type wiring). Lỗi được bắt ở bước `dart pub run build_runner build`, không phải lúc user dùng app.

---

#### C2.2 Cơ chế `part` / `part of`

File nguồn và file generated được kết nối bằng cặp directive Dart:

- File nguồn khai báo: `part 'core_providers.g.dart';`
- File generated khai báo: `part of 'core_providers.dart';`

Dart coi hai file này là **một library duy nhất**. Nghĩa là:

- File `.g.dart` có thể truy cập mọi thứ trong file nguồn (kể cả private `_` symbols)
- File nguồn có thể dùng class/function được định nghĩa trong `.g.dart`
- Khi compile, Dart merge chúng lại thành một unit

Đây là lý do `LoginController extends _$LoginController` hoạt động được — `_$LoginController` được định nghĩa trong `.g.dart` nhưng `LoginController` ở file nguồn vẫn extend được.

---

#### C2.3 riverpod_generator tạo ra gì trong `.g.dart`

**Bước 1 — Vấn đề nếu không có riverpod_generator**

Riverpod có nhiều loại provider khác nhau: `Provider`, `FutureProvider`, `AsyncNotifierProvider`, `NotifierProvider`... Mỗi loại dành cho một use-case khác nhau. Nếu viết tay, bạn phải chọn đúng loại — và Dart **không bắt lỗi ở compile time** nếu bạn chọn sai:

```
// Viết tay — sai loại provider → runtime crash, không phải compile error
final loginControllerProvider = Provider<LoginController>(  // SAI
  (ref) => LoginController(),
);

// Đúng phải là:
final loginControllerProvider = AsyncNotifierProvider<LoginController, User?>(
  () => LoginController(),
);
// Nếu quên generic User? → sai kiểu → crash khi widget dùng ref.watch()
```

Với riverpod_generator, bạn chỉ viết `@riverpod` lên đúng class hoặc hàm — generator **đọc kiểu trả về** và tự chọn loại provider phù hợp. Không thể sai loại vì generator làm thay.

---

**Bước 2 — riverpod_generator đọc annotation và sinh ra 3 thứ**

`build_runner` đọc annotation `@riverpod` / `@Riverpod(keepAlive:)` và sinh ra **3 thứ** cho mỗi provider:

**Thứ 1: Một class Provider** — Ví dụ annotation trên hàm `tokenStorage(Ref ref)` sinh ra class `TokenStorageProvider`. Class này extend `$FunctionalProvider<TokenStorage, ...>`, có method `create(Ref ref)` gọi lại hàm gốc, và embed `isAutoDispose: false` (vì `keepAlive: true`). Class này là thứ mà Riverpod runtime dùng để quản lý lifecycle.

**Thứ 2: Một constant instance** — `const tokenStorageProvider = TokenStorageProvider._()`. Đây là object bất biến, được dùng khi gọi `ref.watch(tokenStorageProvider)`. Vì là `const`, cùng một "nhãn tên" được dùng khắp nơi trong app mà không tốn thêm bộ nhớ — giống như một singleton label: dù bạn viết `tokenStorageProvider` ở 50 nơi, chúng đều trỏ về cùng một ô nhớ duy nhất được tạo lúc compile.

**Thứ 3: Một hash string** — Ví dụ `String _$tokenStorageHash() => r'09e5f41421...'`. Hash này là "dấu vân tay" của hàm nguồn — sinh ra từ nội dung code, không phải tên hàm. Khi bạn hot reload sau khi sửa logic bên trong `tokenStorage(...)`, hash thay đổi → Riverpod phát hiện provider đã bị sửa → tự động invalidate và recreate provider đó. Nếu không có hash, Riverpod không biết provider nào cần reset sau hot reload.

---

**Bước 3 — Trường hợp đặc biệt: AsyncNotifier**

Annotation trên class `LoginController extends _$LoginController` sinh ra thêm **abstract class `_$LoginController`** trong `.g.dart`. Đây là lớp "ống nước" (plumbing) mà Riverpod cần để vận hành `LoginController`:

```
File .g.dart sinh ra:
    abstract class _$LoginController extends AsyncNotifier<User?> {
        // Định nghĩa runBuild() — Riverpod gọi cái này để khởi động
        // Xử lý async loading state (AsyncLoading → AsyncData/AsyncError)
        // Kết nối build() của developer vào scheduler nội bộ của Riverpod
    }

File nguồn của bạn:
    class LoginController extends _$LoginController {
        @override
        Future<User?> build() async {
            // Bạn chỉ viết logic ở đây
            // Còn "gọi khi nào", "xử lý lỗi thế nào" do _$LoginController lo
        }
    }
```

Tại sao cần lớp trung gian này? Vì Riverpod cần biết khi nào gọi `build()`, cần wrap kết quả vào `AsyncLoading` / `AsyncData` / `AsyncError`, và cần expose `ref` cho developer dùng — tất cả những "việc nhà" đó được đặt trong `_$LoginController`. Developer chỉ viết logic nghiệp vụ trong `build()`, generator lo phần tích hợp với hệ thống nội bộ của Riverpod.

---

#### C2.4 json_serializable tạo ra gì trong `.g.dart`

**Bước 1 — Vấn đề khi viết fromJson tay**

Backend API trả về JSON với snake_case field names. Dart convention dùng camelCase. Nếu viết tay, bạn phải tự ánh xạ và nhớ đúng key name cho từng field:

```
// JSON từ API:
{ "access_token": "abc123", "refresh_token": "xyz789" }

// Viết tay fromJson:
factory LoginResponse.fromJson(Map<String, dynamic> json) {
  return LoginResponse(
    accessToken: json['access_token'],   // phải nhớ snake_case
    refreshToken: json['refresh_token'], // nếu viết sai key → null
  );
}
// Thêm field mới → phải sửa cả fromJson lẫn toJson → dễ quên
```

Mỗi lần backend thêm field mới, bạn phải sửa cả hai hàm `fromJson` và `toJson` — và nếu quên một chỗ, bug sẽ âm thầm tồn tại vì giá trị chỉ bị null, không phải compile error.

---

**Bước 2 — json_serializable sinh ra 2 hàm**

Annotation `@freezed` kết hợp với `json_serializable` trên `UserModel` sinh ra hai hàm trong `user_model.g.dart`:

- `_$UserModelFromJson(Map<String, dynamic> json)` — đọc từng key trong JSON map và gán vào constructor. Đây là hàm được gọi khi viết `UserModel.fromJson(response.data)`. Generator tự xử lý snake_case khi có `@JsonKey` annotation trên field.
- `_$UserModelToJson(_UserModel instance)` — chiều ngược lại, chuyển object thành Map để gửi lên server. Mỗi khi thêm field mới vào class, generator tự cập nhật cả hai hàm — bạn chỉ cần chạy lại `build_runner`.

---

**Bước 3 — @JsonKey giải quyết snake_case vs camelCase**

Khi generator gặp `@JsonKey(name: 'access_token')` trên field `accessToken`, nó sinh code đọc key `'access_token'` (snake_case) từ JSON thay vì `'accessToken'` (camelCase mặc định):

```
Không có @JsonKey(name: 'access_token'):
    fromJson tìm key 'accessToken' trong JSON  ← KHÔNG tồn tại trong API response
    → accessToken = null
    → App crash khi dùng token
```

Bảng ánh xạ trong thực tế của project:

| API JSON key     | Dart field      | Annotation                          |
|------------------|-----------------|-------------------------------------|
| `access_token`   | `accessToken`   | `@JsonKey(name: 'access_token')`    |
| `refresh_token`  | `refreshToken`  | `@JsonKey(name: 'refresh_token')`   |
| `expires_in`     | `expiresIn`     | `@JsonKey(name: 'expires_in')`      |
| `token_type`     | `tokenType`     | `@JsonKey(name: 'token_type')`      |

Không có annotation, generator dùng tên field Dart làm key → sai với mọi API trả snake_case (đa số REST API đều vậy).

---

#### C2.5 Freezed Tạo Ra Gì trong `.freezed.dart`

**Bước 1 — Hiểu vấn đề gốc rễ trước**

Trong Dart, nếu không làm gì thêm, hai object có cùng giá trị vẫn bị coi là **khác nhau**:

```
final a = User(id: '1', name: 'Minh')   →  ô nhớ địa chỉ 0x001
final b = User(id: '1', name: 'Minh')   →  ô nhớ địa chỉ 0x002

a == b   →   FALSE
```

Dart không nhìn vào giá trị `id` hay `name` — nó chỉ so sánh **địa chỉ RAM** (`0x001` vs `0x002`). Đây là hành vi mặc định của mọi class Dart không có `==` override.

---

**Bước 2 — Tại sao điều đó là vấn đề?**

Riverpod dùng `==` để quyết định có cần rebuild widget hay không. Mỗi lần set state mới, Riverpod chạy ngầm bước kiểm tra này:

```
loginController.state = AsyncData(newUser)
                              │
              Riverpod: oldUser == newUser ?
              │
              ├── TRUE  → data không đổi → bỏ qua, không rebuild  ✅
              └── FALSE → data đổi → notify widget → rebuild       ✅

Nếu KHÔNG có == override:
              │
              └── Luôn FALSE (vì luôn khác địa chỉ RAM)
                  → luôn rebuild dù data không đổi                 ❌
```

Bạn không bao giờ tự tay viết `userA == userB` trong code — nhưng Riverpod làm điều đó **tự động ngầm** mỗi khi state thay đổi.

---

**Bước 3 — Kịch bản thực tế**

*Kịch bản 1 — User bấm Save mà không sửa gì:*

```
User vào màn hình Profile → bấm Save (không đổi gì)
App gọi API update → backend trả về User(id:'1', name:'Minh')
loginController.state = AsyncData(newUser)

Riverpod: oldUser == newUser?
  Có == override  →  TRUE  →  không rebuild ProfileScreen  ✅
  Không có ==     →  FALSE →  rebuild ProfileScreen thừa   ❌
```

*Kịch bản 2 — Token hết hạn, AuthInterceptor refresh:*

```
Access token hết hạn → AuthInterceptor gọi refresh API
Backend trả về User mới (data giống y chang)
loginController.state = AsyncData(newUser)

Riverpod: oldUser == newUser?
  Có == override  →  TRUE  →  màn hình không nhấp nháy    ✅
  Không có ==     →  FALSE →  màn hình rebuild không lý do ❌
```

---

**Bước 4 — Freezed sinh ra để giải quyết**

`freezed` đọc class có annotation `@freezed` và sinh ra file `.freezed.dart` chứa 3 thứ:

**① Mixin `_$User`** — thư viện các method dùng chung:
- `==` : so sánh từng field (`id`, `name`, `email`) thay vì địa chỉ RAM
- `hashCode` : `Object.hash(runtimeType, id, name, email)` — nhất quán với `==`
- `toString()` : `'User(id: 1, name: Minh, email: ...)''` — dễ debug
- `copyWith` : property trỏ tới `$UserCopyWith`

**② `$UserCopyWith<$Res>`** — interface và implementation của `copyWith`:

```
user.copyWith(name: 'Minh mới')
      │
      └── Tạo User MỚI trong RAM với:
            id    = user.id         (giữ nguyên)
            name  = 'Minh mới'     (thay)
            email = user.email      (giữ nguyên)
```

Không có Freezed, bạn phải viết tay: `User(id: user.id, name: 'Minh mới', email: user.email)` — dài dòng và dễ quên field khi class có nhiều field.

**③ Private class `_User`** — class thực sự được tạo khi gọi `User(...)`:

```
Bạn gọi:    User(id: '1', name: 'Minh')
Dart thực:  _User(id: '1', name: 'Minh')   ← private subclass
```

`_User` extend `User` và mixin `_$User` — có đủ `==`, `hashCode`, `copyWith`. Developer không thể tạo `User` theo cách nào khác → Freezed kiểm soát hoàn toàn implementation.

---

**Bước 5 — Tại sao `const factory` thay vì constructor thường?**

`factory` và `const` là hai keyword độc lập, làm hai việc khác nhau:

| Keyword | Ý nghĩa | Liên quan đến RAM? |
|---|---|---|
| `factory` | "Tôi kiểm soát object nào được trả về" — trả `_User` thay vì `User` | Không |
| `const` | Compile-time constant — cùng giá trị → cùng ô nhớ | **Có**, nhưng chỉ khi giá trị giống nhau |

`const` reuse RAM chỉ trong trường hợp:

```
final a = const User(id: '1', name: 'Minh');
final b = const User(id: '1', name: 'Minh');
identical(a, b)  →  TRUE   ← cùng ô nhớ

final c = const User(id: '2', name: 'Nam');
identical(a, c)  →  FALSE  ← giá trị khác, ô nhớ khác
```

Trong thực tế, User thường đến từ API (`UserModel.fromJson(json).toEntity()`) — **không phải `const`** → luôn tạo object mới. Đây là lý do `==` override quan trọng hơn `const`.

---

**Bước 6 — Tại sao không dùng thẳng object từ API?**

```
UserModel (Data Layer)       ← biết JSON, biết tên field API
    │  .toEntity()
    ▼
User entity (Domain Layer)   ← chỉ biết business data
```

Nếu backend đổi tên field `user_name` → `username`, bạn chỉ sửa `UserModel.fromJson` — không đụng đến `User` entity và toàn bộ business logic bên trên. Đây là lý do tách hai class thay vì dùng thẳng `UserModel` khắp nơi trong app.

---

#### C2.6 Diagram C.1: Annotation → build_runner → Output

```
                     Bạn viết (file nguồn)
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
  @riverpod             @freezed             @freezed
  tokenStorage()        class User           class UserModel
  (Riverpod provider)   (domain entity)      (data model)
        │                    │                    │
        └────────────────────┼────────────────────┘
                             │
                     dart run build_runner build
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
  core_providers.g.dart  user.freezed.dart   user_model.freezed.dart
  ┌──────────────────┐   ┌─────────────┐     user_model.g.dart
  │ TokenStorage     │   │ mixin _$User│     ┌──────────────────┐
  │ Provider class   │   │ • ==        │     │ _$UserModelFrom  │
  │ • create(ref)    │   │ • hashCode  │     │   Json()         │
  │ • isAutoDispose  │   │ • toString  │     │ _$UserModelTo    │
  │   : false        │   │ • copyWith  │     │   Json()         │
  │                  │   │ _User class │     └──────────────────┘
  │ const tokenStor  │   │ (impl)      │
  │   ageProvider    │   └─────────────┘
  │                  │
  │ hash string      │
  └──────────────────┘

  login_controller.g.dart             auth_service.g.dart
  ┌──────────────────────────┐        ┌──────────────────────────┐
  │ LoginControllerProvider  │        │ AuthServiceProvider       │
  │ • $AsyncNotifierProvider │        │ • isAutoDispose: true     │
  │ • isAutoDispose: false   │        │                           │
  │                          │        │ AuthStateProvider         │
  │ abstract _$LoginController│        │ • $FutureProvider<User?> │
  │ • runBuild() glue code   │        │ • isAutoDispose: true     │
  └──────────────────────────┘        └──────────────────────────┘
```

**Giải thích:** Mỗi file nguồn có annotation sẽ tương ứng với một hoặc nhiều file generated. Riverpod generator tạo `.g.dart` (provider infrastructure). Freezed generator tạo `.freezed.dart` (immutability). Json_serializable generator tạo `.g.dart` (JSON parsing). Tất cả đều được kết nối vào file nguồn qua cặp `part` / `part of` — compiler thấy chúng như một file duy nhất.

---

#### C2.7 Tại sao Không Sửa Tay `.g.dart`

Mỗi lần chạy `build_runner build`, toàn bộ nội dung các file `.g.dart` và `.freezed.dart` bị **ghi đè hoàn toàn**. Bất kỳ thay đổi tay nào sẽ mất sạch. Hơn nữa, nếu sửa tay nhưng không chạy lại build_runner, hash string sẽ không khớp với nội dung thực tế của hàm nguồn → Riverpod có thể không invalidate provider đúng lúc.

---

#### C2.8 Khi nào Phải Chạy build_runner

**Các trigger bắt buộc phải chạy:**

| Thay đổi trong source file                     | Lý do phải chạy lại                                                    |
| ---------------------------------------------- | ---------------------------------------------------------------------- |
| Thêm class mới có `@freezed` hoặc `@riverpod`  | File `.g.dart` / `.freezed.dart` chưa tồn tại → compile error ngay     |
| Thêm hoặc đổi tên field trong `@freezed` class | `fromJson` / `copyWith` trong file generated dùng tên cũ → runtime bug |
| Thêm hoặc sửa `@JsonKey(name:)`                | Mapping key JSON cũ → field null khi parse                             |
| Đổi tên function / class có `@riverpod`        | Provider cũ vẫn tồn tại, provider mới chưa có → compile error          |
| Clone repo lần đầu hoặc sau `flutter clean`    | File generated bị xoá → toàn bộ provider và model không tồn tại        |

**`build` vs `watch` — khi nào dùng cái nào:**

| Lệnh                          | Hành vi                                     | Dùng khi                                         |
| ----------------------------- | ------------------------------------------- | ------------------------------------------------ |
| `dart run build_runner build` | Chạy một lần, xong thoát                    | Trước khi commit, CI/CD, sau clone               |
| `dart run build_runner watch` | Chạy liên tục, tự rebuild khi file thay đổi | Đang dev và thêm nhiều class annotation liên tục |

> **Lưu ý:** `watch` tiêu tốn CPU và RAM liên tục. Nên dùng `build` cho các thay đổi lẻ tẻ, chỉ dùng `watch` khi đang "scaffolding" nhiều file cùng lúc.

**`--delete-conflicting-outputs` — khi nào cần:**

build_runner từ chối ghi đè file nếu không chắc file đó do chính nó tạo ra (để tránh xoá nhầm code tay). Khi gặp lỗi dạng `"Existing outputs conflict"`, flag này ra lệnh xoá toàn bộ output cũ trước khi generate lại:

```
dart run build_runner build --delete-conflicting-outputs
```

Thường xảy ra sau khi: đổi tên class có annotation, merge branch có file generated conflict, hoặc chạy `build_runner` không thành công giữa chừng lần trước.

---

### C3. keepAlive vs Non-keepAlive

| Provider                       | keepAlive? | Lý do                                                         |
| ------------------------------ | ---------- | ------------------------------------------------------------- |
| `tokenStorageProvider`         | `true`     | Singleton — tất cả interceptor đều cần, phải sống mãi         |
| `dioProvider`                  | `true`     | Singleton — 1 Dio instance cho toàn app, có interceptor state |
| `goRouterProvider`             | `true`     | Navigation instance không thể bị dispose                      |
| `routerNotifierProvider`       | `true`     | Cầu nối Riverpod↔GoRouter, phải sống mãi để listen            |
| `loginControllerProvider`      | `true`     | Session state của user, phải persist                          |
| `authRepositoryProvider`       | `false`    | Stateless, recreate khi cần là OK                             |
| `authServiceProvider`          | `false`    | Stateless, phụ thuộc vào authRepository                       |
| `authRemoteDatasourceProvider` | `false`    | Stateless, chỉ wrap Dio                                       |
| `authStateProvider`            | `false`    | Future provider, auto-dispose sau khi resolved                |

> **Tại sao `authStateProvider` là auto-dispose dù quan trọng?** `authStateProvider` là `FutureProvider` trả về `User?` — nó chỉ làm nhiệm vụ "fetch một lần" khi app khởi động. Sau khi Future resolved, `loginControllerProvider` đã cache kết quả trong state `AsyncData(User?)`. `authStateProvider` không còn cần thiết nữa — giữ nó trong memory là lãng phí. Ngược lại, `loginControllerProvider` là `AsyncNotifier` chứa state sống động — nó phải keepAlive vì mọi nơi trong app (RouterNotifier, HomeScreen logout button) đều cần đọc session state.

---

### Diagram C.2: Provider Dependency Tree

```
                    ┌──────────────────┐
                    │  goRouterProvider│ (keepAlive)
                    │  GoRouter        │
                    └────────┬─────────┘
                             │ ref.watch
                    ┌────────▼─────────┐
                    │ routerNotifier   │ (keepAlive)
                    │ RouterNotifier   │
                    └────────┬─────────┘
                             │ ref.listen
              ┌──────────────▼────────────────┐
              │   loginControllerProvider     │ (keepAlive)
              │   LoginController             │
              └──────────────┬────────────────┘
                             │ ref.read
              ┌──────────────▼────────────────┐
              │   authServiceProvider         │ (auto-dispose)
              │   AuthService                 │
              └──────────────┬────────────────┘
                             │ ref.watch
              ┌──────────────▼────────────────┐
              │   authRepositoryProvider      │ (auto-dispose)
              │   AuthRepositoryImpl          │
              └────────┬─────────┬────────────┘
              ref.watch│         │ref.watch
   ┌──────────▼──────┐  ┌────────▼────────────┐
   │ authRemoteData  │  │  tokenStorage       │ (keepAlive)
   │ sourceProvider  │  │  Provider           │
   └──────┬──────────┘  └────────┬────────────┘
  ref.watch│                     │ wraps
   ┌───────▼──────┐    ┌─────────▼──────────────┐
   │ dioProvider  │    │  FlutterSecureStorage  │
   │ (keepAlive)  │    │  (hardware-backed)     │
   └──────┬───────┘    └────────────────────────┘
          │ contains
   ┌──────▼──────────────────────────────────────┐
   │  AuthInterceptor (ref tokenStorageProvider) │
   │  AppLogInterceptor                          │
   └─────────────────────────────────────────────┘
```

**Giải thích:** Tree đọc từ dưới lên: FlutterSecureStorage là leaf node, không phụ thuộc gì. TokenStorage wrap nó. Dio nhận TokenStorage để tạo AuthInterceptor. AuthRepositoryImpl cần cả Dio (qua datasource) và TokenStorage. Tất cả bubble lên đến GoRouter là root. Khi Riverpod khởi động, nó lazy-init — chỉ tạo provider khi lần đầu tiên được watch/read.

---

### Diagram C.3: Startup Initialization Chain

```
main.dart
    │
    ▼
runApp(ProviderScope(child: MyApp()))
    │   ProviderScope = container của Riverpod
    │
    ▼
MyApp.build()
    │   ref.watch(goRouterProvider)
    │
    ▼  [LAZY INIT CHAIN BẮT ĐẦU]
goRouterProvider khởi tạo
    │   ref.watch(routerNotifierProvider)
    │
    ▼
routerNotifierProvider khởi tạo
    │   ref.listen(loginControllerProvider, ...)
    │
    ▼
loginControllerProvider khởi tạo
    │   build() → ref.watch(authStateProvider.future)
    │   State = AsyncLoading (bắt đầu kiểm tra token)
    │
    ▼
authStateProvider.future evaluate
    │   authService.getCurrentUser()
    │   → tokenStorage.getAccessToken()
    │
    ├── [Không có token] → return null
    │       loginControllerProvider.state = AsyncData(null)
    │       routerNotifier.notifyListeners()
    │       GoRouter.redirect() → '/login'
    │
    ├── [Có token] → dio.get('/users/me')
    │       loginControllerProvider.state = AsyncData(user)
    │       routerNotifier.notifyListeners()
    │       GoRouter.redirect() → '/' (HomeScreen)
    │
    └── [Exception — network fail, server 500, timeout]
            authStateProvider throws Exception
            loginControllerProvider.state = AsyncError(exception, stackTrace)
            routerNotifier.notifyListeners()
            GoRouter.redirect() → '/login' (xử lý như chưa đăng nhập)
            [User thấy LoginScreen — có thể thử lại sau]
```

**Giải thích:** Toàn bộ chain này là lazy — chỉ chạy khi `goRouterProvider` được watch lần đầu, tức là khi `MyApp` build. Trong lúc `loginControllerProvider.state = AsyncLoading`, `GoRouter.redirect()` trả về `'/login'` tạm thời. Sau khi token check xong, `notifyListeners()` trigger GoRouter re-evaluate redirect, đưa user đến đúng màn hình. Nhánh Exception xảy ra khi network bị mất khi restore session — user thấy LoginScreen và có thể thử lại.

---

## D. Networking Layer: Dio & Interceptors

### D1. Cấu hình Dio

`dioProvider` tạo ra một Dio instance với `BaseOptions`:

- `baseUrl`: lấy từ `AppEnvironment.baseUrl` — tự động thay đổi theo môi trường
- `connectTimeout` và `receiveTimeout`: 15 giây mỗi loại
- `Content-Type: application/json` làm default header

Sau khi tạo Dio, hai interceptor được thêm theo thứ tự: `AppLogInterceptor` trước, `AuthInterceptor` sau.

---

### D2. Environment System

`AppEnvironment` giữ trạng thái môi trường hiện tại (`current`) và cung cấp `baseUrl` tương ứng:

- **prod:** `http://localhost:3000` (placeholder, team tự thay bằng production URL)
- **staging:** `https://staging.api.example.com`
- **dev:** iOS dùng `localhost:3000`, Android Emulator dùng `10.0.2.2:3000`

Lý do Android Emulator dùng `10.0.2.2`: Emulator chạy trong VM, `localhost` của emulator là bên trong VM. `10.0.2.2` là địa chỉ đặc biệt trỏ về máy host thực.

**Cách switch môi trường:**

`AppEnvironment.current` được set trong `main.dart` trước khi gọi `runApp()`. Approach được khuyến nghị dùng compile-time constant qua `--dart-define`:

```
flutter run --dart-define=ENVIRONMENT=prod     # Production build
flutter run --dart-define=ENVIRONMENT=staging  # Staging build
flutter run                                    # Dev (mặc định)
```

`main.dart` đọc constant này và set `AppEnvironment.current` tương ứng trước khi khởi tạo bất kỳ thứ gì.

**Lý do dùng `--dart-define` thay vì hard-code:** Build server (CI/CD) có thể build production binary mà không cần sửa source code — chỉ thay đổi build argument. Không có nguy cơ vô tình commit code với environment sai. Team QA và team dev có thể build từ cùng source nhưng khác environment.

---

### Diagram D.1: Interceptor Pipeline

```
Gọi API: dio.get('/users/me')
         │
         ▼
┌────────────────────────────────────────────────────────────────┐
│                    OUTGOING (Request)                          │
│                                                                │
│  1. AppLogInterceptor.onRequest()                              │
│     [debug] Print: METHOD URL Headers Body                     │
│     handler.next(options)  ← PHẢI gọi để tiếp tục             │
│              │                                                 │
│              ▼                                                 │
│  2. AuthInterceptor.onRequest()                                │
│     tokenStorage.getAccessToken()                              │
│     options.headers['Authorization'] = 'Bearer $token'        │
│     handler.next(options)                                      │
└────────────────────────────┬───────────────────────────────────┘
                             │ HTTP Request với Bearer token
                             ▼
                        Backend API
                             │ HTTP Response
                             ▼
┌────────────────────────────────────────────────────────────────┐
│                    INCOMING (Response / Error)                 │
│                                                                │
│  [Nếu thành công 2xx]                                          │
│  2. AuthInterceptor.onResponse() → handler.next(response)     │
│  1. AppLogInterceptor.onResponse()                             │
│     [debug] Print: statusCode URL Data                         │
│     handler.next(response)                                     │
│                                                                │
│  [Nếu lỗi]                                                     │
│  2. AuthInterceptor.onError()                                  │
│     Xử lý 401: refresh token → retry / logout                 │
│  1. AppLogInterceptor.onError()                                │
│     [debug] Print: statusCode URL Message                      │
│     handler.next(err)                                          │
└────────────────────────────┬───────────────────────────────────┘
                             │ Kết quả
                             ▼
              Caller nhận Response hoặc DioException
```

**Giải thích:** Interceptor hoạt động như middleware chain. Request đi qua theo thứ tự thêm vào (Log trước, Auth sau). Response đi ngược lại (Auth trước, Log sau). **Quan trọng:** Mỗi interceptor PHẢI gọi `handler.next()` (hoặc `handler.resolve()`/`handler.reject()`) — nếu không, pipeline bị treo vĩnh viễn.

---

### D3. AppLogInterceptor

`AppLogInterceptor` có một nhiệm vụ duy nhất: in log ra console khi debug. Được bảo vệ bởi `kDebugMode` — trong production build, code bên trong `if (kDebugMode)` bị tree-shaken (loại bỏ).

Ba hooks: `onRequest` (log trước khi gửi), `onResponse` (log khi nhận thành công), `onError` (log khi nhận lỗi). Tất cả đều gọi `handler.next()` mà không thay đổi gì — AppLogInterceptor là interceptor "transparent" (chỉ đọc, không sửa).

---

### D4. AuthInterceptor — Trọng tâm của Networking

AuthInterceptor là interceptor phức tạp nhất. Xử lý 4 luồng khác nhau tùy tình huống.

---

### D4.0 Completer\<String?\> — Giải phẫu Cơ chế Phối hợp Async

Trước khi xem các diagram luồng, cần hiểu rõ `Completer<String?>` — primitive cốt lõi của toàn bộ AuthInterceptor. Đây là kỹ thuật tinh tế nhất trong codebase này.

#### Completer là gì?

`Completer<T>` là Dart primitive đại diện cho "một kết quả chưa có, nhưng sẽ đến sau". Nó tạo ra một **cặp không tách rời**:

```
Completer<String?>
    │
    ├── .future  → Future<String?>   ← nhiều caller có thể await cùng lúc
    │                                   (pending cho đến khi complete() được gọi)
    │
    └── .complete(value)             ← ai đó gọi khi có kết quả
             → .future resolves với value cho TẤT CẢ người đang await, đồng thời
```

**Phép ẩn dụ hộp thư rỗng:**

Hình dung `Completer` như một hộp thư chưa có thư. Bất kỳ ai (goroutine B, C) đều có thể "đứng chờ" trước hộp thư đó bằng `await completer.future`. Khi người đưa thư (A) gọi `complete("thư đã đến")` — tất cả người đang chờ đều nhận được thư cùng lúc, ngay lập tức, không delay.

---

#### Tại sao không dùng Boolean Flag đơn giản?

**Cách naive — dùng boolean + polling:**

```
bool _isRefreshing = false;
String? _cachedToken;

Future<String?> _getNewAccessToken() async {
  if (_isRefreshing) {
    // Chờ bằng polling — SAI
    while (_isRefreshing) {
      await Future.delayed(Duration(milliseconds: 50));
    }
    return _cachedToken;  // Nhận token từ biến shared
  }
  _isRefreshing = true;
  final token = await _doRefreshApiCall();
  _cachedToken = token;
  _isRefreshing = false;
  return token;
}
```

**3 vấn đề nghiêm trọng của cách này:**

| Vấn đề                     | Giải thích                                                                                                                      |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| **CPU lãng phí**           | Vòng lặp `while` poll mỗi 50ms — CPU bị đánh thức liên tục khi không cần                                                        |
| **Race condition tiềm ẩn** | B check `_isRefreshing = false` đúng lúc giữa `_isRefreshing = false` và `_cachedToken = token` → nhận `null` thay vì token mới |
| **Độ trễ nhân tạo**        | B và C đợi thêm tối đa 50ms không cần thiết — kể cả khi A đã xong từ lâu                                                        |

**Với Completer — zero polling, zero race condition:**

`await completer.future` không tốn CPU. Dart event loop "park" coroutine và wake up **chính xác** khi `complete()` được gọi — không sớm hơn, không trễ hơn. Không có polling, không có shared variable race.

---

#### Tại sao Kiểu Generic là String? (Nullable)?

`Completer<String?>` — dấu `?` encode hai kết quả có thể của refresh operation:

| Giá trị khi `complete()`  | Ý nghĩa                                                                |
| ------------------------- | ---------------------------------------------------------------------- |
| `complete("eyJhbGci...")` | Refresh thành công → đây là access token mới                           |
| `complete(null)`          | Refresh thất bại (không có refresh token, server 401, network timeout) |

Caller nhận `null` → tự hiểu là "refresh thất bại" → thực hiện logout. Không cần throw exception riêng, không cần enum status — null là tín hiệu "hãy logout" được encode thẳng vào type.

---

#### Cặp đôi: `_isRefreshing` + `_refreshCompleter`

Hai biến instance này hoạt động như một **stateful lock**:

```
Trạng thái 1 — Idle (ban đầu, sau khi reset):
  _isRefreshing = false
  _refreshCompleter = null

Trạng thái 2 — Đang refresh (sau khi Request A bắt đầu):
  _isRefreshing = true
  _refreshCompleter = Completer<String?>()  ← pending future

Trạng thái 3 — Kết thúc (sau khi A complete + reset):
  _isRefreshing = false
  _refreshCompleter = null  ← Idle lại, sẵn sàng cho lần tiếp theo
```

**Tại sao phải reset `_refreshCompleter = null` sau khi `complete()`?**

Sau khi `complete()` được gọi, `completer.future` đã resolved với giá trị cụ thể. Nếu giữ lại completer cũ, lần 401 tiếp theo sẽ thấy `_isRefreshing = false` (đã reset) nhưng nếu dùng lại `_refreshCompleter`, caller sẽ nhận ngay token cũ (từ lần refresh trước) thay vì chờ refresh mới. Bằng cách set `null`, lần 401 tiếp theo tạo `Completer` hoàn toàn mới — fresh slate.

**Vì sao cần cả hai biến (không chỉ dùng `_refreshCompleter != null` làm flag)?**

Về mặt logic, `_refreshCompleter != null` hoàn toàn có thể thay thế `_isRefreshing`. Trong code hiện tại, `_isRefreshing` là biến explicit cho **clarity** — khi đọc code thấy `_isRefreshing = true` ngay lập tức hiểu "đang trong trạng thái refresh", thay vì phải suy nghĩ "completer != null nghĩa là gì?". Đây là quyết định code style, không ảnh hưởng correctness.

---

#### Dart Event Loop — Tại sao "Gần Cùng Lúc" Xảy ra?

Dart là single-threaded với event loop. Khi 3 API call đồng thời nhận 401:

```
Timeline (không phải parallel thread — là event loop interleaving):

t=0  Request A bắt đầu: dio.get('/users/me')
t=1  Request B bắt đầu: dio.get('/products')
t=2  Request C bắt đầu: dio.get('/settings')

t=50 Network response đến: A nhận 401
t=51 Event loop xử lý A.onError() → vào _getNewAccessToken()
t=52 A: _isRefreshing == false → tôi làm → _isRefreshing = true, tạo Completer → await /api/refresh
     [A bị suspend, event loop tiếp tục]

t=53 Network response đến: B nhận 401
t=54 Event loop xử lý B.onError() → vào _getNewAccessToken()
t=55 B: _isRefreshing == true → await _refreshCompleter!.future → B bị suspend

t=56 Network response đến: C nhận 401
t=57 Event loop xử lý C.onError() → vào _getNewAccessToken()
t=58 C: _isRefreshing == true → await _refreshCompleter!.future → C bị suspend

t=200 /api/refresh response đến
t=201 Event loop wake up A → lưu token, complete(newToken) → A retry
      complete() unblocks B và C ngay lập tức
t=202 B nhận newToken → retry B_request
t=203 C nhận newToken → retry C_request
```

`await _refreshCompleter!.future` không block thread — nó chỉ "đăng ký" callback với event loop. Dart tiếp tục xử lý các event khác (C nhận 401, v.v.) trong khi B đang "chờ".

---

#### Diagram D.2: Happy Path — Request Thành công

```
Request bất kỳ (ví dụ: GET /users/me)
    │
    ▼ onRequest()
tokenStorage.getAccessToken()
    │
    ├── [Token tồn tại]
    │   Gắn header: Authorization: Bearer <token>
    │   handler.next(options)
    │              │
    │              ▼ Network
    │         Backend → 200 OK
    │              │
    │   handler.next(response) → Caller nhận data
    │
    └── [Không có token]
        Không gắn header
        handler.next(options) → Request đi không có auth
        (Caller nhận 401 nếu endpoint cần auth → chuyển sang flow 401)
```

---

#### Diagram D.3: Xử lý 401 Đơn giản (Single Request)

```
Request A → 401 Unauthorized
    │
    ▼ onError()
statusCode == 401? → Có
path == '/api/refresh'? → Không (đây là request thường)
    │
    ▼ _getNewAccessToken()
_isRefreshing == false → Không có ai đang refresh
    │
    ▼ Bắt đầu refresh
_isRefreshing = true
_refreshCompleter = Completer<String?>()
    │
    ▼ tokenStorage.getRefreshToken()
    │
    ├── [refreshToken tồn tại]
    │   dio.post('/api/refresh', data: {refresh_token: ...})
    │              │
    │              ▼ 200 OK
    │   Lấy newAccessToken + newRefreshToken
    │   tokenStorage.saveAccessToken(new)
    │   tokenStorage.saveRefreshToken(new)
    │   _refreshCompleter.complete(newAccessToken)
    │   _isRefreshing = false  ← mở lock
    │   _refreshCompleter = null  ← reset để dùng lại lần sau
    │              │
    │              ▼ return newAccessToken
    │   _retry(originalRequest, newAccessToken)
    │   dio.request(path, headers: {Authorization: Bearer newToken})
    │              │
    │              ▼ 200 OK
    │   handler.resolve(retryResponse)
    │   → Caller nhận response như bình thường
    │
    └── [refreshToken = null]
        _refreshCompleter.complete(null)
        _isRefreshing = false
        _refreshCompleter = null  ← reset
        _logout() → clear storage + handler.reject()
```

---

#### Diagram D.4: 401 Đồng thời — Completer Lock Pattern (QUAN TRỌNG NHẤT)

```
Tình huống: 3 request A, B, C cùng bị 401 do token hết hạn

Request A   Request B   Request C
    │            │           │
    ▼            ▼           ▼
    onError()    onError()   onError()
    (gần cùng lúc — Dart event loop xen kẽ)

──────────────────────────────────────────
BƯỚC 1: A vào _getNewAccessToken() đầu tiên
──────────────────────────────────────────
A: _isRefreshing == false → Mình làm
   _isRefreshing = true
   _refreshCompleter = Completer<String?>()
   → gọi POST /api/refresh  [đang chờ]

──────────────────────────────────────────
BƯỚC 2: B vào _getNewAccessToken()
──────────────────────────────────────────
B: _isRefreshing == true → Đã có người refresh
   return _refreshCompleter!.future  [CHỜ A xong]

──────────────────────────────────────────
BƯỚC 3: C vào _getNewAccessToken()
──────────────────────────────────────────
C: _isRefreshing == true → Đã có người refresh
   return _refreshCompleter!.future  [CHỜ A xong]

──────────────────────────────────────────
BƯỚC 4: A nhận response từ /api/refresh
──────────────────────────────────────────
A: Lưu token mới
   _refreshCompleter.complete(newAccessToken)  ← UNBLOCK B và C
   _isRefreshing = false
   _refreshCompleter = null

──────────────────────────────────────────
BƯỚC 5: B và C nhận token từ Completer
──────────────────────────────────────────
B: nhận newAccessToken → _retry(B_request, newToken) → resolve
C: nhận newAccessToken → _retry(C_request, newToken) → resolve

KẾT QUẢ: 3 request thành công, chỉ 1 lần gọi /api/refresh
```

**Giải thích:** Không có Completer lock, 3 request sẽ gọi `/api/refresh` 3 lần song song. Lần refresh thứ 2 và 3 có thể fail (server invalidate token cũ sau refresh đầu tiên). Với Completer, chỉ request đầu tiên thực sự gọi API, các request còn lại "subscribe" vào Completer và nhận cùng kết quả. `_isRefreshing` là flag kiểm tra. `_refreshCompleter` là điểm tập kết kết quả. Khi `complete()` được gọi, tất cả `await _refreshCompleter.future` unblock đồng thời.

---

#### Diagram D.5: Forced Logout — Khi Refresh Thất bại

```
Case 1: /api/refresh trả về 401
    │
    ▼ onError()
path == '/api/refresh' → Đúng
    │
    ▼ _isRefreshing = false  ← reset lock
    _refreshCompleter?.complete(null)  ← unblock các request đang chờ Completer
    _refreshCompleter = null
    │
    ▼ _logout()
tokenStorage.clear()  ← Xóa hết token
handler.reject(DioException 'Session expired')
    │
    ▼
Caller nhận DioException
AuthRepositoryImpl._handleDioError() → SessionExpiredException (nếu có)
LoginController.state = AsyncError(SessionExpiredException)
RouterNotifier.notifyListeners()
GoRouter.redirect() → '/login'

Case 2: /api/refresh ném Exception khác (network timeout, server 500)
    │
    ▼ onError() → _getNewAccessToken()
try {
  dio.post('/api/refresh')  ← throw Exception
} catch (_) {
  _refreshCompleter.complete(null)
  return null
}
newAccessToken == null → _logout()
    │
    ▼ (giống Case 1)
```

**Giải thích:** Khi refresh thất bại với bất kỳ lý do gì (401 từ refresh endpoint, network timeout, server error), kết quả luôn là logout. Đây là safety net — tình huống này chỉ xảy ra khi refresh token hết hạn (sau 30 ngày) hoặc bị revoke bên server.

---

### D5. API Endpoints Registry

`ApiEndpoints` class chỉ lưu **path** (ví dụ `'/api/signin'`), không lưu full URL (`'https://api.example.com/api/signin'`).

**Lý do:** `baseUrl` do Dio `BaseOptions` quản lý. Khi `AppEnvironment.current` thay đổi (dev ↔ staging ↔ prod), chỉ cần đổi `baseUrl` ở một chỗ — tất cả path tự động dùng đúng environment.

**Lý do thứ hai (quan trọng hơn):** `AuthInterceptor` so sánh `err.requestOptions.path == ApiEndpoints.refresh` để phát hiện khi chính request refresh bị 401. Nếu lưu full URL, comparison này sẽ fail vì `requestOptions.path` chỉ chứa path, không có domain.

---

## E. Token Security: flutter_secure_storage

### E1. Tại sao Không dùng SharedPreferences?

**Bước 1 — SharedPreferences lưu token ở đâu?**

`SharedPreferences` ghi ra file text có thể đọc được bằng mắt thường:

```
Android: /data/data/com.example.sleepbuddy/shared_prefs/
         FlutterSharedPreferences.xml

Nội dung file:
<map>
  <string name="access_token">eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...</string>
  <string name="refresh_token">dGhpcyBpcyBhIHJlZnJlc2ggdG9rZW4...</string>
</map>
```

Plaintext. Ai có quyền đọc file này — root user, forensic tool, hay bất kỳ ai extract được backup — đều lấy được token ngay lập tức.

---

**Bước 2 — Kịch bản tấn công thực tế:**

```
Attacker lấy được điện thoại user (hoặc có quyền root)
    │
    ├── SharedPreferences:
    │   adb pull /data/data/.../shared_prefs/FlutterSharedPreferences.xml
    │   → Mở file, đọc access_token và refresh_token ngay lập tức  ❌
    │
    └── flutter_secure_storage (Keychain/Keystore):
        Lấy được file encrypted → không decrypt được
        vì key mã hóa nằm trong hardware chip của thiết bị đó,
        không thể copy ra ngoài                                     ✅
```

---

**Bước 3 — Cơ chế bảo vệ của Keychain/Keystore:**

`flutter_secure_storage` không chỉ encrypt data — điểm mấu chốt là **key mã hóa được giữ bên trong hardware chip**:

- **iOS Keychain (Secure Enclave):** Key AES-256 sinh ra trong chip Apple T2/M1/A-series, được bảo vệ bởi `kSecAttrAccessibleWhenUnlocked`. Key không bao giờ rời khỏi chip đó. Dù sao chép toàn bộ bộ nhớ flash ra ngoài, không có máy nào khác decrypt được — vì key chỉ tồn tại trong đúng con chip đó.

- **Android Keystore (TEE — Trusted Execution Environment):** Private key sinh ra và lưu trong TEE — một vùng xử lý cô lập với Android OS. Ngay cả khi OS bị root, code chạy trong Android vẫn không thể export key ra ngoài TEE. Mọi thao tác mã hóa/giải mã đều xảy ra bên trong TEE.

**Kết quả:** Ngay cả khi file storage bị sao chép ra ngoài, attacker không thể decrypt được token vì key chỉ tồn tại trong hardware của thiết bị cụ thể đó — đúng con chip đó, đúng thiết bị đó.

---

### E2. TokenStorage Wrapper Pattern

`AuthInterceptor` và `AuthRepositoryImpl` không gọi `FlutterSecureStorage` trực tiếp. Thay vào đó, cả hai nhận `TokenStorage` qua constructor injection.

**Lý do cần wrapper:**

1. **Mockable trong test:** Test có thể inject `FakeTokenStorage` thay vì `FlutterSecureStorage` thực. `FlutterSecureStorage` cần platform channel (iOS/Android) — không chạy được trong unit test.

2. **Dependency Injection qua Riverpod:** `tokenStorageProvider` là một Riverpod provider, có thể override trong test với `ProviderScope(overrides: [...])`.

3. **Tập trung key constants:** `_keyAccessToken = 'access_token'` chỉ định nghĩa một lần. Nếu đổi key name, sửa một chỗ.

4. **API đơn giản hóa:** `saveTokens()` lưu cả access và refresh token song song (`Future.wait`). Caller không cần biết cơ chế bên trong.

---

### E3. Keychain vs Keystore

| Thuộc tính        | iOS Keychain                               | Android Keystore                    |
| ----------------- | ------------------------------------------ | ----------------------------------- |
| Location          | Secure Enclave (chip Apple T2/M1/A-series) | TEE (Trusted Execution Environment) |
| Mã hóa            | AES-256, key trong hardware                | AES-256 GCM, key trong hardware     |
| Truy cập khi lock | Không (kSecAttrAccessibleWhenUnlocked)     | Không (BIOMETRIC_STRONG)            |
| Backup            | Có thể exclude khỏi iCloud backup          | Không backup qua Android Backup     |
| Xử lý uninstall   | Key bị xóa                                 | Key bị xóa                          |

---

### Diagram E.1: Token Lifecycle

```
Sau Login thành công
    │
    ▼ AuthRepositoryImpl.login()
saveTokens(accessToken, refreshToken)
    │   Future.wait([
    │     storage.write('access_token', value: accessToken),
    │     storage.write('refresh_token', value: refreshToken)
    │   ])
    │
    ▼ Token lưu trong Keychain/Keystore
    ┌────────────────────────────────────┐
    │  Hardware-backed Secure Storage    │
    │  'access_token'  → 'abc123...'     │
    │  'refresh_token' → 'xyz789...'     │
    └───────────────────────┬────────────┘
                            │
         ┌──────────────────┼───────────────────┐
         │                  │                   │
         ▼ Attach           ▼ Restore session   ▼ Refresh
    AuthInterceptor    getCurrentUser()    _getNewAccessToken()
    onRequest():       getAccessToken()    getRefreshToken()
    read access_token  → null? logout      → POST /api/refresh
                        → exists? get      → saveAccessToken(new)
                          profile          → saveRefreshToken(new)
                                           │
                                           ▼ Sau Logout
                                      tokenStorage.clear()
                                      storage.deleteAll()
                                      ┌──────────────────┐
                                      │  Storage trống   │
                                      └──────────────────┘
```

**Giải thích:** Token lifecycle có 4 sự kiện: lưu sau login, đọc khi attach header, cập nhật sau refresh, xóa khi logout. Mọi tương tác với storage đều qua `TokenStorage` wrapper — không có chỗ nào khác trong codebase gọi `FlutterSecureStorage` trực tiếp.

---

## F. Error Handling: Sealed AppException

### F1. Tại sao Sealed Class?

**Bước 1 — Vấn đề khi dùng String hay generic Exception:**

Trước khi có sealed class, cách phổ biến nhất là throw `Exception` với message String, rồi parse string ở UI:

```
// Cách cũ — dùng Exception với String message
try {
  await login(email, password);
} catch (e) {
  // Phải parse string để biết loại lỗi
  if (e.toString().contains('không đúng')) {
    showRedText('Sai thông tin đăng nhập');
  } else if (e.toString().contains('bị khóa')) {
    showDialog('Tài khoản bị khóa');
  }
  // Backend đổi message từ 'không đúng' → 'không chính xác'
  // → App hỏng im lặng, không có compile error  ❌
}
```

Vấn đề cốt lõi: UI phụ thuộc vào nội dung của một cái **String** — thứ mà compiler không kiểm tra được. Backend đổi wording, app hỏng mà không có warning nào.

---

**Bước 2 — Sealed class giải quyết:**

```
// Sealed class — compiler kiểm tra exhaustive
switch (exception) {
  case InvalidCredentialsException():
    showRedText('Sai thông tin đăng nhập');
  case AccountSuspendedException():
    showDialog('Tài khoản bị khóa');
  case NetworkException():
    showSnackBar('Lỗi kết nối mạng');
  // Thêm SessionExpiredException mà quên thêm case →
  // compiler báo lỗi ngay khi build  ✅
}
```

UI không còn parse string. UI xử lý **type** — thứ mà compiler hiểu. Thêm subclass mới mà quên xử lý ở UI, build fail ngay — không chờ đến lúc user gặp bug.

---

**Bước 3 — Tại sao cần từ khóa "sealed"?**

Keyword `sealed` có một ý nghĩa duy nhất: "class này chỉ có thể có subclass **trong cùng file**".

Tại sao điều đó quan trọng?

- Compiler biết chính xác có bao nhiêu subclass tồn tại (vì không ai ngoài file đó có thể thêm)
- Biết chính xác → kiểm tra được `switch` có xử lý hết mọi case không (exhaustive check)
- Nếu không có `sealed`, ai cũng có thể tạo subclass ở file khác → compiler không biết hết → không thể đảm bảo switch đầy đủ → mất toàn bộ lợi ích

**Sealed class giải quyết:** Compiler bắt buộc `switch` phải xử lý mọi subclass. Nếu thêm `SessionExpiredException` vào sealed class mà quên thêm case trong UI, compiler báo lỗi ngay khi build — không cần chờ runtime.

---

### Diagram F.1: AppException Hierarchy

```
                    sealed class AppException
                         │  implements Exception
                         │  final String message
                         │  toString() → message
                         │
         ┌───────────────┼──────────────────────┐
         │               │                      │
         ▼               ▼                      ▼
InvalidCredentials  AccountSuspended      NotFoundException
Exception           Exception             (404)
(401)               (403)                 "Tài khoản không tồn tại"
"Email/password     "Tài khoản bị khóa"
không đúng"

         ┌───────────────┼──────────────────────┐
         │               │                      │
         ▼               ▼                      ▼
ServerException    SessionExpired         NetworkException
(500)              Exception              (lỗi mạng / timeout)
"Lỗi server"       "Phiên đăng nhập      NetworkException([String?])
                    hết hạn"             "Lỗi kết nối mạng" (default)
                                          hoặc custom message
```

**Giải thích:** Tất cả 6 subclass đều `extends AppException`. Sealed class không cho phép subclass bên ngoài file này. `NetworkException` đặc biệt vì nhận optional String — cho phép pass DioException.message khi không map được HTTP status cụ thể.

---

### Diagram F.2: Error Propagation — Từ DioException đến UI SnackBar

```
AuthRemoteDatasource.login()
    │
    ├── Thành công → LoginResponseModel
    │
    └── Ném DioException (e.g., statusCode 401)
             │
             ▼ AuthRepositoryImpl._handleDioError(e)
        switch (e.response?.statusCode) {
          401 → throw InvalidCredentialsException()
          403 → throw AccountSuspendedException()
          404 → throw NotFoundException()
          500 → throw ServerException()
          _   → throw NetworkException(e.message)
        }
             │
             ▼ Bubble up qua AuthService (không catch)
        LoginController.login()
             │
             ▼ AsyncValue.guard(() => authService.signIn(...))
        Catch exception → state = AsyncError(exception, stackTrace)
             │
             ▼ Riverpod notify listeners
        LoginScreen ref.listen(loginControllerProvider, callback)
             │
             ▼ _listenLoginState() khi state = AsyncError
        next.whenOrNull(
          error: (err, _) =>
            ScaffoldMessenger.showSnackBar(
              SnackBar(content: Text(err.toString()))
              // err.toString() → AppException.toString() → message
              // e.g., "Email hoặc mật khẩu không đúng"
            )
        )
             │
             ▼ User thấy SnackBar màu đỏ với message
```

**Giải thích:** Có 3 ranh giới quan trọng: (1) Data layer chuyển `DioException` → `AppException`, (2) Application/Controller dùng `AsyncValue.guard` để wrap exception vào `AsyncError`, (3) Presentation dùng `ref.listen` để react khi state thay đổi. Presentation không bao giờ thấy `DioException`.

---

### F2. Bảng Mapping HTTP Status → AppException

| HTTP Status | AppException                                   | Message hiển thị                    |
| ----------- | ---------------------------------------------- | ----------------------------------- |
| 400         | `NetworkException(e.response.data['message'])` | Message từ server                   |
| 401         | `InvalidCredentialsException`                  | "Email hoặc mật khẩu không đúng"    |
| 403         | `AccountSuspendedException`                    | "Tài khoản bị khóa"                 |
| 404         | `NotFoundException`                            | "Tài khoản không tồn tại"           |
| 500         | `ServerException`                              | "Lỗi server, vui lòng thử lại"      |
| Khác / null | `NetworkException(e.message)`                  | "Lỗi kết nối mạng" hoặc Dio message |

---

### F3. Hai Pattern UI xử lý Error

**Pattern 1: `ref.listen` — dùng cho side effect (SnackBar, Navigation)**

Phù hợp khi lỗi cần trigger hành động (show popup, navigate về login). Logic nằm trong callback, không ảnh hưởng đến widget tree chính. Xem `LoginScreen._listenLoginState()`.

**Pattern 2: `AsyncValueWidget.when(error:)` — dùng cho render inline**

Phù hợp khi lỗi cần hiển thị ngay trong layout (vd: danh sách rỗng với message lỗi). `AsyncValueWidget` nhận `AsyncValue<T>` và render `CircularProgressIndicator` khi loading, `ErrorMessageWidget` khi error, widget data khi thành công.

**Quy tắc chọn:** Nếu lỗi cần thay đổi state app (navigate, show modal) → `ref.listen`. Nếu lỗi chỉ cần hiển thị trong màn hình hiện tại → `AsyncValueWidget`.

---

## G. State Management: AsyncNotifier Pattern

### Diagram G.1: AsyncValue State Machine

```
                    ┌─────────────────┐
                    │  AsyncLoading   │ ← Trạng thái ban đầu khi build()
                    │  (đang fetch)   │   hoặc khi set state = AsyncLoading()
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
               ┌───►  evaluate:      │
               │    │  build() hoặc  │
               │    │  action method │
               │    └────────┬───────┘
               │             │
               │    ┌────────┴────────────────┐
               │    │                         │
               │    ▼                         ▼
               │  ┌──────────────┐    ┌──────────────────┐
               │  │  AsyncData   │    │   AsyncError      │
               │  │  (thành công)│    │   (thất bại)      │
               │  │  data: User? │    │   error: AppEx    │
               │  └──────┬───────┘    └────────┬──────────┘
               │         │                     │
               │         │  User action        │ User retry
               │         └──────────┬──────────┘
               │                    │
               └────────────────────┘
                  state = AsyncLoading() → cycle lại

Ví dụ cụ thể:

App start   → build() → AsyncLoading
               └→ authState.future resolves → AsyncData(null)   [chưa login]
                                           → AsyncData(User)    [đã login]

login()     → state = AsyncLoading()
               └→ authService.signIn() → AsyncData(User)       [thành công]
                                      → AsyncError(AppEx)      [thất bại]

logout()    → signOut() → state = AsyncData(null)              [manual set]
```

**Giải thích:** `AsyncValue` là sealed class với 3 trạng thái. UI đăng ký watch provider — mỗi khi state thay đổi, widget rebuild tự động. `AsyncValue.guard()` wrap try-catch: nếu future throw, guard convert thành `AsyncError` kèm `StackTrace` đầy đủ.

---

### G1. Ba Loại Controller

| Loại                 | Khi nào dùng                                                                | Ví dụ                                                          |
| -------------------- | --------------------------------------------------------------------------- | -------------------------------------------------------------- |
| `AsyncNotifier<T>`   | State cần fetch async (API call, storage read) khi build. Có async actions. | `LoginController<User?>` — phải check token ngay khi khởi động |
| `Notifier<T>`        | State synchronous, không cần async trong build. Có actions.                 | Counter, filter, selection state                               |
| `@riverpod` function | State đơn giản, không có action method. Chỉ compute/provide.                | `authStateProvider` — just returns a Future                    |

---

### G2. `build()` Method: Session Restore

`LoginController.build()` không return hardcoded value mà `watch` `authStateProvider.future`:

```
build() → ref.watch(authStateProvider.future)
         → authService.getCurrentUser()
         → tokenStorage.getAccessToken()
         → null? return null (chưa login)
         → token? dio.get('/users/me') → return User
```

**Quan trọng:** Vì dùng `ref.watch` (không phải `ref.read`), nếu `authStateProvider` được `invalidate()` sau này (ví dụ: force refresh session), `LoginController` tự động rebuild state. Đây là reactive dependency — build() không phải chạy một lần, nó là declaration của dependency.

---

### G3. AsyncValue.guard vs try/catch Thủ công

`AsyncValue.guard(() => future)` thực hiện chính xác:

```
try {
  state = AsyncData(await future());
} catch (e, st) {
  state = AsyncError(e, st);  // ← giữ StackTrace
}
```

Ưu điểm so với tự viết try/catch:

- **Giữ StackTrace:** `AsyncError` cần `stackTrace` param. Tự viết catch thường quên `st`.
- **Đồng nhất pattern:** Mọi controller trong project dùng cùng một pattern — dễ đọc.
- **Compile-time:** Nếu future signature thay đổi, compiler báo lỗi ngay.

---

### G4. ref.watch vs ref.listen

| Aspect               | `ref.watch`                    | `ref.listen`                 |
| -------------------- | ------------------------------ | ---------------------------- |
| Mục đích             | Đọc value và subscribe rebuild | Subscribe side effect        |
| Rebuild widget       | Có — mỗi khi value đổi         | Không                        |
| Dùng trong           | `build()` method               | Bất kỳ đâu trong widget      |
| Use case             | Hiển thị data, derived state   | Navigate, show SnackBar, log |
| Khi nào gọi callback | —                              | Mỗi khi value đổi            |

**Quy tắc:** Nếu cần hiển thị → `ref.watch`. Nếu cần làm điều gì đó (side effect) → `ref.listen`.

---

### G5. AsyncValueWidget: Tái sử dụng UI Pattern

Bất kỳ màn hình nào cần hiển thị data async đều có cùng 3 case: loading spinner, error message, data widget. `AsyncValueWidget<T>` encapsulate pattern này:

- `loading:` → `CircularProgressIndicator` ở giữa màn hình
- `error:` → `ErrorMessageWidget` với error.toString()
- `data:` → widget builder nhận `T`, caller quyết định render gì

**Khi nào dùng `AsyncValueWidget` vs `ref.listen`:** Xem F3.

---

## H. Navigation: GoRouter + RouterNotifier

### H1. Tại sao GoRouter?

**Bước 1 — Ba kịch bản mà Navigator 1.0 không xử lý được:**

*Kịch bản 1 — Bottom tab navigation:*

```
App có 2 tab: Home và Settings
User ở Home → vào Detail → chuyển sang Settings → bấm Back

Navigator 1.0: back button về đâu?
    Stack toàn cục: [Home, Detail, Settings]
    Bấm Back → về Detail (màn hình của tab khác!)  ← không đúng  ❌

GoRouter StatefulShellRoute: mỗi tab có stack riêng
    Tab Home stack:     [Home, Detail]
    Tab Settings stack: [Settings]
    Bấm Back ở Settings → không có gì để back (đúng hành vi)     ✅
```

*Kịch bản 2 — Auth guard:*

```
User chưa đăng nhập, navigate đến '/home'

Navigator 1.0: phải tự thêm check vào từng screen
    class HomeScreen extends StatefulWidget {
      void initState() {
        if (!isLoggedIn) Navigator.pushReplacement(context, '/login');
      }
      // Phải làm thủ công cho MỖI screen cần bảo vệ  ❌
    }

GoRouter redirect: 1 chỗ duy nhất kiểm tra tất cả
    redirect: (context, state) {
      if (!isLoggedIn && state.uri.path != '/login') return '/login';
      return null;  // cho phép navigate bình thường
    }  ✅
```

*Kịch bản 3 — Deep link từ push notification:*

```
User nhận notification: "Bạn có tin nhắn mới"
App bị đóng → user tap notification → app mở ra

Navigator 1.0: phải tự parse URL trong main() và navigate thủ công
    → Phải biết app đang ở state nào, phải build đúng stack  ❌

GoRouter: tự động route đến đúng screen từ URL
    sleepbuddy://messages/123 → GoRouter tự điều hướng đến
    MessageDetailScreen(id: '123') mà không cần code thêm    ✅
```

---

**Bước 2 — So sánh các lựa chọn:**

| Aspect                         | Navigator 1.0 (`Navigator.push`) | Navigator 2.0 (Router API) | GoRouter                      |
| ------------------------------ | -------------------------------- | -------------------------- | ----------------------------- |
| Deep linking                   | Phức tạp, manual                 | Có, nhưng boilerplate cao  | Built-in, URL-based           |
| Nested navigation (bottom tab) | Tự quản lý stack                 | Tự implement               | `StatefulShellRoute` built-in |
| Auth redirect                  | Interceptor thủ công             | Router delegate phức tạp   | `redirect` callback đơn giản  |
| Back button (Web/Android)      | Không kiểm soát tốt              | Manual                     | Tự động                       |
| Boilerplate                    | Ít                               | Rất nhiều                  | Ít                            |

---

**Bước 3 — Lý do chọn GoRouter:**

Dự án có đúng 3 nhu cầu: (1) bottom navigation với nested stacks riêng biệt cho mỗi tab, (2) auth guard chặn user chưa đăng nhập truy cập màn hình protected, (3) deep link từ push notification mở thẳng vào đúng màn hình. Navigator 1.0 không xử lý được nhu cầu 1 mà không tự quản lý stack phức tạp. Navigator 2.0 (Router API thô) xử lý được cả ba nhưng boilerplate cực kỳ nhiều. GoRouter là wrapper trên Navigator 2.0 — giải quyết cả ba nhu cầu với `StatefulShellRoute` (tab stack), `redirect` callback (auth guard), và URL-based routing (deep link) — với code tối thiểu.

---

### Diagram H.1: Route Tree

```
GoRouter
    │  initialLocation: '/'
    │  navigatorKey: _rootNavigatorKey
    │
    ├── GoRoute path: '/login'
    │   navigatorKey: _rootNavigatorKey (fullscreen, ngoài bottom nav)
    │   builder: LoginScreen
    │
    └── StatefulShellRoute.indexedStack
            builder: ScaffoldWithNestedNavigation (Scaffold + BottomNavigationBar)
            │
            ├── StatefulShellBranch [index=0]
            │   navigatorKey: _shellNavigatorHomeKey
            │   └── GoRoute path: '/'
            │       name: AppRoute.home
            │       pageBuilder: HomeScreen (NoTransitionPage)
            │       └── GoRoute path: 'details'    (→ '/details')
            │           builder: DetailScreen
            │
            └── StatefulShellBranch [index=1]
                navigatorKey: _shellNavigatorSettingKey
                └── GoRoute path: '/settings'
                    name: AppRoute.settings
                    pageBuilder: SettingScreen (NoTransitionPage)
                    └── GoRoute path: 'details'    (→ '/settings/details')
                        builder: SettingDetailScreen

AppRoute enum: { home, settings, login }
  → Dùng context.goNamed(AppRoute.home.name) thay vì hardcode string path
```

**Giải thích:** `/login` nằm ngoài `StatefulShellRoute` vì login không có bottom nav. `StatefulShellRoute` duy trì navigation state của từng branch — khi chuyển tab, stack của tab kia được giữ nguyên (không reset). `NoTransitionPage` cho tab root để tránh animation khi switch tab.

---

### Diagram H.2: RouterNotifier Bridge — Riverpod → GoRouter

```
[Riverpod World]                          [GoRouter World]

loginControllerProvider
    │  state thay đổi
    │  (login / logout / startup)
    ▼
RouterNotifier
    │  constructor: ref.listen(
    │    loginControllerProvider,
    │    (prev, next) => notifyListeners()
    │  )
    │
    │  notifyListeners()  ←── mỗi khi loginController đổi
    ▼
ChangeNotifier
    │  notifyListeners() trigger tất cả listener
    ▼
GoRouter.refreshListenable = routerNotifierProvider
    │  GoRouter subscribe vào RouterNotifier
    │  Khi nhận notify → re-evaluate redirect callback
    ▼
redirect: (context, state) {
    final authState = ref.read(loginControllerProvider)

    if authState.isLoading → '/login'                  [case 1: đang check token, tạm giữ ở login]
    if AsyncData(null) || AsyncError → '/login'        [case 2: chưa đăng nhập / lỗi session]
      (AsyncData(null): chưa login. AsyncError: network fail khi restore — cả hai redirect login)
    if AsyncData(User) && path == '/login' → '/'       [case 3: đã đăng nhập, rời login]
    else → null (không redirect)                       [case 4: để yên]
}
```

**Giải thích:** `RouterNotifier` là cầu nối vì GoRouter là imperative API (`ChangeNotifier`) trong khi Riverpod là reactive API. Bridge pattern này chuyển từ Riverpod's reactivity (`ref.listen`) sang GoRouter's reactivity (`ChangeNotifier`). GoRouter không thể watch Riverpod provider trực tiếp.

---

### H2. Bảng 4 Redirect Cases

| State của loginController           | Đang ở path         | GoRouter action         | Lý do                                             |
| ----------------------------------- | ------------------- | ----------------------- | ------------------------------------------------- |
| `AsyncLoading`                      | Bất kỳ              | Redirect `/login`       | App mới mở, đang kiểm tra token — tạm giữ ở login |
| `AsyncData(null)` hoặc `AsyncError` | Không phải `/login` | Redirect `/login`       | Chưa đăng nhập hoặc lỗi session                   |
| `AsyncData(User)`                   | `/login`            | Redirect `/`            | Đã đăng nhập, không cần ở login                   |
| `AsyncData(User)`                   | Không phải `/login` | `null` (không redirect) | Để user ở màn hình hiện tại                       |

---

### H3. ScaffoldWithNestedNavigation — Giải phẫu Widget Bottom Navigation

#### H3.1 Tại sao Không Dùng Scaffold + BottomNavigationBar Thông thường?

Trước khi GoRouter có `StatefulShellRoute`, cách phổ biến là dùng `Scaffold` + `BottomNavigationBar` + `IndexedStack` tự quản lý. Vấn đề: navigation stack của từng tab phải được viết tay — switch tab là reset stack hoặc phải tự lưu/restore state phức tạp.

`StatefulShellRoute.indexedStack` của GoRouter giải quyết vấn đề đó — GoRouter **tự động** duy trì navigation stack riêng cho từng branch (tab). `ScaffoldWithNestedNavigation` là wrapper UI mỏng — nó chỉ render `Scaffold` + `BottomNavigationBar` và delegate hoàn toàn navigation logic cho GoRouter qua `StatefulNavigationShell`.

---

#### H3.2 Các Thành phần và Vai trò

```
┌──────────────────────────────────────────────────────────────────┐
│                    ScaffoldWithNestedNavigation                  │
│                   (Widget — file: scaffold_with_nested_nav.dart) │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │                   Scaffold                                 │  │
│  │                                                            │  │
│  │  body:                                                     │  │
│  │  ┌──────────────────────────────────────────────────────┐  │  │
│  │  │             StatefulNavigationShell                  │  │  │
│  │  │   (GoRouter object — được GoRouter tạo & truyền vào) │  │  │
│  │  │                                                      │  │  │
│  │  │   IndexedStack (bên trong GoRouter, ẩn)              │  │  │
│  │  │   ┌──────────────────┬──────────────────┐            │  │  │
│  │  │   │  Branch 0 (Home) │ Branch 1(Setting)│            │  │  │
│  │  │   │  Navigator Stack │ Navigator Stack  │            │  │  │
│  │  │   │  [HomeScreen]    │ [SettingScreen]  │            │  │  │
│  │  │   │  [DetailScreen]  │                  │            │  │  │
│  │  │   │  ← visible       │ ← hidden (alive) │            │  │  │
│  │  │   └──────────────────┴──────────────────┘            │  │  │
│  │  └──────────────────────────────────────────────────────┘  │  │
│  │                                                            │  │
│  │  bottomNavigationBar:                                      │  │
│  │  ┌──────────────────────────────────────────────────────┐  │  │
│  │  │  BottomNavigationBar                                 │  │  │
│  │  │  currentIndex: navigationShell.currentIndex          │  │  │
│  │  │  onTap: (i) => _goBranch(i)                         │  │  │
│  │  │  [🏠 Home]  [⚙️ Settings]                            │  │  │
│  │  └──────────────────────────────────────────────────────┘  │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

| Thành phần                     | Loại                     | Vai trò                                                           |
| ------------------------------ | ------------------------ | ----------------------------------------------------------------- |
| `ScaffoldWithNestedNavigation` | Widget (do project viết) | Shell UI: chứa Scaffold + kết nối GoRouter                        |
| `StatefulNavigationShell`      | GoRouter object          | Quản lý branch switching, cung cấp `currentIndex` và `goBranch()` |
| `IndexedStack`                 | GoRouter internal        | Giữ tất cả branch alive trong memory, chỉ hiện một cái            |
| `BottomNavigationBar`          | Flutter widget           | Render các tab, highlight tab active, nhận tap event              |
| `StatefulShellBranch`          | GoRouter config          | Khai báo một tab: navigator key + routes của tab đó               |

---

#### H3.3 StatefulShellRoute.indexedStack — Cơ chế Giữ State Từng Tab

**Vấn đề cần giải quyết:** User đang ở `/details` trong tab Home, chuyển sang Settings, rồi quay lại Home. Tab Home phải vẫn ở `/details`, không reset về `/`.

**`indexedStack` hoạt động như thế nào:**

```
Lần đầu app mở — GoRouter tạo TẤT CẢ branch ngay lập tức:

Memory:
┌─────────────────────────────────────────────────────────┐
│  Branch 0 (Home Navigator)   │  Branch 1 (Settings Nav) │
│  Stack: [HomeScreen]         │  Stack: [SettingScreen]  │
│  Status: VISIBLE             │  Status: HIDDEN (alive)  │
└─────────────────────────────────────────────────────────┘

User navigate từ HomeScreen → DetailScreen:
┌─────────────────────────────────────────────────────────┐
│  Branch 0 (Home Navigator)   │  Branch 1 (Settings Nav) │
│  Stack: [HomeScreen,         │  Stack: [SettingScreen]  │
│          DetailScreen]       │                          │
│  Status: VISIBLE             │  Status: HIDDEN (alive)  │
└─────────────────────────────────────────────────────────┘

User tap Settings tab:
┌─────────────────────────────────────────────────────────┐
│  Branch 0 (Home Navigator)   │  Branch 1 (Settings Nav) │
│  Stack: [HomeScreen,         │  Stack: [SettingScreen]  │
│          DetailScreen]       │                          │
│  Status: HIDDEN (alive) ←─── │ ──→ Status: VISIBLE      │
└─────────────────────────────────────────────────────────┘
         Stack KHÔNG bị xóa!

User tap Home tab lại:
┌─────────────────────────────────────────────────────────┐
│  Branch 0 (Home Navigator)   │  Branch 1 (Settings Nav) │
│  Stack: [HomeScreen,         │  Stack: [SettingScreen]  │
│          DetailScreen]       │                          │
│  Status: VISIBLE ←───────────│ ──→ Status: HIDDEN       │
└─────────────────────────────────────────────────────────┘
         DetailScreen vẫn còn trong stack → user thấy DetailScreen
```

**Lý do gọi là "indexedStack":** `IndexedStack` là Flutter widget nhận list children và chỉ hiển thị child tại `index` được chỉ định. Tất cả child vẫn tồn tại trong widget tree (và do đó trong memory), nhưng chỉ một child visible. GoRouter dùng chính cơ chế này để giữ navigator state của từng branch.

**So sánh với cách không có StatefulShellRoute:**

| Cách                                         | Hành vi khi switch tab                            | Stack bị giữ? |
| -------------------------------------------- | ------------------------------------------------- | ------------- |
| `IndexedStack` (StatefulShellRoute)          | Chuyển tab, stack cũ vẫn sống                     | ✅ Có         |
| `Navigator.push` thủ công                    | Rebuild màn hình khi switch                       | ❌ Không      |
| `PageView` + `AutomaticKeepAliveClientMixin` | Giữ state widget nhưng không giữ navigation stack | ⚠️ Một phần   |

---

#### H3.4 StatefulNavigationShell — Cầu nối GoRouter ↔ Widget

`StatefulNavigationShell` là object GoRouter tạo ra và **tiêm vào** builder function của `StatefulShellRoute`. Widget `ScaffoldWithNestedNavigation` nhận object này qua parameter:

```
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    // GoRouter tạo navigationShell và truyền vào đây
    return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
  },
  branches: [...]
)
```

`StatefulNavigationShell` cung cấp 2 thứ widget cần:

| Property/Method                        | Kiểu   | Dùng để                                                       |
| -------------------------------------- | ------ | ------------------------------------------------------------- |
| `navigationShell.currentIndex`         | `int`  | Biết tab nào đang active → `BottomNavigationBar.currentIndex` |
| `navigationShell.goBranch(index, ...)` | `void` | Ra lệnh cho GoRouter chuyển sang branch khác                  |

Widget không cần biết URL, không cần biết route structure. Nó chỉ đọc `currentIndex` và gọi `goBranch()` — GoRouter làm phần còn lại.

---

#### H3.5 Thuật toán `_goBranch(index)` — Double-tap Reset

```
_goBranch(int index):
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex
    )

Trường hợp 1: User tap TAB KHÁC (ví dụ: đang ở Home, tap Settings)
  index = 1, currentIndex = 0
  initialLocation = (1 == 0) = FALSE
  → goBranch(1, initialLocation: false)
  → GoRouter: switch sang Branch 1, GIỮ NGUYÊN location đang có của Branch 1
  → Nếu Branch 1 đang ở '/settings/details' → user thấy '/settings/details'

Trường hợp 2: User tap ĐÚNG TAB ĐANG ACTIVE (double-tap)
  index = 0, currentIndex = 0
  initialLocation = (0 == 0) = TRUE
  → goBranch(0, initialLocation: true)
  → GoRouter: navigate về ROOT LOCATION của Branch 0 (tức là '/')
  → User đang ở '/details' → nhảy về HomeScreen
  → Hành vi iOS/Android thông thường: double-tap tab = scroll-to-top hoặc pop-to-root
```

**Tại sao `initialLocation: true` = "về root"?**

`goBranch(index, initialLocation: true)` ra lệnh GoRouter "đi đến branch đó, nhưng dùng `initialLocation` — tức là route đầu tiên được khai báo trong branch". Với Branch 0, `initialLocation` là `/` (HomeScreen). Với Branch 1, là `/settings` (SettingScreen).

---

#### Diagram H.3: ScaffoldWithNestedNavigation — Luồng Tap → Render

```
User tap Tab [Settings]                    User tap Tab [Home] (đang active)
        │                                             │
        ▼                                             ▼
BottomNavigationBar.onTap(1)             BottomNavigationBar.onTap(0)
        │                                             │
        ▼                                             ▼
_goBranch(1)                             _goBranch(0)
  index=1                                  index=0
  currentIndex=0                           currentIndex=0
  initialLocation=(1==0)=FALSE             initialLocation=(0==0)=TRUE
        │                                             │
        ▼                                             ▼
navigationShell.goBranch(                navigationShell.goBranch(
  1, initialLocation: false)               0, initialLocation: true)
        │                                             │
        ▼                                             ▼
GoRouter: switch IndexedStack            GoRouter: navigate Branch 0
  Branch 1 → VISIBLE                       về initialLocation = '/'
  Branch 0 → HIDDEN (stack intact)                   │
        │                                             ▼
        ▼                                   Stack Branch 0 reset
BottomNavigationBar rebuild:               [HomeScreen]  ← chỉ còn root
  currentIndex = 1 (Settings highlighted)             │
        │                                             ▼
        ▼                                   BottomNavigationBar rebuild:
User thấy màn hình Settings                  currentIndex = 0 (Home highlighted)
(đúng màn hình khi rời đi lần trước)
```

---

#### H3.6 NoTransitionPage — Tại sao Tab Root Không Có Animation?

Khi khai báo route root của branch, project dùng `pageBuilder` với `NoTransitionPage` thay vì `builder` thông thường:

```
Với builder thông thường:
  Switch Tab Home → Settings: slide animation (như push screen)
  → Cảm giác như "đi sâu vào màn hình" — sai UX cho tab

Với NoTransitionPage:
  Switch Tab Home → Settings: ngay lập tức, không animation
  → Cảm giác "đổi chỗ đứng" — đúng UX cho tab
```

**Quy tắc:** Tab root (`/`, `/settings`) dùng `NoTransitionPage`. Child screen trong tab (`/details`, `/settings/details`) dùng `builder` thường → có slide animation khi push/pop — đây là animation đúng cho "đi sâu trong một tab".

---

#### H3.7 BottomNavigationBar vs NavigationBar

Project hiện dùng `BottomNavigationBar` (Material 2). Flutter cũng có `NavigationBar` (Material 3) với style khác. Cả hai đều work với cơ chế `goBranch` trên. Chọn cái nào là quyết định design — logic navigation không thay đổi.

---

### H4. GlobalKey Phân tách: Tại sao Cần 3 Keys

GoRouter dùng `NavigatorKey` để biết "Navigator nào" đang hiển thị màn hình này:

- `_rootNavigatorKey`: Navigator toàn cục — push màn hình này hiển thị fullscreen, đè lên cả bottom nav (dùng cho `/login`, modal)
- `_shellNavigatorHomeKey`: Navigator trong Home branch — push màn hình này chỉ hiển thị trong Home tab, bottom nav vẫn visible
- `_shellNavigatorSettingKey`: Navigator trong Settings branch — tương tự

Nếu dùng cùng một key cho hai navigator, Flutter không biết phân biệt stack của từng tab, gây lỗi navigation không dự đoán được.

---

## I. Authentication Flow End-to-End

_Phần này tổng hợp các luồng hoàn chỉnh. Chi tiết cơ chế đã giải thích ở các phần B, C, D, E, G, H — không lặp lại._

### Diagram I.1: Cold Start Full Flow

```
Thiết bị mở app lần đầu sau khi install hoặc sau khi bị kill

runApp(ProviderScope(...))
    │
    ▼ [xem Diagram C.3 — Startup Initialization Chain]
goRouterProvider khởi tạo
    │
    ▼ loginControllerProvider.build()
state = AsyncLoading  ← ngay lập tức
GoRouter redirect: isLoading → '/login' (hiển thị LoginScreen tạm)
    │
    ▼ authStateProvider evaluate (background)
tokenStorage.getAccessToken()
    │
    ├── [Không có token — user chưa từng login]
    │   authState returns null
    │   loginController.state = AsyncData(null)
    │   routerNotifier.notifyListeners()
    │   GoRouter re-evaluate redirect: !isLoggedIn → '/login'
    │   → Hiển thị LoginScreen (user phải login)
    │
    └── [Có token — user đã từng login]
        dio.get('/users/me') [xem Diagram D.1 — Interceptor Pipeline]
        AuthInterceptor gắn Bearer token
        │
        ├── [200 OK — token còn hiệu lực]
        │   return UserModel → toEntity() → User
        │   loginController.state = AsyncData(user)
        │   routerNotifier.notifyListeners()
        │   GoRouter re-evaluate: isLoggedIn && path=='/login' → '/'
        │   → Navigate HomeScreen (Auto login)
        │
        └── [401 — token hết hạn]
            AuthInterceptor: refresh token [xem Diagram D.3/D.4]
            │
            ├── [Refresh thành công] → retry /users/me → User
            │   loginController.state = AsyncData(user)
            │   → Navigate HomeScreen
            │
            └── [Refresh thất bại] → logout [xem Diagram D.5]
                loginController.state = AsyncData(null)
                → Hiển thị LoginScreen
```

---

### Diagram I.2: Login Full Flow

```
User nhập email + password → tap button Đăng nhập
    │
    ▼ LoginScreen._onLoginPressed()
Form.validate() [email format, password ≥ 6 chars]
    │
    ▼ ref.read(loginControllerProvider.notifier).login(email, password)
    │
    ▼ LoginController.login()
state = AsyncLoading()
    │  → LoginScreen rebuild: button disabled + spinner
    │
    ▼ AsyncValue.guard(() => authService.signIn(email, password))
    │
    ▼ AuthService.signIn() → repository.login(email, password)
    │
    ▼ AuthRepositoryImpl.login()
authRemoteDatasource.login() → dio.post('/api/signin')
    │  [Interceptor Pipeline: Log → Auth attach header (nếu có) → gửi]
    │
    ├── [400/401/403/404/500] → DioException
    │   _handleDioError() → AppException
    │   bubble up → AsyncValue.guard catch
    │   state = AsyncError(InvalidCredentialsException, stackTrace)
    │   routerNotifier.notifyListeners()
    │   LoginScreen ref.listen callback:
    │   → ScaffoldMessenger.showSnackBar("Email hoặc mật khẩu không đúng")
    │   (User vẫn ở LoginScreen, có thể thử lại)
    │
    └── [200 OK] → LoginResponseModel
        tokenStorage.saveTokens(accessToken, refreshToken)
        response.user.toEntity() → User
        state = AsyncData(user)
        routerNotifier.notifyListeners()
        GoRouter re-evaluate redirect: isLoggedIn && path=='/login' → '/'
        → Navigate HomeScreen
```

---

### I1. API Call Thông thường

Mọi API call sau khi đã login đều đi qua pipeline Diagram 6. AuthInterceptor tự động gắn Bearer token — code tầng trên không cần biết token logic.

---

### I2. Token Expired (Concurrent 401)

Xem chi tiết tại Diagram 8 (đơn) và Diagram 9 (đồng thời). Summary: Completer lock đảm bảo chỉ 1 refresh call dù có bao nhiêu request bị 401 cùng lúc.

---

### Diagram I.3: Logout Flow

```
User tap button Đăng xuất
    │
    ▼ ref.read(loginControllerProvider.notifier).logout()
    │
    ▼ LoginController.logout()
ref.read(authServiceProvider).signOut()
    │
    ▼ AuthService.signOut() → repository.logout()
    │
    ▼ AuthRepositoryImpl.logout()
try:
    authRemoteDatasource.logout() → dio.post('/api/logout')
    [Báo server revoke token — best effort, không block logout nếu fail]
catch: { } ignore
    │
finally: (luôn chạy dù API thành công hay fail)
    tokenStorage.clear() → storage.deleteAll()
    ┌──────────────────────────────┐
    │  Keychain/Keystore trống     │
    │  Không còn access/refresh   │
    └──────────────────────────────┘
    │
    ▼ Back to LoginController.logout()
state = AsyncData(null)  ← manual set, không cần async
    │
    ▼ routerNotifier.notifyListeners() (triggered by state change)
    │
    ▼ GoRouter re-evaluate redirect
!isLoggedIn && path != '/login' → '/login'
    │
    ▼ Navigate LoginScreen
    [Navigation stack bị clear — user không thể back về Home]
```

**Giải thích logout:** `try/catch/finally` pattern đảm bảo token luôn được xóa ngay cả khi `/api/logout` fail (network timeout, server down). Đây là UX tốt: user không bị "mắc kẹt" vì server không phản hồi.

---

## J. Code Generation Workflow

### J1. Tại sao Cần Code Generation?

> Xem **C2.1** để hiểu chi tiết ba vấn đề boilerplate, hậu quả khi viết tay, và so sánh trước/sau code gen.

**Quick reference — 3 tool và vấn đề chúng giải quyết:**

| Tool | Vấn đề khi viết tay | Output |
| ---- | ------------------- | ------ |
| `freezed` | `copyWith`, `==`, `hashCode` phải viết tay, dễ quên khi thêm field | `.freezed.dart` |
| `json_serializable` | `fromJson`/`toJson` dễ quên field hoặc sai kiểu | `.g.dart` |
| `riverpod_generator` | Provider type, generic, `autoDispose` dễ khai báo sai | `.g.dart` |

---

### J2. freezed: Immutable Data Classes

> Xem **C2.5** để hiểu chi tiết freezed, vấn đề `==` so sánh địa chỉ RAM, `copyWith`, `const factory`, và private class `_User`.

**Quick reference:**
- Annotation: `@freezed` trên class
- Output file: `.freezed.dart`
- Sinh ra: `==`, `hashCode`, `toString()`, `copyWith()`, mixin `_$ClassName`, private class `_ClassName`
- Chạy sau khi thêm/sửa: `dart run build_runner build`

**Lưu ý quan trọng — freezed vs sealed:**
- Entity dùng `@freezed` cho immutability (User, TokenEntity...)
- `AppException` dùng Dart `sealed class` — **không dùng freezed** vì sealed class cần behavior (method) riêng từng subclass, không phải data immutability

---

### J3. json_serializable: JSON Mapping

> Xem **C2.4** để hiểu chi tiết hai hàm được sinh ra (`_$UserModelFromJson`, `_$UserModelToJson`) và tại sao thiếu `@JsonKey` gây field null lúc runtime.

**Quick reference:**
- Annotation: `@freezed` kết hợp với `json_serializable` + `part 'xxx.g.dart'`
- Output file: `.g.dart`
- Sinh ra: `_$XxxFromJson(Map<String, dynamic>)` và `_$XxxToJson(_Xxx instance)`

**@JsonKey quick lookup — mismatch API snake_case vs Dart camelCase:**

| API JSON              | Dart field            | Annotation                        |
| --------------------- | --------------------- | --------------------------------- |
| `access_token`        | `accessToken`         | `@JsonKey(name: 'access_token')`  |
| `refresh_token`       | `refreshToken`        | `@JsonKey(name: 'refresh_token')` |
| `id`, `name`, `email` | `id`, `name`, `email` | Không cần (match nhau)            |

---

### J4. riverpod_generator: Provider Registration

> Xem **C2.3** để hiểu chi tiết 3 thứ được sinh ra (Provider class, const instance, hash string) và trường hợp đặc biệt của AsyncNotifier (`_$LoginController`).

**Quick reference:**
- `@riverpod` trên function `foo(Ref ref)` → sinh `fooProvider` (auto-dispose)
- `@Riverpod(keepAlive: true)` trên function → sinh `fooProvider` (persistent)
- `@riverpod` trên class `Foo extends _$Foo` → sinh `fooProvider` và abstract class `_$Foo`
- Output file: `.g.dart`

---

### J5. build_runner: Khi nào Chạy

| Lệnh                                                       | Mục đích                                                             |
| ---------------------------------------------------------- | -------------------------------------------------------------------- |
| `dart run build_runner build`                              | Chạy một lần, tạo/cập nhật tất cả `.g.dart` và `.freezed.dart`       |
| `dart run build_runner watch`                              | Chạy liên tục, tự động rebuild khi file thay đổi (dùng khi đang dev) |
| `dart run build_runner build --delete-conflicting-outputs` | Xóa output cũ trước khi tạo mới — dùng khi có conflict               |

**Khi nào phải chạy build_runner:**

- Thêm model mới (cần `.freezed.dart` + `.g.dart`)
- Thêm provider mới (cần `.g.dart`)
- Thêm/sửa entity dùng freezed
- Đổi `@JsonKey(name:)` trên field nào đó
- Đổi tên function/class có annotation `@riverpod`

---

### J6. Quy tắc Vàng

**KHÔNG BAO GIỜ sửa tay file `.g.dart` hoặc `.freezed.dart`.** Những file này được overwrite mỗi lần chạy `build_runner`. Mọi thay đổi sẽ bị mất. Sửa ở file nguồn (`.dart` không có extension đặc biệt), rồi chạy lại `build_runner`.

---

## K. Shared UI Layer

### K1. Design Tokens

**Sizes (`app_sizes.dart`):**

`Sizes` class định nghĩa hệ thống spacing consistent:

| Token       | Value | Dùng cho                             |
| ----------- | ----- | ------------------------------------ |
| `Sizes.p4`  | 4.0   | Micro spacing (icon padding)         |
| `Sizes.p8`  | 8.0   | Tight spacing (giữa các element nhỏ) |
| `Sizes.p12` | 12.0  | Small spacing                        |
| `Sizes.p16` | 16.0  | Standard padding                     |
| `Sizes.p20` | 20.0  | Medium spacing                       |
| `Sizes.p24` | 24.0  | Section padding                      |
| `Sizes.p32` | 32.0  | Large spacing                        |
| `Sizes.p48` | 48.0  | Button height, large gap             |
| `Sizes.p64` | 64.0  | Hero element spacing                 |

Ngoài ra có helper constants `gapW4`...`gapW64` (SizedBox width) và `gapH4`...`gapH64` (SizedBox height) để dùng inline trong Column/Row.

**Breakpoints (`breakpoints.dart`):**

| Breakpoint           | Value | Mô tả              |
| -------------------- | ----- | ------------------ |
| `Breakpoint.tablet`  | 600   | Tablet và lớn hơn  |
| `Breakpoint.desktop` | 900   | Desktop và lớn hơn |

Dùng với `MediaQuery.of(context).size.width` để điều chỉnh layout responsive.

---

### K2. PrimaryButton và AsyncValueWidget

**PrimaryButton:**

- ElevatedButton chuẩn hóa với `height: Sizes.p48`
- `isLoading: true` → hiển thị `CircularProgressIndicator` thay cho text
- `onPressed: null` khi loading → button tự động disabled (Flutter tự handle style grayed-out)
- Dùng cho tất cả CTA (Call-to-Action) button trong app

**AsyncValueWidget:**

- Generic widget `AsyncValueWidget<T>` nhận `AsyncValue<T>` và `Widget Function(T) data`
- Loading → `CircularProgressIndicator` centered
- Error → `ErrorMessageWidget` với `error.toString()`
- Data → builder function trả về widget tùy theo T

---

### Diagram K.1: AsyncValueWidget Flow

```
ref.watch(someProvider)  →  AsyncValue<T>
                                   │
                    ┌──────────────┼──────────────┐
                    │              │              │
                    ▼              ▼              ▼
             AsyncLoading    AsyncError      AsyncData(T)
                    │              │              │
                    ▼              ▼              ▼
            CircularProgress  ErrorMessage   data(T) builder
            Indicator()       Widget(        → caller quyết định
            (centered)        error          render gì với T
                              .toString())
```

**Dùng `AsyncValueWidget` khi:** Màn hình hiển thị danh sách sản phẩm, user profile, bất kỳ data nào cần fetch từ API và render inline trong layout.

**Không dùng `AsyncValueWidget` khi:** Lỗi cần trigger navigate hoặc show SnackBar → dùng `ref.listen` (xem F3).

---

### K3. Quy tắc Phân loại Widget

| Widget                                | Đặt ở đâu                                  | Lý do                           |
| ------------------------------------- | ------------------------------------------ | ------------------------------- |
| Dùng ở ≥ 2 features                   | `lib/src/common/`                          | Shared, không thuộc feature nào |
| Chỉ dùng ở 1 feature                  | `lib/src/features/<feature>/presentation/` | Feature-local                   |
| Dùng ở tất cả screen (layout wrapper) | `lib/src/utils/`                           | Infrastructure level            |

**Ví dụ đúng:** `PrimaryButton` dùng ở cả `LoginScreen` và tương lai `RegisterScreen` → `common/`. `DetailScreen` chỉ dùng ở home feature → `features/home/presentation/`.

---

## PHẦN 4 — REFERENCE & GUIDES

---

## L. Bản đồ Dependency Hoàn chỉnh

### Diagram L.1: Full Dependency Map (Tất cả File & Provider)

```
app.dart (MyApp)
    └── goRouterProvider  [app_router.dart] (keepAlive)
            │
            ├── routerNotifierProvider  [router_notifier.dart] (keepAlive)
            │       └── loginControllerProvider  (keepAlive)
            │               │   [login_controller.dart]
            │               └── authStateProvider  (auto-dispose)
            │                       │   [auth_service.dart]
            │                       └── authServiceProvider  (auto-dispose)
            │                               └── authRepositoryProvider (auto-dispose)
            │                                       [auth_repository_impl.dart]
            │
            └── loginControllerProvider  (same, keepAlive)
                    (ref.read — không phải dependency tree nhưng cần để redirect)

authRepositoryProvider
    ├── authRemoteDatasourceProvider  (auto-dispose)
    │       [auth_remote_datasource.dart]
    │       └── dioProvider  (keepAlive)
    │               [core_providers.dart]
    │               ├── AppEnvironment.baseUrl
    │               ├── AppLogInterceptor  [log_interceptor.dart]
    │               └── AuthInterceptor  [auth_interceptor.dart]
    │                       └── tokenStorageProvider  (keepAlive)
    │                               [core_providers.dart]
    │                               └── FlutterSecureStorage
    │
    └── tokenStorageProvider  (keepAlive)
            (same instance — Riverpod deduplicate)

Routing:
    ScaffoldWithNestedNavigation  [scaffold_with_nested_navigation.dart]
        └── StatefulNavigationShell  (từ GoRouter)

Domain (không có provider — pure Dart):
    AuthRepository (interface)  [auth_repository.dart]
    User (entity)  [user.dart] → user.freezed.dart

Data Models (không có provider — chỉ data classes):
    UserModel  [user_model.dart] → user_model.freezed.dart + user_model.g.dart
    LoginResponseModel  [login_response_model.dart] → *.freezed.dart + *.g.dart

Shared (không có provider):
    AppException + subclasses  [app_exception.dart]
    ApiEndpoints  [api_endpoints.dart]
    Sizes, Breakpoint  [app_sizes.dart, breakpoints.dart]
    PrimaryButton, AsyncValueWidget, ...  [common/]
```

---

## PHẦN 5 — APPENDIX

---

## N. Hướng dẫn Mở rộng: Thêm Feature Mới

_Ví dụ: Thêm feature "Product" với màn hình danh sách sản phẩm._

### Checklist 8 Bước

```
Bước 1: Domain Layer — Định nghĩa hợp đồng
├── Tạo lib/src/features/product/domain/entities/product.dart
│   └── @freezed class Product { id, name, price }
├── Tạo lib/src/features/product/domain/repositories/product_repository.dart
│   └── abstract interface class ProductRepository {
│         Future<List<Product>> getProducts();
│       }
└── Chạy: dart run build_runner build
    → Tạo product.freezed.dart

Bước 2: Data Layer — Model & Datasource
├── Tạo lib/src/features/product/data/models/product_model.dart
│   └── @freezed class ProductModel {
│         @JsonKey(name: 'product_name') String name ...
│         Product toEntity() => Product(...)
│       }
├── Tạo lib/src/features/product/data/datasources/product_remote_datasource.dart
│   └── class ProductRemoteDatasource { final Dio _dio; getProducts()... }
│   └── @riverpod ProductRemoteDatasource productRemoteDatasource(Ref ref)
└── Chạy: dart run build_runner build
    → Tạo product_model.freezed.dart, product_model.g.dart
    → Tạo product_remote_datasource.g.dart

Bước 3: Data Layer — Repository Implementation
├── Tạo lib/src/features/product/data/repositories/product_repository_impl.dart
│   └── class ProductRepositoryImpl implements ProductRepository {
│         final ProductRemoteDatasource _datasource;
│         getProducts() → _datasource.getProducts() → model.toEntity()
│         _handleDioError(e) → AppException (giống auth)
│       }
│   └── @riverpod ProductRepository productRepository(Ref ref)
│          => ProductRepositoryImpl(ref.watch(productRemoteDatasourceProvider))
└── Chạy: dart run build_runner build
    → Tạo product_repository_impl.g.dart

Bước 4: Application Layer — Service
├── Tạo lib/src/features/product/application/product_service.dart
│   └── class ProductService { final ProductRepository _repo;
│         Future<List<Product>> getProducts() → _repo.getProducts() }
│   └── @riverpod ProductService productService(Ref ref)
│   └── @riverpod Future<List<Product>> productList(Ref ref)
│          => ref.watch(productServiceProvider).getProducts()
└── Chạy: dart run build_runner build
    → Tạo product_service.g.dart

Bước 5: Presentation Layer — Controller + Screen
├── Tạo lib/src/features/product/presentation/controllers/product_list_controller.dart
│   └── @riverpod class ProductListController extends _$ProductListController
│         build() → ref.watch(productListProvider.future)
├── Tạo lib/src/features/product/presentation/screens/product_list_screen.dart
│   └── ConsumerWidget: ref.watch(productListControllerProvider)
│         → AsyncValueWidget<List<Product>>(value: ..., data: (products) => ...)
└── Chạy: dart run build_runner build
    → Tạo product_list_controller.g.dart

Bước 6: Routing — Thêm Route
├── Mở lib/src/routing/app_router.dart
├── Thêm AppRoute.products vào enum
├── Thêm GoRoute path: '/products' trong StatefulShellBranch
│   (hoặc thêm branch mới nếu cần tab riêng)
└── Chạy: dart run build_runner build
    → Cập nhật app_router.g.dart

Bước 7: API Endpoints — Thêm Constants
├── Mở lib/src/core/api_endpoints.dart
└── Thêm: static const String products = '/api/products';

Bước 8: Kiểm tra Dependency Rule
├── product.dart (domain/entity) → chỉ import freezed_annotation ✓
├── product_repository.dart → chỉ import domain entity ✓
├── product_model.dart → import domain entity (cho toEntity) ✓
├── product_repository_impl.dart → import domain interface + data deps ✓
├── product_service.dart → import domain interface only ✓
├── product_list_controller.dart → import application service only ✓
└── product_list_screen.dart → import controller + Flutter ✓
    KHÔNG có import ngược chiều? ✓ Done
```

---

## O. Quick Reference Tables

### O1. File → Vai trò

| File                                   | Vai trò                                         |
| -------------------------------------- | ----------------------------------------------- |
| `app.dart`                             | Root widget, kết nối GoRouter                   |
| `api_endpoints.dart`                   | Registry path constants                         |
| `app_environment.dart`                 | dev/staging/prod URL                            |
| `app_exception.dart`                   | Sealed exception hierarchy                      |
| `auth_interceptor.dart`                | Token attach + 401 refresh + Completer lock     |
| `log_interceptor.dart`                 | Debug logger (transparent)                      |
| `core_providers.dart`                  | DI root: Dio + TokenStorage                     |
| `token_storage.dart`                   | Wrapper over FlutterSecureStorage               |
| `auth_repository.dart`                 | Domain contract interface                       |
| `auth_repository_impl.dart`            | Interface implementation + DioException mapping |
| `auth_remote_datasource.dart`          | HTTP calls only                                 |
| `user.dart`                            | Domain entity (thuần Dart)                      |
| `user_model.dart`                      | Data model với fromJson + toEntity()            |
| `login_response_model.dart`            | API login response model                        |
| `auth_service.dart`                    | Application layer + authStateProvider           |
| `login_controller.dart`                | AsyncNotifier: session restore + login/logout   |
| `login_screen.dart`                    | UI: form + ref.listen                           |
| `app_router.dart`                      | GoRouter config + redirect                      |
| `router_notifier.dart`                 | Riverpod → GoRouter bridge                      |
| `scaffold_with_nested_navigation.dart` | Bottom nav shell                                |
| `app_sizes.dart`                       | Spacing design tokens                           |
| `breakpoints.dart`                     | Responsive breakpoints                          |
| `async_value_widget.dart`              | Reusable loading/error/data widget              |
| `primary_button.dart`                  | Standard CTA button                             |

---

### O2. Tất cả Provider + keepAlive + Scope

| Provider                       | keepAlive | Scope                 |
| ------------------------------ | --------- | --------------------- |
| `goRouterProvider`             | true      | App-wide singleton    |
| `routerNotifierProvider`       | true      | App-wide singleton    |
| `loginControllerProvider`      | true      | App-wide singleton    |
| `tokenStorageProvider`         | true      | App-wide singleton    |
| `dioProvider`                  | true      | App-wide singleton    |
| `authRepositoryProvider`       | false     | Auto-dispose          |
| `authServiceProvider`          | false     | Auto-dispose          |
| `authRemoteDatasourceProvider` | false     | Auto-dispose          |
| `authStateProvider`            | false     | Auto-dispose (Future) |

---

### O3. HTTP Status → AppException

| Status      | AppException                      | Message                          |
| ----------- | --------------------------------- | -------------------------------- |
| 400         | `NetworkException(serverMessage)` | Message từ server JSON           |
| 401         | `InvalidCredentialsException`     | "Email hoặc mật khẩu không đúng" |
| 403         | `AccountSuspendedException`       | "Tài khoản bị khóa"              |
| 404         | `NotFoundException`               | "Tài khoản không tồn tại"        |
| 500         | `ServerException`                 | "Lỗi server, vui lòng thử lại"   |
| null / khác | `NetworkException(e.message)`     | "Lỗi kết nối mạng"               |

---

### O4. Interceptor Hook → Hành động

| Interceptor         | Hook             | Hành động                                        |
| ------------------- | ---------------- | ------------------------------------------------ |
| `AppLogInterceptor` | `onRequest`      | Print method + URL + headers + body (debug only) |
| `AppLogInterceptor` | `onResponse`     | Print status + URL + data (debug only)           |
| `AppLogInterceptor` | `onError`        | Print status + URL + message (debug only)        |
| `AuthInterceptor`   | `onRequest`      | Read access token → gắn Authorization header     |
| `AuthInterceptor`   | `onError` (401)  | Detect 401 → refresh → retry hoặc logout         |
| `AuthInterceptor`   | `onError` (khác) | Pass-through `handler.next(err)`                 |

---

### O5. Lệnh build_runner Thường dùng

| Lệnh                                                       | Khi nào dùng                                     |
| ---------------------------------------------------------- | ------------------------------------------------ |
| `dart run build_runner build`                              | Sau khi thêm/sửa class có annotation             |
| `dart run build_runner watch`                              | Đang dev — auto rebuild khi save                 |
| `dart run build_runner build --delete-conflicting-outputs` | Khi có lỗi "conflict in existing outputs"        |
| `dart run build_runner clean`                              | Reset cache khi có vấn đề lạ với generated files |

---

### O6. API Endpoints

| Endpoint       | Method | Mục đích                                | Auth required                 |
| -------------- | ------ | --------------------------------------- | ----------------------------- |
| `/api/signin`  | POST   | Đăng nhập — nhận access + refresh token | ❌ Không                      |
| `/api/refresh` | POST   | Đổi refresh token → access token mới    | ❌ Không (dùng refresh token) |
| `/api/logout`  | POST   | Vô hiệu hoá session phía server         | ✅ Có                         |

> **Lưu ý:** Path constants được định nghĩa trong `lib/src/core/api_endpoints.dart`. Full URL = `BaseURL (từ AppEnvironment) + path`.

---

### O7. Token Lifecycle Summary

| Token         | TTL     | Lưu trữ                  | Bảo vệ    | Ghi chú                                     |
| ------------- | ------- | ------------------------ | --------- | ------------------------------------------- |
| access_token  | ~30 min | `flutter_secure_storage` | Không     | Đính kèm header `Authorization: Bearer ...` |
| refresh_token | 30 ngày | `flutter_secure_storage` | Biometric | Hết hạn → bắt buộc login lại                |

> **Lưu ý:** TTL thực tế do backend trả về qua `expires_in`. Giá trị trên là mặc định theo kiến trúc OAuth 2.1 của Sleep Buddy backend. Nếu deploy trên backend khác, TTL có thể khác.

---

## P. Quy ước Đặt tên

| Loại file                 | Suffix               | Ví dụ                                                  |
| ------------------------- | -------------------- | ------------------------------------------------------ |
| Domain entity             | (không suffix)       | `user.dart` → class `User`                             |
| Data model                | `_model`             | `user_model.dart` → class `UserModel`                  |
| Repository interface      | `_repository`        | `auth_repository.dart` → `AuthRepository`              |
| Repository implementation | `_repository_impl`   | `auth_repository_impl.dart` → `AuthRepositoryImpl`     |
| Remote datasource         | `_remote_datasource` | `auth_remote_datasource.dart` → `AuthRemoteDatasource` |
| Application service       | `_service`           | `auth_service.dart` → `AuthService`                    |
| Controller (Notifier)     | `_controller`        | `login_controller.dart` → `LoginController`            |
| Screen widget             | `_screen`            | `login_screen.dart` → `LoginScreen`                    |
| Interceptor               | `_interceptor`       | `auth_interceptor.dart` → `AuthInterceptor`            |
| Generated file            | `.g.dart`            | `user_model.g.dart` — KHÔNG sửa tay                    |
| Freezed generated         | `.freezed.dart`      | `user.freezed.dart` — KHÔNG sửa tay                    |
| Feature folder            | feature name         | `auth/`, `home/`, `settings/`                          |
