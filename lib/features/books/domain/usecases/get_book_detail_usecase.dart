import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/i_book_repository.dart';

/// Get Book Detail UseCase - Domain Layer (Clean Architecture)
///
/// Use Case để lấy chi tiết sách theo ID từ Repository.
///
/// Location: features/books/domain/usecases/
class GetBookDetailUseCase implements UseCase<BookEntity, BookDetailParams> {
  final IBookRepository repository;

  GetBookDetailUseCase({required this.repository});

  @override
  Future<Either<Failure, BookEntity>> call(BookDetailParams params) async {
    return await repository.getBookById(params.id);
  }
}

/// Params cho GetBookDetailUseCase
class BookDetailParams extends Equatable {
  final int id;

  const BookDetailParams({required this.id});

  @override
  List<Object?> get props => [id];
}
