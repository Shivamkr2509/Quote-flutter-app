/// Quote model class representing a quote from various quote APIs
class Quote {
  final String id;
  final String content;
  final String author;
  final int length;
  final List<String> tags;
  final String authorSlug;
  final DateTime? dateAdded;
  final DateTime? dateModified;

  const Quote({
    required this.id,
    required this.content,
    required this.author,
    required this.length,
    required this.tags,
    required this.authorSlug,
    required this.dateAdded,
    required this.dateModified,
  });

  /// Factory constructor to create Quote from Quotable API JSON
  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['_id'] as String,
      content: json['content'] as String,
      author: json['author'] as String,
      length: json['length'] as int,
      tags: List<String>.from(json['tags'] as List),
      authorSlug: json['authorSlug'] as String,
      dateAdded: json['dateAdded'] != null
          ? DateTime.parse(json['dateAdded'] as String)
          : null,
      dateModified: json['dateModified'] != null
          ? DateTime.parse(json['dateModified'] as String)
          : null,
    );
  }

  /// Factory constructor to create Quote from ZenQuotes API JSON
  factory Quote.fromZenQuotesJson(Map<String, dynamic> json) {
    final content = json['q'] as String;
    final author = json['a'] as String;

    return Quote(
      id: 'zenquotes-${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      author: author,
      length: content.length,
      tags: const ['zenquotes', 'inspiration'],
      authorSlug: author.toLowerCase().replaceAll(' ', '-'),
      dateAdded: DateTime.now(),
      dateModified: DateTime.now(),
    );
  }

  /// Factory constructor to create Quote from DummyJSON API JSON
  factory Quote.fromDummyJson(Map<String, dynamic> json) {
    final content = json['quote'] as String;
    final author = json['author'] as String;

    return Quote(
      id: 'dummyjson-${json['id'] ?? DateTime.now().millisecondsSinceEpoch}',
      content: content,
      author: author,
      length: content.length,
      tags: const ['dummyjson', 'inspiration'],
      authorSlug: author.toLowerCase().replaceAll(' ', '-'),
      dateAdded: DateTime.now(),
      dateModified: DateTime.now(),
    );
  }

  /// Convert Quote to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'author': author,
      'length': length,
      'tags': tags,
      'authorSlug': authorSlug,
      'dateAdded': dateAdded?.toIso8601String(),
      'dateModified': dateModified?.toIso8601String(),
    };
  }

  /// Get formatted quote text for sharing
  String get shareableText => '"$content" - $author';

  @override
  String toString() {
    return 'Quote(id: $id, content: $content, author: $author)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Quote && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
