import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/books/data/datasources/books_remote_datasource.dart';
import '../../features/books/data/repositories/books_repository_impl.dart';
import '../../features/books/domain/repositories/books_repository.dart';
import '../../features/books/domain/usecases/get_all_books.dart';
import '../../features/books/domain/usecases/search_books.dart';
import '../../features/books/presentation/bloc/books_bloc.dart';
import '../../features/books/presentation/widgets/stats/stats_bloc.dart';
import '../widgets/connected/search_bar/search_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies using GetIt Service Locator
///
/// Architecture:
/// - Books Feature: Full feature (Domain + Data + Presentation)
/// - Search Component: Connected widget (uses Books domain)
/// - Stats Component: Books widget (aggregates Books data)
Future<void> initializeDependencies() async {
  // ============================================
  // EXTERNAL DEPENDENCIES
  // ============================================
  sl.registerLazySingleton(() => http.Client());

  // ============================================
  // DATA SOURCES (Books Feature)
  // ============================================
  sl.registerLazySingleton<BooksRemoteDataSource>(
    () => BooksRemoteDataSourceImpl(client: sl()),
  );

  // ============================================
  // REPOSITORIES (Books Feature)
  // ============================================
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================
  // USE CASES (Books Feature)
  // ============================================
  sl.registerLazySingleton(() => GetAllBooks(repository: sl()));
  sl.registerLazySingleton(() => SearchBooks(repository: sl()));

  // ============================================
  // BLOCS - Factory Pattern
  // ============================================

  // Books Feature BLoC
  sl.registerFactory(() => BooksBloc(
        getAllBooks: sl(),
      ));

  // Search Connected Component BLoC (uses Books domain use case)
  sl.registerFactory(() => SearchBloc(
        searchBooks: sl(),
      ));

  // Stats Widget BLoC (part of Books feature, uses Books repository)
  sl.registerFactory(() => StatsBloc(
        repository: sl(),
      ));
}
