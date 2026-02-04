import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_books_usecase.dart';
import 'books_event.dart';
import 'books_state.dart';

/// Books Feature BLoC - Clean Architecture
///
/// Xử lý loading và displaying books.
/// BLoC gọi Use Cases thay vì Repository trực tiếp.
///
/// Location: features/books/presentation/bloc/
class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final GetBooksUseCase getBooksUseCase;

  BooksBloc({
    required this.getBooksUseCase,
  }) : super(const BooksInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
  }

  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    emit(const BooksLoading());

    final result = await getBooksUseCase(const NoParams());

    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books: books)),
    );
  }

  Future<void> _onRefreshBooks(
    RefreshBooksEvent event,
    Emitter<BooksState> emit,
  ) async {
    final result = await getBooksUseCase(const NoParams());

    result.fold(
      (failure) => emit(BooksError(failure.message)),
      (books) => emit(BooksLoaded(books: books)),
    );
  }
}
