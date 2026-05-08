import '../models/models.dart';

class MockDataService {
  static List<TrendItem> getTrends(Platform platform) {
    final all = [
      const TrendItem(id: '1', name: '트럼프', rank: 1, mentionCount: 1284000, changeType: ChangeType.up, changeValue: 2, category: TagCategory.politics, platform: Platform.google),
      const TrendItem(id: '2', name: '관세전쟁', rank: 2, mentionCount: 987000, changeType: ChangeType.newTag, changeValue: 0, category: TagCategory.economy, platform: Platform.google),
      const TrendItem(id: '3', name: '이재명', rank: 3, mentionCount: 876000, changeType: ChangeType.down, changeValue: 1, category: TagCategory.politics, platform: Platform.naver),
      const TrendItem(id: '4', name: '금리인하', rank: 4, mentionCount: 754000, changeType: ChangeType.up, changeValue: 3, category: TagCategory.economy, platform: Platform.naver),
      const TrendItem(id: '5', name: '한미동맹', rank: 5, mentionCount: 623000, changeType: ChangeType.same, changeValue: 0, category: TagCategory.diplomacy, platform: Platform.internal),
      const TrendItem(id: '6', name: '부동산', rank: 6, mentionCount: 541000, changeType: ChangeType.up, changeValue: 1, category: TagCategory.economy, platform: Platform.naver),
      const TrendItem(id: '7', name: '의료파업', rank: 7, mentionCount: 498000, changeType: ChangeType.down, changeValue: 2, category: TagCategory.society, platform: Platform.naver),
      const TrendItem(id: '8', name: '반도체', rank: 8, mentionCount: 432000, changeType: ChangeType.up, changeValue: 4, category: TagCategory.economy, platform: Platform.google),
      const TrendItem(id: '9', name: 'AI규제', rank: 9, mentionCount: 387000, changeType: ChangeType.newTag, changeValue: 0, category: TagCategory.politics, platform: Platform.google),
      const TrendItem(id: '10', name: '탄소세', rank: 10, mentionCount: 321000, changeType: ChangeType.down, changeValue: 3, category: TagCategory.diplomacy, platform: Platform.internal),
    ];
    if (platform == Platform.google) return all.where((t) => t.platform == Platform.google || t.platform == Platform.internal).toList();
    if (platform == Platform.naver) return all.where((t) => t.platform == Platform.naver || t.platform == Platform.internal).toList();
    return all;
  }

  static TagDetail getTagDetail(String tagName) {
    final now = DateTime.now();
    return TagDetail(
      id: '1',
      name: tagName,
      category: TagCategory.politics,
      mentionCount: 1284000,
      summary: const AiSummary(
        text: '최근 미국 트럼프 행정부의 고율 관세 정책 강화로 글로벌 무역 긴장이 고조되고 있습니다. 한국을 비롯한 주요 교역국들은 협상 전략을 모색 중이며, 국내 수출 기업에 대한 영향이 우려되고 있습니다. AI와 반도체 분야를 중심으로 미중 기술 갈등과 맞물려 복합적인 경제 안보 이슈로 부상하고 있습니다.',
        sentiment: Sentiment.negative,
        keywords: ['관세', '무역전쟁', '협상', '수출', '경제안보'],
        category: '정치·외교',
      ),
      relatedTags: const [
        RelatedTag(name: '관세전쟁', rate: 0.82, category: TagCategory.economy),
        RelatedTag(name: '한미동맹', rate: 0.71, category: TagCategory.diplomacy),
        RelatedTag(name: '반도체', rate: 0.64, category: TagCategory.economy),
        RelatedTag(name: 'AI규제', rate: 0.58, category: TagCategory.politics),
        RelatedTag(name: '달러환율', rate: 0.49, category: TagCategory.economy),
      ],
      articles: [
        NewsArticle(
          id: 'a1',
          title: '트럼프, 한국 자동차 관세 25% 부과 검토... 현대·기아 직격탄',
          source: '조선일보',
          publishedAt: now.subtract(const Duration(hours: 1)),
          tags: ['트럼프', '관세', '자동차'],
          sourceUrl: 'https://example.com/1',
        ),
        NewsArticle(
          id: 'a2',
          title: '미 재무장관 "한국과 관세 협상 우선 추진"... 외교부 긴급 대응',
          source: '한국경제',
          publishedAt: now.subtract(const Duration(hours: 3)),
          tags: ['트럼프', '관세협상', '외교'],
          sourceUrl: 'https://example.com/2',
        ),
        NewsArticle(
          id: 'a3',
          title: '트럼프 관세 충격에 코스피 2% 급락... 수출주 패닉',
          source: 'MBC뉴스',
          publishedAt: now.subtract(const Duration(hours: 5)),
          tags: ['트럼프', '주식시장', '코스피'],
          sourceUrl: 'https://example.com/3',
        ),
        NewsArticle(
          id: 'a4',
          title: '"협상 여지 있다"... 미 상무부, 한국 반도체 특별 대우 시사',
          source: '매일경제',
          publishedAt: now.subtract(const Duration(hours: 8)),
          tags: ['트럼프', '반도체', '협상'],
          sourceUrl: 'https://example.com/4',
        ),
        NewsArticle(
          id: 'a5',
          title: '트럼프 2기 100일... "관세 외교"로 글로벌 질서 재편 시도',
          source: '연합뉴스',
          publishedAt: now.subtract(const Duration(hours: 12)),
          tags: ['트럼프', '외교정책', '글로벌'],
          sourceUrl: 'https://example.com/5',
        ),
      ],
      trendData: List.generate(30, (i) {
        return TrendPoint(
          date: now.subtract(Duration(days: 29 - i)),
          mentionCount: 400000 + (i * 30000) + (i % 5 == 0 ? 200000 : 0),
          positiveRate: 0.25 + (i * 0.005),
          negativeRate: 0.55 - (i * 0.003),
        );
      }),
    );
  }

  static List<String> getSearchSuggestions(String query) {
    final all = ['트럼프', '트럼프 관세', '트럼프 탄핵', '이재명', '이재명 공판', '반도체', '반도체 수출', '금리', '금리인하', '부동산', '부동산 규제', '한미동맹', 'AI규제', '의료파업'];
    if (query.isEmpty) return all.take(5).toList();
    return all.where((s) => s.contains(query)).take(5).toList();
  }

  static List<String> getRecentSearches() {
    return ['트럼프', '금리인하', '반도체', '한미동맹'];
  }

  static List<String> getPopularSearches() {
    return ['트럼프', '관세전쟁', '이재명', '금리인하', '반도체'];
  }
}
