import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/quote.dart';

/// Custom exception for API-related errors
class QuoteApiException implements Exception {
  final String message;
  final int? statusCode;

  const QuoteApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'QuoteApiException: $message';
}

/// Service class for handling API calls to the Quote API
class QuoteApiService {
  static const String _baseUrl = 'https://dummyjson.com/quotes';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  QuoteApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch a random quote from the API
  ///
  /// Returns a [Quote] object containing the quote data.
  /// Throws [QuoteApiException] if the API call fails.
  Future<Quote> fetchRandomQuote() async {
    try {
      final uri = Uri.parse('$_baseUrl/random');

      final response = await _client.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        return Quote.fromDummyJson(jsonData);
      } else {
        throw QuoteApiException(
          'Failed to fetch quote: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on SocketException {
      throw const QuoteApiException(
        'No internet connection. Please check your network and try again.',
      );
    } on HttpException {
      throw const QuoteApiException(
        'HTTP error occurred. Please try again later.',
      );
    } on FormatException {
      throw const QuoteApiException('Invalid response format from server.');
    } catch (e) {
      if (e is QuoteApiException) {
        rethrow;
      }

      // Handle SSL certificate errors
      if (e.toString().contains('CERT_DATE_INVALID') ||
          e.toString().contains('certificate') ||
          e.toString().contains('SSL')) {
        throw const QuoteApiException(
          'SSL certificate error. The API service may be temporarily unavailable. Please try again later.',
        );
      }

      throw QuoteApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Fetch multiple random quotes concurrently
  ///
  /// [count] - Number of quotes to fetch (default: 3)
  /// Returns a list of [Quote] objects.
  Future<List<Quote>> fetchMultipleQuotes({int count = 3}) async {
    try {
      final futures = List.generate(count, (_) => fetchRandomQuote());

      final quotes = await Future.wait(futures);
      return quotes;
    } catch (e) {
      if (e is QuoteApiException) {
        rethrow;
      }
      throw QuoteApiException(
        'Failed to fetch multiple quotes: ${e.toString()}',
      );
    }
  }

  /// Get a fallback quote when the API is unavailable
  Quote getFallbackQuote() {
    return const Quote(
      id: 'fallback-1',
      content: 'The only way to do great work is to love what you do.',
      author: 'Steve Jobs',
      length: 58,
      tags: ['inspiration', 'work', 'passion'],
      authorSlug: 'steve-jobs',
      dateAdded: null,
      dateModified: null,
    );
  }

  /// Dispose the HTTP client
  void dispose() {
    _client.close();
  }
}
