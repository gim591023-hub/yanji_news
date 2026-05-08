import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import '../services/mock_data.dart';
import '../theme/theme.dart';
import '../widgets/common_widgets.dart';
import 'tag_detail_screen.dart';

class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen({super.key});

  @override
  State<VisualizationScreen> createState() => _VisualizationScreenState();
}

class _VisualizationScreenState extends State<VisualizationScreen> {
  String _period = '1개월';
  List<String> _compareTags = ['트럼프'];
  final _periods = ['7일', '1개월', '3개월', '6개월', '1년'];

  final _availableTags = ['트럼프', '이재명', '반도체', '금리인하', '한미동맹', '부동산', 'AI규제'];

  List<FlSpot> _mockSpots(int seed, int count) {
    return List.generate(count, (i) {
      final base = (seed * 100 + i * 20 + (i % 4 == 0 ? 80 : 0)).toDouble();
      return FlSpot(i.toDouble(), base.clamp(0, 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YangjiColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('데이터 시각화', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: YangjiColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('태그별 언급량 추이 비교', style: TextStyle(fontSize: 13, color: YangjiColors.textSecondary)),
              const SizedBox(height: 20),
              _buildPeriodFilter(),
              const SizedBox(height: 20),
              _buildCompareChart(),
              const SizedBox(height: 20),
              _buildTagSelector(),
              const SizedBox(height: 20),
              _buildCategoryPieChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodFilter() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _periods.map((p) {
          final sel = p == _period;
          return GestureDetector(
            onTap: () => setState(() => _period = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: sel ? YangjiColors.primary : YangjiColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: sel ? [BoxShadow(color: YangjiColors.primary.withOpacity(0.3), blurRadius: 8)] : null,
              ),
              child: Text(
                p,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: sel ? Colors.white : YangjiColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompareChart() {
    final colors = [YangjiColors.primary, YangjiColors.up, YangjiColors.economy, YangjiColors.diplomacy, YangjiColors.society];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '언급량 비교 그래프'),
          const SizedBox(height: 16),
          Row(
            children: _compareTags.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Row(
                children: [
                  Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[e.key % colors.length], borderRadius: BorderRadius.circular(3))),
                  const SizedBox(width: 4),
                  Text(e.value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (v) => FlLine(color: YangjiColors.background, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: _compareTags.asMap().entries.map((e) {
                  final color = colors[e.key % colors.length];
                  return LineChartBarData(
                    spots: _mockSpots(e.key + 1, 30),
                    isCurved: true,
                    color: color,
                    barWidth: 2,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withOpacity(0.08),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagSelector() {
    final colors = [YangjiColors.primary, YangjiColors.up, YangjiColors.economy, YangjiColors.diplomacy, YangjiColors.society];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '비교 태그 선택'),
          const SizedBox(height: 12),
          const Text('최대 3개까지 선택 가능', style: TextStyle(fontSize: 12, color: YangjiColors.textSecondary)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final selected = _compareTags.contains(tag);
              final idx = _compareTags.indexOf(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selected) {
                      if (_compareTags.length > 1) _compareTags.remove(tag);
                    } else if (_compareTags.length < 3) {
                      _compareTags.add(tag);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? colors[idx % colors.length].withOpacity(0.12) : YangjiColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? colors[idx % colors.length] : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? colors[idx % colors.length] : YangjiColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPieChart() {
    final sections = [
      PieChartSectionData(value: 38, color: YangjiColors.politics, title: '정치\n38%', radius: 80, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      PieChartSectionData(value: 31, color: YangjiColors.economy, title: '경제\n31%', radius: 80, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      PieChartSectionData(value: 18, color: YangjiColors.diplomacy, title: '외교\n18%', radius: 80, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
      PieChartSectionData(value: 13, color: YangjiColors.society, title: '사회\n13%', radius: 80, titleStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: YangjiColors.surface, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: '카테고리 분포'),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
