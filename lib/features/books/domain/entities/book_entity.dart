import 'package:equatable/equatable.dart';

/// Book Entity - Domain Layer (Clean Architecture)
///
/// Pure business object. KHÔNG chứa logic JSON parsing.
/// Entity là đối tượng nghiệp vụ cốt lõi, độc lập với Data Layer.
///
/// Location: features/books/domain/entities/
class BookEntity extends Equatable {
  final int id;
  final String title;
  final int year;
  final String handle;
  final String publisher;
  final String isbn;
  final int pages;

  const BookEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.handle,
    required this.publisher,
    required this.isbn,
    required this.pages,
  });

  @override
  List<Object?> get props => [id, title, year, handle, publisher, isbn, pages];
}
