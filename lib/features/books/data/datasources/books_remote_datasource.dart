import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/book_model.dart';

abstract class BooksRemoteDataSource {
  Future<List<BookModel>> getAllBooks();
  Future<List<BookModel>> searchBooks(String query);
  Future<BookModel> getBookById(int id);
}

class BooksRemoteDataSourceImpl implements BooksRemoteDataSource {
  final http.Client client;

  BooksRemoteDataSourceImpl({required this.client});

  @override
  Future<List<BookModel>> getAllBooks() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.booksEndpoint}'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> booksJson = jsonData['data'] as List<dynamic>;
        return booksJson.map((json) => BookModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }

  @override
  Future<List<BookModel>> searchBooks(String query) async {
    try {
      final books = await getAllBooks();
      if (query.isEmpty) return books;

      final lowercaseQuery = query.toLowerCase();
      return books.where((book) {
        return book.title.toLowerCase().contains(lowercaseQuery) ||
            book.publisher.toLowerCase().contains(lowercaseQuery) ||
            book.year.toString().contains(query);
      }).toList();
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException('Search failed: $e');
    }
  }

  @override
  Future<BookModel> getBookById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.booksEndpoint}/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return BookModel.fromJson(jsonData['data']);
      } else {
        throw ServerException('Failed to load book: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw NetworkException('Network error: $e');
    }
  }
}
