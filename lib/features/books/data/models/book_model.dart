import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.year,
    required super.handle,
    required super.publisher,
    required super.isbn,
    required super.pages,
  });

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

  Book toEntity() {
    return Book(
      id: id,
      title: title,
      year: year,
      handle: handle,
      publisher: publisher,
      isbn: isbn,
      pages: pages,
    );
  }
}
