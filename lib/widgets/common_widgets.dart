import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/theme.dart';
import '../models/models.dart';

// ─── Search Bar ───────────────────────────────────────────────────────────────
class YangjiSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final String placeholder;

  const YangjiSearchBar({
    super.key,
    required this.controller,
    required this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.placeholder = '키워드를 검색하세요',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: YangjiColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: YangjiColors.textPrimary),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(color: YangjiColors.textHint, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: YangjiColors.primary, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

// ─── Tag Badge ────────────────────────────────────────────────────────────────
class TagBadge extends StatelessWidget {
  final String label;
  final TagCategory? category;
  final bool small;
  final VoidCallback? onTap;

  const TagBadge({
    super.key,
    required this.label,
    this.category,
    this.small = false,
    this.onTap,
  });

  Color get _color {
    switch (category) {
      case TagCategory.politics: return YangjiColors.politics;
      case TagCategory.economy: return YangjiColors.economy;
      case TagCategory.diplomacy: return YangjiColors.diplomacy;
      case TagCategory.society: return YangjiColors.society;
      default: return YangjiColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: small ? 8 : 10,
          vertical: small ? 3 : 5,
        ),
        decoration: BoxDecoration(
          color: _color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: small ? 11 : 12,
            fontWeight: FontWeight.w600,
            color: _color,
          ),
        ),
      ),
    );
  }
}

// ─── Change Indicator ─────────────────────────────────────────────────────────
class ChangeIndicator extends StatelessWidget {
  final ChangeType type;
  final int value;

  const ChangeIndicator({super.key, required this.type, required this.value});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;
    switch (type) {
      case ChangeType.up:
        color = YangjiColors.up;
        text = '▲$value';
        break;
      case ChangeType.down:
        color = YangjiColors.down;
        text = '▼$value';
        break;
      case ChangeType.newTag:
        color = YangjiColors.newTag;
        text = 'NEW';
        break;
      case ChangeType.same:
        color = YangjiColors.neutral;
        text = '-';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

// ─── Skeleton Loader ──────────────────────────────────────────────────────────
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: 13,
                color: YangjiColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Platform Filter ──────────────────────────────────────────────────────────
class PlatformFilter extends StatelessWidget {
  final Platform selected;
  final ValueChanged<Platform> onChanged;

  const PlatformFilter({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: Platform.values.map((p) {
        final isSelected = p == selected;
        final label = p == Platform.google ? 'Google' : p == Platform.naver ? 'Naver' : '통합';
        return GestureDetector(
          onTap: () => onChanged(p),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? YangjiColors.primary : YangjiColors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: YangjiColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : YangjiColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Sentiment Badge ──────────────────────────────────────────────────────────
class SentimentBadge extends StatelessWidget {
  final Sentiment sentiment;

  const SentimentBadge({super.key, required this.sentiment});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    switch (sentiment) {
      case Sentiment.positive:
        label = '긍정적';
        color = YangjiColors.newTag;
        break;
      case Sentiment.negative:
        label = '부정적';
        color = YangjiColors.up;
        break;
      case Sentiment.neutral:
        label = '중립';
        color = YangjiColors.neutral;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
