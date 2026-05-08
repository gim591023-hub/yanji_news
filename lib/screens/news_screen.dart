import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/theme.dart';
import '../widgets/common_widgets.dart';
import 'tag_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  final String tagName;
  final List<NewsArticle> articles;

  const NewsScreen({super.key, required this.tagName, required this.articles});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final _controller = TextEditingController();

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inHours < 1) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YangjiColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: YangjiColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: YangjiColors.background, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.arrow_back_ios_new, size: 16, color: YangjiColors.primaryDark),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${widget.tagName} 관련 뉴스',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: YangjiColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                itemCount: widget.articles.length,
                itemBuilder: (context, index) {
                  final article = widget.articles[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: YangjiColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(16),
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
                                    child: Text(
                                      article.source,
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: YangjiColors.primaryDark),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _timeAgo(article.publishedAt),
                                    style: const TextStyle(fontSize: 11, color: YangjiColors.textSecondary),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                article.title,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      spacing: 4,
                                      children: article.tags.map((t) => GestureDetector(
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => TagDetailScreen(tagName: t)),
                                        ),
                                        child: TagBadge(label: '#$t', small: true),
                                      )).toList(),
                                    ),
                                  ),
                                  const Icon(Icons.open_in_new, size: 16, color: YangjiColors.textHint),
                                ],
                              ),
                            ],
                          ),
                        ),
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
}
