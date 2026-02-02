import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book.dart';

abstract class BooksRepository {
  Future<Either<Failure, List<Book>>> getAllBooks();
  Future<Either<Failure, List<Book>>> searchBooks(String query);
  Future<Either<Failure, Book>> getBookById(int id);
}
