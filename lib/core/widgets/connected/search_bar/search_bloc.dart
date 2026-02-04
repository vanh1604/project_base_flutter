import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/books/domain/usecases/search_books_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

/// SearchBar Connected Component BLoC - Clean Architecture
///
/// Xử lý search functionality sử dụng SearchBooksUseCase.
/// Đây là Connected Component (KHÔNG phải feature) vì nó không có business domain.
/// Nó phụ thuộc vào Books feature's use case.
///
/// Location: core/widgets/connected/search_bar/
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBooksUseCase searchBooksUseCase;

  SearchBloc({required this.searchBooksUseCase}) : super(const SearchInitial()) {
    on<SearchBooksEvent>(_onSearchBooks);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onSearchBooks(
    SearchBooksEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (event.query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    final result = await searchBooksUseCase(
      SearchBooksParams(query: event.query),
    );

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (books) => emit(SearchLoaded(
        books: books,
        query: event.query,
      )),
    );
  }

  Future<void> _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(const SearchInitial());
  }
}
