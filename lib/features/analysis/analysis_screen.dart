import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme_proposal.dart';
import '../profile/widgets/info_note.dart';
import '../profile/widgets/tip_banner.dart';

/// Data model representing district-level dengue statistics and trend.
class DistrictAnalysis {
  final String name;
  final int cases;
  final List<int> weeklyCases;
  final String trendSummary;

  const DistrictAnalysis({
    required this.name,
    required this.cases,
    required this.weeklyCases,
    required this.trendSummary,
  });
}

const List<DistrictAnalysis> _districtRankings = [
  DistrictAnalysis(
    name: 'Colombo',
    cases: 120,
    weeklyCases: [0, 24, 12, 60, 95, 120],
    trendSummary:
        'Demo trend rises in recent weeks. A rise in cases can signal a need for extra prevention; it does not predict individual risk.',
  ),
  DistrictAnalysis(
    name: 'Gampaha',
    cases: 104,
    weeklyCases: [12, 20, 30, 48, 76, 104],
    trendSummary:
        'Urban areas report an increase in high-risk containers. Weekly inspections are highly recommended.',
  ),
  DistrictAnalysis(
    name: 'Kalutara',
    cases: 88,
    weeklyCases: [8, 14, 25, 42, 64, 88],
    trendSummary:
        'Coastal rainfall patterns correlate with slight increases in mosquito breeding sites.',
  ),
  DistrictAnalysis(
    name: 'Kandy',
    cases: 72,
    weeklyCases: [14, 18, 26, 38, 52, 72],
    trendSummary:
        'Moderate case numbers across central valleys. Maintain clean gutters and roof drainage.',
  ),
  DistrictAnalysis(
    name: 'Galle',
    cases: 65,
    weeklyCases: [10, 16, 22, 34, 48, 65],
    trendSummary:
        'Southern coastal districts continue routine larviciding and public awareness drives.',
  ),
  DistrictAnalysis(
    name: 'Ratnapura',
    cases: 54,
    weeklyCases: [8, 12, 18, 28, 40, 54],
    trendSummary:
        'Gem pit and agricultural areas require special attention to prevent stagnant water pooling.',
  ),
  DistrictAnalysis(
    name: 'Kurunegala',
    cases: 48,
    weeklyCases: [6, 10, 15, 24, 35, 48],
    trendSummary:
        'Coconut plantation water storage containers monitored for mosquito larvae.',
  ),
  DistrictAnalysis(
    name: 'Matara',
    cases: 40,
    weeklyCases: [5, 9, 14, 20, 30, 40],
    trendSummary:
        'Low to moderate numbers reported across residential suburban zones.',
  ),
  DistrictAnalysis(
    name: 'Jaffna',
    cases: 35,
    weeklyCases: [4, 7, 11, 18, 25, 35],
    trendSummary:
        'Consistent water storage monitoring keeps breeding indices low.',
  ),
  DistrictAnalysis(
    name: 'Badulla',
    cases: 28,
    weeklyCases: [3, 6, 9, 14, 20, 28],
    trendSummary:
        'High elevation zones show low overall vector density.',
  ),
];

/// Dengue Analysis screen displaying epidemiological trends and district rankings.
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  DistrictAnalysis _selectedDistrict = _districtRankings.first;

  void _showDistrictPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select District',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _districtRankings.length,
                    itemBuilder: (context, index) {
                      final item = _districtRankings[index];
                      final isSelected = item.name == _selectedDistrict.name;
                      return ListTile(
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        title: Text(
                          '${item.name} · Demo',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.textPrimary,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check, color: AppColors.primary)
                            : Text(
                                '${item.cases} cases',
                                style: const TextStyle(
                                  fontFamily: AppTypography.fontFamily,
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                        onTap: () {
                          setState(() {
                            _selectedDistrict = item;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Back Arrow Button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                      size: 26,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Dengue Analysis',
                      style: (textTheme.headlineMedium ?? AppTypography.title)
                          .copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Understand patterns. Stay prepared.',
                style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),

              // Disclaimer Note
              const InfoNote(
                text:
                    'Placeholder charts · Not verified Sri Lankan statistics · Scroll for all insights',
              ),
              const SizedBox(height: 20),

              // District Dropdown Selector
              InkWell(
                onTap: _showDistrictPicker,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${_selectedDistrict.name} · Demo',
                        style: (textTheme.bodyLarge ?? AppTypography.body)
                            .copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Card 1: Weekly Dengue Cases
              _WeeklyCasesCard(district: _selectedDistrict),
              const SizedBox(height: 20),

              // Card 2: Top 10 Districts
              _TopDistrictsCard(
                districts: _districtRankings,
                selectedDistrict: _selectedDistrict,
              ),
              const SizedBox(height: 20),

              // Prevention Tip Banner
              const TipBanner(
                text:
                    'Prevention insight: Eliminating stagnant water weekly breaks the 7-day Aedes mosquito breeding cycle. Stay protected during peak biting hours.',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card presenting the 6-week dengue case trend line chart.
class _WeeklyCasesCard extends StatelessWidget {
  final DistrictAnalysis district;

  const _WeeklyCasesCard({required this.district});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Weekly dengue cases',
            style: (textTheme.titleLarge ?? AppTypography.heading).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'Illustrative 6-week trend · Sample case counts',
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 22),

          // Line Chart
          SizedBox(
            height: 160,
            width: double.infinity,
            child: _TrendLineChart(dataPoints: district.weeklyCases),
          ),
          const SizedBox(height: 18),

          // Trend interpretation caption
          Text(
            district.trendSummary,
            style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the 6-week case trend line chart with gridlines and points.
class _TrendLineChart extends StatelessWidget {
  final List<int> dataPoints;

  const _TrendLineChart({required this.dataPoints});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrendChartPainter(dataPoints: dataPoints),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  final List<int> dataPoints;

  _TrendChartPainter({required this.dataPoints});

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPadding = 36.0;
    const double bottomPadding = 24.0;
    final double chartWidth = size.width - leftPadding - 10.0;
    final double chartHeight = size.height - bottomPadding;

    const int maxVal = 120;
    final yLabels = [120, 60, 0];
    final xLabels = ['W1', 'W2', 'W3', 'W4', 'W5', 'W6'];

    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.9)
      ..strokeWidth = 1.0;

    final textStyle = const TextStyle(
      fontFamily: AppTypography.fontFamily,
      fontSize: 12,
      color: AppColors.textSecondary,
    );

    // Draw Y-axis labels and horizontal grid lines
    for (final val in yLabels) {
      final y = chartHeight - (val / maxVal * chartHeight);

      // Label text
      final textPainter = TextPainter(
        text: TextSpan(text: '$val', style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 10, y - textPainter.height / 2),
      );

      // Grid line
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - 6, y),
        gridPaint,
      );
    }

    if (dataPoints.isEmpty) return;

    final stepX = chartWidth / (dataPoints.length - 1);
    final points = <Offset>[];

    // Compute coordinate points
    for (int i = 0; i < dataPoints.length; i++) {
      final x = leftPadding + (i * stepX);
      final normalizedY = (dataPoints[i].clamp(0, maxVal) / maxVal) * chartHeight;
      final y = chartHeight - normalizedY;
      points.add(Offset(x, y));

      // Draw X label (W1..W6)
      if (i < xLabels.length) {
        final xTextPainter = TextPainter(
          text: TextSpan(text: xLabels[i], style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        xTextPainter.paint(
          canvas,
          Offset(x - (xTextPainter.width / 2), chartHeight + 8),
        );
      }
    }

    // Draw connecting green line
    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, linePaint);

    // Draw nodes with green outer ring and white inner center
    final nodeOuterPaint = Paint()
      ..color = AppColors.primaryDark
      ..style = PaintingStyle.fill;

    final nodeInnerPaint = Paint()
      ..color = AppColors.surface
      ..style = PaintingStyle.fill;

    for (final pt in points) {
      canvas.drawCircle(pt, 5.0, nodeOuterPaint);
      canvas.drawCircle(pt, 2.5, nodeInnerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints;
  }
}

/// Card presenting horizontal bar chart ranking for top 10 districts.
class _TopDistrictsCard extends StatelessWidget {
  final List<DistrictAnalysis> districts;
  final DistrictAnalysis selectedDistrict;

  const _TopDistrictsCard({
    required this.districts,
    required this.selectedDistrict,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final maxCases = districts.map((d) => d.cases).fold<int>(1, (a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Top 10 districts',
            style: (textTheme.titleLarge ?? AppTypography.heading).copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          Text(
            'Placeholder ranking · Sample case counts',
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 18),

          // District List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: districts.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final district = districts[index];
              final isSelected = district.name == selectedDistrict.name;
              final fraction = (district.cases / maxCases).clamp(0.05, 1.0);

              return Row(
                children: [
                  // District name
                  SizedBox(
                    width: 90,
                    child: Text(
                      district.name,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Horizontal Bar with background track
                  Expanded(
                    child: Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: fraction,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Case count
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${district.cases}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
