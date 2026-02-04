import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/books/data/datasources/books_remote_datasource.dart';
import '../../features/books/data/repositories/book_repository_impl.dart';
import '../../features/books/domain/repositories/i_book_repository.dart';
import '../../features/books/domain/usecases/get_books_usecase.dart';
import '../../features/books/domain/usecases/get_book_detail_usecase.dart';
import '../../features/books/domain/usecases/search_books_usecase.dart';
import '../../features/books/presentation/bloc/books_bloc.dart';
import '../../features/books/presentation/widgets/stats/stats_bloc.dart';
import '../widgets/connected/search_bar/search_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies using GetIt Service Locator
///
/// Architecture: Clean Architecture + MVVM + BLoC Pattern
/// Layers:
///   - Domain: Entities, Use Cases, Repository Interfaces
///   - Data: Models, Data Sources, Repository Implementations
///   - Presentation: BLoC, Pages, Widgets
Future<void> initializeDependencies() async {
  // ============================================
  // EXTERNAL DEPENDENCIES
  // ============================================
  sl.registerLazySingleton(() => http.Client());

  // ============================================
  // DATA SOURCES (Data Layer)
  // ============================================
  sl.registerLazySingleton<BooksRemoteDataSource>(
    () => BooksRemoteDataSourceImpl(client: sl()),
  );

  // ============================================
  // REPOSITORIES (Data Layer) - Implementations
  // ============================================
  // Repository Implementation implements Repository Interface
  sl.registerLazySingleton<IBookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // USE CASES (Domain Layer)
  // ============================================
  // Books Feature Use Cases
  sl.registerLazySingleton(() => GetBooksUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetBookDetailUseCase(repository: sl()));
  sl.registerLazySingleton(() => SearchBooksUseCase(repository: sl()));

  // ============================================
  // BLOCS - Factory Pattern (Presentation Layer)
  // ============================================

  // Books Feature BLoC (inject Use Cases)
  sl.registerFactory(() => BooksBloc(
        getBooksUseCase: sl(),
      ));

  // Search Connected Component BLoC (inject Use Case)
  sl.registerFactory(() => SearchBloc(
        searchBooksUseCase: sl(),
      ));

  // Stats Widget BLoC (inject Use Case)
  sl.registerFactory(() => StatsBloc(
        getBooksUseCase: sl(),
      ));
}
