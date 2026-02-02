import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/book.dart';
import '../repositories/books_repository.dart';

class GetAllBooks {
  final BooksRepository repository;

  GetAllBooks({required this.repository});

  Future<Either<Failure, List<Book>>> call() async {
    return await repository.getAllBooks();
  }
}
