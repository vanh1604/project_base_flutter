import 'package:equatable/equatable.dart';

/// Book Model - MVVM + BLoC Pattern
///
/// In MVVM + BLoC, we don't separate Entity and Model.
/// This class serves as both business object AND data model.
///
/// Location: features/books/data/models/
class BookModel extends Equatable {
  final int id;
  final String title;
  final int year;
  final String handle;
  final String publisher;
  final String isbn;
  final int pages;

  const BookModel({
    required this.id,
    required this.title,
    required this.year,
    required this.handle,
    required this.publisher,
    required this.isbn,
    required this.pages,
  });

  // JSON serialization for API/Database
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['Title'] as String? ?? '',
      year: json['Year'] as int? ?? 0,
      handle: json['handle'] as String? ?? '',
      publisher: json['Publisher'] as String? ?? '',
      isbn: json['ISBN'] as String? ?? '',
      pages: json['Pages'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Title': title,
      'Year': year,
      'handle': handle,
      'Publisher': publisher,
      'ISBN': isbn,
      'Pages': pages,
    };
  }

  // Equatable for value comparison
  @override
  List<Object?> get props => [id, title, year, handle, publisher, isbn, pages];
}
