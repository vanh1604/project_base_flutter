import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book.dart';
import '../repositories/books_repository.dart';

class SearchBooks {
  final BooksRepository repository;

  SearchBooks({required this.repository});

  Future<Either<Failure, List<Book>>> call(String query) async {
    return await repository.searchBooks(query);
  }
}
