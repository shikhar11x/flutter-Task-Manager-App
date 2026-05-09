import 'package:flutter/material.dart';
import 'dart:ui';

class QuoteCard extends StatelessWidget {
  final String quote;
  final String author;
  final bool isLoading;
  final VoidCallback onRefresh;

  const QuoteCard({
    super.key,
    required this.quote,
    required this.author,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4A90E2).withOpacity(0.2),
                const Color(0xFF7B5EA7).withOpacity(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: const Color(0xFF4A90E2).withOpacity(0.3)),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF4A90E2).withOpacity(0.2),
                      ),
                      child: const Icon(Icons.format_quote,
                          color: Color(0xFF4A90E2), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quote,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '— $author',
                            style: const TextStyle(
                                color: Color(0xFF4A90E2),
                                fontSize: 11,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onRefresh,
                      child: Icon(Icons.refresh,
                          color: Colors.white.withOpacity(0.4), size: 18),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}