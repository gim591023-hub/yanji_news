import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/common_widgets.dart';
import 'news_screen.dart';

class TagDetailScreen extends StatefulWidget {
  final String tagName;

  const TagDetailScreen({super.key, required this.tagName});

  @override
  State<TagDetailScreen> createState() => _TagDetailScreenState();
}

class _TagDetailScreenState extends State<TagDetailScreen> {
  late TagDetail _detail;
  bool _loading = true;
  String _period = '1개월';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _detail = MockDataService.getTagDetail(widget.tagName);
        _loading = false;
      });
    }
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YangjiColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: _loading ? _buildSkeleton() : _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final isFav = !_loading && state.isFavorite(widget.tagName);
        return Container(
          color: YangjiColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: YangjiColors.background, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_ios_new, size: 16, color: YangjiColors.primaryDark),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '#${widget.tagName}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: YangjiColors.primaryDark),
                ),
              ),
              GestureDetector(
                onTap: () => state.toggleFavorite(widget.tagName),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isFav ? YangjiColors.primary.withOpacity(0.1) : YangjiColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: isFav ? YangjiColors.primary : YangjiColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 80, height: 14),
                const SizedBox(height: 12),
                SkeletonBox(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                SkeletonBox(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                SkeletonBox(width: 200, height: 12),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAiSummaryCard(),
          const SizedBox(height: 16),
          _buildStatsCard(),
          const SizedBox(height: 16),
          _buildTrendGraph(),
          const SizedBox(height: 16),
          _buildRelatedTags(),
          const SizedBox(height: 16),
          _buildNewsSection(),
        ],
      ),
    );
  }

  Widget _buildAiSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [YangjiColors.primaryDark, YangjiColors.primary],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: YangjiColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              const Text('AI 요약', style: TextStyle(fontSize: 13, color: Colors.white70, fontWeight: FontWeight.w600)),
              const Spacer(),
              SentimentBadge(sentiment: _detail.summary.sentiment),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _detail.summary.text,
            style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.6),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: _detail.summary.keywords.map((kw) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('#$kw', style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: YangjiColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(child: _statItem('언급량', _formatCount(_detail.mentionCount), Icons.trending_up, YangjiColors.up)),
          _divider(),
          Expanded(child: _statItem('카테고리', _detail.category.label, Icons.category_outlined, YangjiColors.primary)),
          _divider(),
          Expanded(child: _statItem('연관 태그', '${_detail.relatedTags.length}개', Icons.hub_outlined, YangjiColors.diplomacy)),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: YangjiColors.textSecondary)),
      ],
    );
  }

  Widget _divider() {
    return Container(width: 1, height: 48, color: YangjiColors.background);
  }

  Widget _buildTrendGraph() {
    final periods = ['7일', '1개월', '3개월', '1년'];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: YangjiColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('언급량 추이', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              ...periods.map((p) => GestureDetector(
                onTap: () => setState(() => _period = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(left: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _period == p ? YangjiColors.primary : YangjiColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _period == p ? Colors.white : YangjiColors.textSecondary,
                    ),
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(color: YangjiColors.background, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _detail.trendData.asMap().entries.map((e) =>
                      FlSpot(e.key.toDouble(), e.value.mentionCount / 10000)
                    ).toList(),
                    isCurved: true,
                    color: YangjiColors.primary,
                    barWidth: 2.5,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [YangjiColors.primary.withOpacity(0.3), YangjiColors.primary.withOpacity(0)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedTags() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '연관 키워드'),
          const SizedBox(height: 16),
          ..._detail.relatedTags.map((tag) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                TagBadge(label: tag.category.label, category: tag.category, small: true),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tag.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: tag.rate,
                          backgroundColor: YangjiColors.background,
                          valueColor: AlwaysStoppedAnimation(_categoryColor(tag.category)),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${(tag.rate * 100).toInt()}%',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: YangjiColors.textSecondary),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Color _categoryColor(TagCategory c) {
    switch (c) {
      case TagCategory.politics: return YangjiColors.politics;
      case TagCategory.economy: return YangjiColors.economy;
      case TagCategory.diplomacy: return YangjiColors.diplomacy;
      case TagCategory.society: return YangjiColors.society;
    }
  }

  Widget _buildNewsSection() {
    return Column(
      children: [
        SectionHeader(
          title: '관련 기사',
          actionLabel: '전체보기',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => NewsScreen(tagName: widget.tagName, articles: _detail.articles)),
          ),
        ),
        const SizedBox(height: 12),
        ..._detail.articles.take(3).map((a) => _NewsListItem(article: a)),
      ],
    );
  }
}

class _NewsListItem extends StatelessWidget {
  final NewsArticle article;
  const _NewsListItem({required this.article});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 1) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: YangjiColors.primaryDark.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(article.source, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: YangjiColors.primaryDark)),
              ),
              const Spacer(),
              Text(_timeAgo(article.publishedAt), style: const TextStyle(fontSize: 11, color: YangjiColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            article.title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: article.tags.map((t) => TagBadge(label: '#$t', small: true)).toList(),
          ),
        ],
      ),
    );
  }
}
