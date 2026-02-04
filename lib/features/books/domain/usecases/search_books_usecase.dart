import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/book_entity.dart';
import '../repositories/i_book_repository.dart';

/// Search Books UseCase - Domain Layer (Clean Architecture)
///
/// Use Case để tìm kiếm sách theo query từ Repository.
///
/// Location: features/books/domain/usecases/
class SearchBooksUseCase implements UseCase<List<BookEntity>, SearchBooksParams> {
  final IBookRepository repository;

  SearchBooksUseCase({required this.repository});

  @override
  Future<Either<Failure, List<BookEntity>>> call(SearchBooksParams params) async {
    // Business logic: trim và lowercase query
    final normalizedQuery = params.query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      // Nếu query rỗng, trả về tất cả sách
      return await repository.getAllBooks();
    }

    return await repository.searchBooks(normalizedQuery);
  }
}

/// Params cho SearchBooksUseCase
class SearchBooksParams extends Equatable {
  final String query;

  const SearchBooksParams({required this.query});

  @override
  List<Object?> get props => [query];
}
