import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final int id;
  final String title;
  final int year;
  final String handle;
  final String publisher;
  final String isbn;
  final int pages;

  const Book({
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
