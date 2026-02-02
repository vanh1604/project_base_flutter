import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/books_repository.dart';
import 'books_event.dart';
import 'books_state.dart';

/// Books Feature BLoC - MVVM + BLoC Pattern
///
/// Handles loading and displaying books.
/// In MVVM + BLoC, BLoC calls Repository directly (no use cases).
///
/// Location: features/books/presentation/bloc/
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final BooksRepository repository;

  BooksBloc({
    required this.repository,
  }) : super(const BooksInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(const BooksLoading());

    final result = await repository.getAllBooks();

    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books: books)),
    );
  }

  Future<void> _onRefreshBooks(
    RefreshBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    final result = await repository.getAllBooks();

    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books: books)),
    );
  }
}
