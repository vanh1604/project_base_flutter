import '../../domain/entities/book_entity.dart';

/// Book Model - Data Layer (Clean Architecture)
///
/// Mở rộng BookEntity với logic JSON serialization.
/// Model chịu trách nhiệm chuyển đổi giữa JSON và Entity.
///
/// Location: features/books/data/models/
class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.title,
    required super.year,
    required super.handle,
    required super.publisher,
    required super.isbn,
    required super.pages,
  });

  /// Convert từ JSON sang Model
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

  /// Convert từ Model sang JSON
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

  /// Convert từ Entity sang Model
  factory BookModel.fromEntity(BookEntity entity) {
    return BookModel(
      id: entity.id,
      title: entity.title,
      year: entity.year,
      handle: entity.handle,
      publisher: entity.publisher,
      isbn: entity.isbn,
      pages: entity.pages,
    );
  }
}
