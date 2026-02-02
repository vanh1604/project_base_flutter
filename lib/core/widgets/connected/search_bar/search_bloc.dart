import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/books/domain/usecases/search_books.dart';
import 'search_event.dart';
import 'search_state.dart';

/// SearchBar Connected Component BLoC
///
/// Handles search functionality using Books domain layer.
/// This is a Connected Component (NOT a feature) because it has no business domain.
/// It depends on Books feature's use cases.
///
/// Location: core/widgets/connected/search_bar/
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBooks searchBooks;

  SearchBloc({required this.searchBooks}) : super(const SearchInitial()) {
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

    final result = await searchBooks(event.query);

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
