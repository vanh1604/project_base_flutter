import 'package:equatable/equatable.dart';
import '../../../../features/books/data/models/book_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<BookModel> books;
  final String query;

  const SearchLoaded({
    required this.books,
    required this.query,
  });

  @override
  List<Object?> get props => [books, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
