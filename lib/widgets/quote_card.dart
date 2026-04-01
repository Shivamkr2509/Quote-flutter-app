import 'package:flutter/material.dart';
import '../models/quote.dart';

/// A custom card widget for displaying quotes with a clean, centered layout
class QuoteCard extends StatelessWidget {
  final Quote quote;
  final VoidCallback? onNewQuote;
  final VoidCallback? onShare;
  final bool isLoading;

  const QuoteCard({
    super.key,
    required this.quote,
    this.onNewQuote,
    this.onShare,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        constraints: const BoxConstraints(minHeight: 380, maxWidth: 450),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Decorative quote icon
            Icon(
              Icons.format_quote_rounded,
              size: 64,
              color: const Color(0xFFE94057).withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),

            // Quote content
            Expanded(
              child: Center(
                child: Text(
                  '"${quote.content}"',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: const Color(0xFF2B2D42),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Author name
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: Text(
                '— ${quote.author}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFF8D99AE),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Action buttons nicely arranged to prevent overlap
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.ios_share_rounded, size: 20),
                    label: const Text('Share'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      foregroundColor: const Color(0xFF2B2D42),
                      side: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : onNewQuote,
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_awesome, size: 20),
                    label: Text(isLoading ? 'Loading...' : 'New Quote'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF8A2387),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: const Color(0xFF8A2387).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
