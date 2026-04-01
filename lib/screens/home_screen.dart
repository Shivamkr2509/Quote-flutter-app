import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/quote_provider.dart';
import '../widgets/quote_card.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';

/// Main home screen displaying quotes with clean UI and functionality
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial quote when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuoteProvider>().loadNewQuote();
    });
  }

  /// Handle sharing the current quote
  void _shareQuote() {
    final quoteProvider = context.read<QuoteProvider>();
    final quote = quoteProvider.currentQuote;

    if (quote != null) {
      Share.share(quote.shareableText, subject: 'Daily Quote');
    }
  }

  /// Handle loading a new quote
  void _loadNewQuote() {
    context.read<QuoteProvider>().loadNewQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Quote of the Day',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Quote counter
          Consumer<QuoteProvider>(
            builder: (context, quoteProvider, child) {
              if (quoteProvider.quoteCount > 0) {
                return Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${quoteProvider.quoteCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Consumer<QuoteProvider>(
                builder: (context, quoteProvider, child) {
                  switch (quoteProvider.state) {
                    case QuoteState.initial:
                    case QuoteState.loading:
                      return const CustomLoadingWidget(
                        message: 'Fetching your daily inspiration...',
                      );

                    case QuoteState.loaded:
                      if (quoteProvider.currentQuote != null) {
                        return QuoteCard(
                          quote: quoteProvider.currentQuote!,
                          onNewQuote: _loadNewQuote,
                          onShare: _shareQuote,
                          isLoading: quoteProvider.isLoading,
                        );
                      } else {
                        return const CustomErrorWidget(
                          message: 'No quote available. Please try again.',
                          icon: Icons.format_quote,
                        );
                      }

                    case QuoteState.error:
                      return CustomErrorWidget(
                        message:
                            quoteProvider.errorMessage ??
                            'Unknown error occurred',
                        onRetry: _loadNewQuote,
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
