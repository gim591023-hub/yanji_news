// ─── Enums ───────────────────────────────────────────────────────────────────

enum ChangeType { up, down, newTag, same }
enum TagCategory { politics, economy, diplomacy, society }
enum Sentiment { positive, negative, neutral }
enum Platform { google, naver, internal }

extension ChangeTypeExt on ChangeType {
  String get label {
    switch (this) {
      case ChangeType.up: return '▲';
      case ChangeType.down: return '▼';
      case ChangeType.newTag: return 'NEW';
      case ChangeType.same: return '-';
    }
  }
}

extension TagCategoryExt on TagCategory {
  String get label {
    switch (this) {
      case TagCategory.politics: return '정치';
      case TagCategory.economy: return '경제';
      case TagCategory.diplomacy: return '외교';
      case TagCategory.society: return '사회';
    }
  }
}

// ─── Models ──────────────────────────────────────────────────────────────────

class TrendItem {
  final String id;
  final String name;
  final int rank;
  final int mentionCount;
  final ChangeType changeType;
  final int changeValue;
  final TagCategory category;
  final Platform platform;

  const TrendItem({
    required this.id,
    required this.name,
    required this.rank,
    required this.mentionCount,
    required this.changeType,
    required this.changeValue,
    required this.category,
    required this.platform,
  });
}

class AiSummary {
  final String text;
  final Sentiment sentiment;
  final List<String> keywords;
  final String category;

  const AiSummary({
    required this.text,
    required this.sentiment,
    required this.keywords,
    required this.category,
  });
}

class RelatedTag {
  final String name;
  final double rate;
  final TagCategory category;

  const RelatedTag({
    required this.name,
    required this.rate,
    required this.category,
  });
}

class NewsArticle {
  final String id;
  final String title;
  final String source;
  final String? thumbnailUrl;
  final DateTime publishedAt;
  final List<String> tags;
  final String sourceUrl;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.source,
    this.thumbnailUrl,
    required this.publishedAt,
    required this.tags,
    required this.sourceUrl,
  });
}

class TagDetail {
  final String id;
  final String name;
  final TagCategory category;
  final int mentionCount;
  final AiSummary summary;
  final List<RelatedTag> relatedTags;
  final List<NewsArticle> articles;
  final List<TrendPoint> trendData;

  const TagDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.mentionCount,
    required this.summary,
    required this.relatedTags,
    required this.articles,
    required this.trendData,
  });
}

class TrendPoint {
  final DateTime date;
  final int mentionCount;
  final double positiveRate;
  final double negativeRate;

  const TrendPoint({
    required this.date,
    required this.mentionCount,
    required this.positiveRate,
    required this.negativeRate,
  });
}
