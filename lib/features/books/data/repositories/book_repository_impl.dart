import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/book_entity.dart';
import '../../domain/repositories/i_book_repository.dart';
import '../datasources/books_remote_datasource.dart';

/// Book Repository Implementation - Data Layer (Clean Architecture)
///
/// Triển khai IBookRepository interface từ Domain Layer.
/// Phối hợp giữa Remote Data Source và chuyển đổi Model sang Entity.
///
/// Location: features/books/data/repositories/
class BookRepositoryImpl implements IBookRepository {
  final BooksRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks() async {
    try {
      final bookModels = await remoteDataSource.getAllBooks();
      // Model extends Entity, nên có thể trả về trực tiếp
      return Right(bookModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query) async {
    try {
      final bookModels = await remoteDataSource.searchBooks(query);
      return Right(bookModels);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, BookEntity>> getBookById(int id) async {
    try {
      final bookModel = await remoteDataSource.getBookById(id);
      return Right(bookModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}
