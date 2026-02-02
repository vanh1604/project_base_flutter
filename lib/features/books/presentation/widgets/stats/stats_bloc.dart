import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/books_repository.dart';
import 'stats_event.dart';
import 'stats_state.dart';

/// Stats Widget BLoC (Part of Books Feature)
///
/// Calculates statistics from Books data.
/// This is NOT a separate feature - it's a widget component of Books feature
/// because it has no business domain, only aggregates Books data.
///
/// Location: features/books/presentation/widgets/stats/
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final BooksRepository repository;

  StatsBloc({required this.repository}) : super(const StatsInitial()) {
    on<LoadStatsEvent>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadStatsEvent event,
    Emitter<StatsState> emit,
  ) async {
    emit(const StatsLoading());

    final result = await repository.getAllBooks();

    result.fold(
      (failure) => emit(StatsError(failure.message)),
      (books) {
        final totalBooks = books.length;
        final totalPages = books.fold<int>(0, (sum, book) => sum + book.pages);
        final averagePages = totalBooks > 0 ? totalPages / totalBooks : 0.0;

        final yearGroups = <int, int>{};
        for (var book in books) {
          yearGroups[book.year] = (yearGroups[book.year] ?? 0) + 1;
        }

        final publisherGroups = <String, int>{};
        for (var book in books) {
          publisherGroups[book.publisher] =
              (publisherGroups[book.publisher] ?? 0) + 1;
        }

        final oldestYear = books.isNotEmpty
            ? books.map((b) => b.year).reduce((a, b) => a < b ? a : b)
            : 0;
        final newestYear = books.isNotEmpty
            ? books.map((b) => b.year).reduce((a, b) => a > b ? a : b)
            : 0;

        emit(StatsLoaded(
          totalBooks: totalBooks,
          totalPages: totalPages,
          averagePages: averagePages,
          yearGroups: yearGroups,
          publisherGroups: publisherGroups,
          oldestYear: oldestYear,
          newestYear: newestYear,
        ));
      },
    );
  }
}
