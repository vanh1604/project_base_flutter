import 'package:equatable/equatable.dart';
import '../../domain/entities/book_entity.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object?> get props => [];
}

class BooksInitial extends BooksState {
  const BooksInitial();
}

class BooksLoading extends BooksState {
  const BooksLoading();
}

class BooksLoaded extends BooksState {
  final List<BookEntity> books;
  final bool isSearching;
  final String searchQuery;

  const BooksLoaded({
    required this.books,
    this.isSearching = false,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [books, isSearching, searchQuery];

  BooksLoaded copyWith({
    List<BookEntity>? books,
    bool? isSearching,
    String? searchQuery,
  }) {
    return BooksLoaded(
      books: books ?? this.books,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class BooksError extends BooksState {
  final String message;

  const BooksError(this.message);

  @override
  List<Object?> get props => [message];
}
