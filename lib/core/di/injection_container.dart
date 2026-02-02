import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../features/books/data/datasources/books_remote_datasource.dart';
import '../../features/books/data/repositories/books_repository.dart';
import '../../features/books/presentation/bloc/books_bloc.dart';
import '../../features/books/presentation/widgets/stats/stats_bloc.dart';
import '../widgets/connected/search_bar/search_bloc.dart';

final sl = GetIt.instance;

/// Initialize all dependencies using GetIt Service Locator
///
/// Architecture: MVVM + BLoC Pattern
/// - Books Feature: Business feature with Repository + DataSource
/// - Search Component: Connected widget (depends on Books repository)
/// - Stats Component: Books widget (aggregates Books data from repository)
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
  // REPOSITORIES (Books Feature) - Concrete class
  // ============================================
  sl.registerLazySingleton<BooksRepository>(
    () => BooksRepository(remoteDataSource: sl()),
  );

  // ============================================
  // BLOCS - Factory Pattern
  // ============================================

  // Books Feature BLoC (inject Repository)
  sl.registerFactory(() => BooksBloc(
        repository: sl(),
      ));

  // Search Connected Component BLoC (inject Repository)
  sl.registerFactory(() => SearchBloc(
        repository: sl(),
      ));

  // Stats Widget BLoC (inject Repository)
  sl.registerFactory(() => StatsBloc(
        repository: sl(),
      ));
}
