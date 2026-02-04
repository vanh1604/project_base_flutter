import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/i_book_repository.dart';

/// Get Books UseCase - Domain Layer (Clean Architecture)
///
/// Use Case để lấy tất cả sách từ Repository.
/// Không có business logic phức tạp, chỉ gọi repository.
///
/// Location: features/books/domain/usecases/
class GetBooksUseCase implements UseCase<List<BookEntity>, NoParams> {
  final IBookRepository repository;

  GetBooksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) async {
    return await repository.getAllBooks();
  }
}
