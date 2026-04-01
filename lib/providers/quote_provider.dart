import 'package:flutter/foundation.dart';
import '../models/quote.dart';
import '../services/quote_api_service.dart';

/// Enum representing the different states of quote loading
enum QuoteState { initial, loading, loaded, error }

/// Provider class for managing quote state and operations
class QuoteProvider with ChangeNotifier {
  final QuoteApiService _apiService;

  QuoteState _state = QuoteState.initial;
  Quote? _currentQuote;
  String? _errorMessage;
  int _quoteCount = 0;

  QuoteProvider({QuoteApiService? apiService})
    : _apiService = apiService ?? QuoteApiService();

  // Getters
  QuoteState get state => _state;
  Quote? get currentQuote => _currentQuote;
  String? get errorMessage => _errorMessage;
  int get quoteCount => _quoteCount;
  bool get isLoading => _state == QuoteState.loading;
  bool get hasError => _state == QuoteState.error;
  bool get hasQuote => _currentQuote != null;

  /// Load a new random quote
  Future<void> loadNewQuote() async {
    _setState(QuoteState.loading);
    _clearError();

    try {
      final quote = await _apiService.fetchRandomQuote();
      _currentQuote = quote;
      _quoteCount++;
      _setState(QuoteState.loaded);
    } catch (e) {
      // If it's an SSL certificate error, try to use fallback quote
      if (e.toString().contains('SSL certificate error')) {
        _currentQuote = _apiService.getFallbackQuote();
        _quoteCount++;
        _setState(QuoteState.loaded);
      } else {
        _setError(e.toString());
      }
    }
  }

  /// Load multiple quotes concurrently (for demonstration of concurrent fetching)
  Future<void> loadMultipleQuotes({int count = 3}) async {
    _setState(QuoteState.loading);
    _clearError();

    try {
      final quotes = await _apiService.fetchMultipleQuotes(count: count);
      // Use the first quote from the batch
      if (quotes.isNotEmpty) {
        _currentQuote = quotes.first;
        _quoteCount += quotes.length;
        _setState(QuoteState.loaded);
      } else {
        _setError('No quotes received from API');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  /// Retry loading a quote after an error
  Future<void> retry() async {
    if (_state == QuoteState.error) {
      await loadNewQuote();
    }
  }

  /// Clear the current quote and reset to initial state
  void clearQuote() {
    _currentQuote = null;
    _clearError();
    _setState(QuoteState.initial);
  }

  /// Reset the quote count
  void resetQuoteCount() {
    _quoteCount = 0;
    notifyListeners();
  }

  /// Private method to set state and notify listeners
  void _setState(QuoteState newState) {
    _state = newState;
    notifyListeners();
  }

  /// Private method to set error state
  void _setError(String message) {
    _errorMessage = message;
    _setState(QuoteState.error);
  }

  /// Private method to clear error
  void _clearError() {
    _errorMessage = null;
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}
