import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_all_books.dart';
import 'books_event.dart';
import 'books_state.dart';

/// Books Feature BLoC
///
/// Handles loading and displaying books.
/// Search functionality has been moved to SearchBloc (features/search/).
///
/// Location: features/books/presentation/bloc/
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final GetAllBooks getAllBooks;

  BooksBloc({
    required this.getAllBooks,
  }) : super(const BooksInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(const BooksLoading());

    final result = await getAllBooks();

    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books: books)),
    );
  }

  Future<void> _onRefreshBooks(
    RefreshBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    final result = await getAllBooks();

    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books: books)),
    );
  }
}
