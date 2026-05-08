import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../theme/theme.dart';
import '../widgets/common_widgets.dart';
import 'tag_detail_screen.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YangjiColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
          child: Consumer<AppState>(
            builder: (context, state, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('마이페이지', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: YangjiColors.textPrimary)),
                  const SizedBox(height: 20),
                  _buildProfileCard(context),
                  const SizedBox(height: 20),
                  _buildFavoriteTags(context, state),
                  const SizedBox(height: 20),
                  _buildSettings(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [YangjiColors.primaryDark, YangjiColors.primary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('G', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('게스트 사용자', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('로그인하여 더 많은 기능을 이용하세요', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 12),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('로그인', style: TextStyle(color: YangjiColors.primaryDark, fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteTags(BuildContext context, AppState state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '관심 태그'),
          const SizedBox(height: 12),
          if (state.favoriteTags.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: const Column(
                children: [
                  Icon(Icons.favorite_border, size: 36, color: YangjiColors.textHint),
                  SizedBox(height: 8),
                  Text('관심 태그가 없습니다', style: TextStyle(color: YangjiColors.textSecondary, fontSize: 13)),
                  Text('태그 상세 화면에서 하트를 눌러 저장하세요', style: TextStyle(color: YangjiColors.textHint, fontSize: 12)),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.favoriteTags.map((tag) => GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TagDetailScreen(tagName: tag))),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: YangjiColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: YangjiColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, size: 12, color: YangjiColors.primary),
                      const SizedBox(width: 4),
                      Text(tag, style: const TextStyle(color: YangjiColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              )).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context) {
    final items = [
      ('알림 설정', Icons.notifications_outlined),
      ('다크모드', Icons.dark_mode_outlined),
      ('언어 설정', Icons.language_outlined),
      ('앱 정보', Icons.info_outlined),
    ];
    return Container(
      decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Icon(e.value.$2, color: YangjiColors.primaryDark, size: 22),
                title: Text(e.value.$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                trailing: const Icon(Icons.chevron_right, size: 18, color: YangjiColors.textSecondary),
                onTap: () {},
              ),
              if (!isLast) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}
