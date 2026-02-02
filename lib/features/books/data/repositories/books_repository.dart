import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../models/book_model.dart';
import '../datasources/books_remote_datasource.dart';

/// Books Repository - MVVM + BLoC Pattern
///
/// In MVVM + BLoC, we don't need repository interfaces.
/// This is a concrete class that handles data operations.
///
/// Location: features/books/data/repositories/
class BooksRepository {
  final BooksRemoteDataSource remoteDataSource;

  BooksRepository({required this.remoteDataSource});

  Future<Either<Failure, List<BookModel>>> getAllBooks() async {
    try {
      final books = await remoteDataSource.getAllBooks();
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  Future<Either<Failure, List<BookModel>>> searchBooks(String query) async {
    try {
      final books = await remoteDataSource.searchBooks(query);
      return Right(books);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  Future<Either<Failure, BookModel>> getBookById(int id) async {
    try {
      final book = await remoteDataSource.getBookById(id);
      return Right(book);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
