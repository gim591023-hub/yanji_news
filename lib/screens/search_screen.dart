import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../services/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/common_widgets.dart';
import 'tag_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _controller.addListener(() {
      final q = _controller.text;
      setState(() {
        _suggestions = MockDataService.getSearchSuggestions(q);
        _showSuggestions = q.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;
    context.read<AppState>().addRecentSearch(query);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TagDetailScreen(tagName: query)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YangjiColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: _showSuggestions ? _buildSuggestions() : _buildDefaultContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      color: YangjiColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: YangjiColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: YangjiColors.primary.withOpacity(0.4)),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: _search,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '키워드를 검색하세요',
                  hintStyle: const TextStyle(color: YangjiColors.textHint, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: YangjiColors.primary, size: 20),
                  suffixIcon: _controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () => _controller.clear(),
                        child: const Icon(Icons.close, size: 18, color: YangjiColors.textSecondary),
                      )
                    : null,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _search(_controller.text),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: YangjiColors.primary, borderRadius: BorderRadius.circular(12)),
              child: const Text('검색', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _suggestions.map((s) => GestureDetector(
        onTap: () => _search(s),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 16, color: YangjiColors.textSecondary),
              const SizedBox(width: 10),
              Expanded(child: Text(s, style: const TextStyle(fontSize: 15))),
              const Icon(Icons.north_west, size: 14, color: YangjiColors.textSecondary),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildDefaultContent() {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.recentSearches.isNotEmpty) ...[
              _buildSectionTitle('최근 검색어', onClear: () {}),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: state.recentSearches.map((s) => GestureDetector(
                  onTap: () => _search(s),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: YangjiColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(s, style: const TextStyle(fontSize: 13, color: YangjiColors.textPrimary)),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => state.removeRecentSearch(s),
                          child: const Icon(Icons.close, size: 14, color: YangjiColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 28),
            ],
            _buildSectionTitle('인기 검색어'),
            const SizedBox(height: 12),
            ...MockDataService.getPopularSearches().asMap().entries.map((e) => GestureDetector(
              onTap: () => _search(e.value),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 0),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${e.key + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: e.key < 3 ? YangjiColors.primary : YangjiColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(e.value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    ),
                    const Icon(Icons.trending_up, size: 16, color: YangjiColors.up),
                  ],
                ),
              ),
            )),
          ],
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onClear}) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: YangjiColors.textPrimary)),
        if (onClear != null) ...[
          const Spacer(),
          GestureDetector(
            onTap: onClear,
            child: const Text('전체삭제', style: TextStyle(fontSize: 12, color: YangjiColors.textSecondary)),
          ),
        ],
      ],
    );
  }
}
