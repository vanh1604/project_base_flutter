import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/book_entity.dart';

/// Book Repository Interface - Domain Layer (Clean Architecture)
///
/// Định nghĩa contract cho việc truy xuất dữ liệu sách.
/// Data Layer sẽ implement interface này.
///
/// Location: features/books/domain/repositories/
abstract class IBookRepository {
  /// Lấy tất cả sách
  Future<Either<Failure, List<BookEntity>>> getAllBooks();

  /// Tìm kiếm sách theo query
  Future<Either<Failure, List<BookEntity>>> searchBooks(String query);

  /// Lấy sách theo ID
  Future<Either<Failure, BookEntity>> getBookById(int id);
}
