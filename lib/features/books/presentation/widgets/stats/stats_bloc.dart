import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_books_usecase.dart';
import 'stats_event.dart';
import 'stats_state.dart';

/// Stats Widget BLoC (Part of Books Feature) - Clean Architecture
///
/// Tính toán statistics từ Books data sử dụng GetBooksUseCase.
/// Đây KHÔNG phải là separate feature - đây là widget component của Books feature
/// vì nó không có business domain, chỉ aggregate Books data.
///
/// Location: features/books/presentation/widgets/stats/
class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetBooksUseCase getBooksUseCase;

  StatsBloc({required this.getBooksUseCase}) : super(const StatsInitial()) {
    on<LoadStatsEvent>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadStatsEvent event,
    Emitter<StatsState> emit,
  ) async {
    emit(const StatsLoading());

    final result = await getBooksUseCase(const NoParams());

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
