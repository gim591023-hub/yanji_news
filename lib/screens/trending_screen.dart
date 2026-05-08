import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/common_widgets.dart';
import 'tag_detail_screen.dart';
import 'search_screen.dart';

class TrendingScreen extends StatelessWidget {
  const TrendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YangjiColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: Consumer<AppState>(
                builder: (context, state, _) {
                  return RefreshIndicator(
                    color: YangjiColors.primary,
                    onRefresh: state.loadTrends,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          _buildUpdateInfo(),
                          const SizedBox(height: 16),
                          PlatformFilter(
                            selected: state.selectedPlatform,
                            onChanged: state.setPlatform,
                          ),
                          const SizedBox(height: 20),
                          if (state.isLoadingTrends)
                            _buildSkeletonList()
                          else
                            _buildTrendList(context, state),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final controller = TextEditingController();
    return Container(
      color: YangjiColors.surface,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: YangjiColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text('양', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'YANGJI',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: YangjiColors.primaryDark,
                  letterSpacing: 1.5,
                ),
              ),
              const Spacer(),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: YangjiColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_outlined, size: 20, color: YangjiColors.primaryDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          YangjiSearchBar(
            controller: controller,
            readOnly: true,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateInfo() {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: YangjiColors.newTag, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        const Text(
          '실시간 트렌드',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: YangjiColors.textPrimary),
        ),
        const Spacer(),
        const Text(
          '방금 업데이트',
          style: TextStyle(fontSize: 12, color: YangjiColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSkeletonList() {
    return Column(
      children: List.generate(
        8,
        (i) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: YangjiColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              SkeletonBox(width: 32, height: 32, borderRadius: 8),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 80, height: 16),
                  const SizedBox(height: 6),
                  SkeletonBox(width: 120, height: 12),
                ],
              ),
              const Spacer(),
              SkeletonBox(width: 40, height: 24, borderRadius: 6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendList(BuildContext context, AppState state) {
    return Column(
      children: state.trends.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        return TrendingCard(
          item: item,
          animationDelay: i * 50,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TagDetailScreen(tagName: item.name)),
            );
          },
        );
      }).toList(),
    );
  }
}

class TrendingCard extends StatefulWidget {
  final TrendItem item;
  final int animationDelay;
  final VoidCallback onTap;

  const TrendingCard({
    super.key,
    required this.item,
    required this.animationDelay,
    required this.onTap,
  });

  @override
  State<TrendingCard> createState() => _TrendingCardState();
}

class _TrendingCardState extends State<TrendingCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.animationDelay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _pressed ? const Color(0xFFF0FAFA) : YangjiColors.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_pressed ? 0.08 : 0.04),
                  blurRadius: _pressed ? 12 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Rank
                SizedBox(
                  width: 36,
                  child: Text(
                    '${widget.item.rank}',
                    style: TextStyle(
                      fontSize: widget.item.rank <= 3 ? 22 : 18,
                      fontWeight: FontWeight.w900,
                      color: widget.item.rank <= 3 ? YangjiColors.primary : YangjiColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Tag info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: YangjiColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TagBadge(label: widget.item.category.label, category: widget.item.category, small: true),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '언급량 ${_formatCount(widget.item.mentionCount)}',
                        style: const TextStyle(fontSize: 12, color: YangjiColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                ChangeIndicator(type: widget.item.changeType, value: widget.item.changeValue),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, size: 18, color: YangjiColors.textHint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
