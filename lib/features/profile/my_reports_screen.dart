import 'package:flutter/material.dart';

import '../../app/theme_proposal.dart';
import 'dummy_data.dart';
import 'widgets/widgets.dart';

/// Screen displaying submitted dengue breeding site reports with filter options.
/// Matches Figma / Mockup Image 5 ("My Reports").
class MyReportsScreen extends StatefulWidget {
  final List<DummyReport> reports;

  const MyReportsScreen({
    super.key,
    this.reports = dummyReports,
  });

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'all'; // 'all' | 'in_progress'

  List<DummyReport> get _filteredReports {
    if (_selectedFilter == 'in_progress') {
      return widget.reports.where((r) => r.isInProgress).toList();
    }
    return widget.reports;
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;

    return InkWell(
      onTap: () => setState(() => _selectedFilter = value),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, DummyReport report) {
    final textTheme = Theme.of(context).textTheme;
    final isPositivePoints = report.pointsText?.startsWith('+') ?? false;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 68,
              height: 68,
              color: AppColors.primaryLight,
              child: report.imageUrl != null
                  ? Image.network(
                      report.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_outlined,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    )
                  : const Icon(
                      Icons.image_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Details column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Status Chip
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        report.type,
                        style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    StatusChip.fromStatus(
                      text: report.status,
                      status: report.status,
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Location
                Text(
                  report.location,
                  style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),

                // Date
                Text(
                  report.dateText,
                  style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),

                // Bottom row: AI Note + Points
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        report.aiNote ?? 'AI: Queued for validation.',
                        style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      report.pointsText ?? 'Not awarded yet',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPositivePoints
                            ? AppColors.primaryDark
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
            ),
            child: const Icon(
              Icons.assignment_outlined,
              color: AppColors.primaryDark,
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No reports found',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'No reports match the selected filter.',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final filtered = _filteredReports;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with back arrow if navigator can pop
              if (Navigator.of(context).canPop()) ...[
                InkWell(
                  onTap: () => Navigator.of(context).maybePop(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Screen Title
              Text(
                'My Reports',
                style: (textTheme.headlineSmall ?? AppTypography.title).copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Follow your reports from upload to validation.',
                style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),

              // Sub-text
              Text(
                '${widget.reports.length} sample reports · Fictional locations',
                style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Row(
                children: [
                  _buildFilterChip('All reports', 'all'),
                  const SizedBox(width: 10),
                  _buildFilterChip('In progress', 'in_progress'),
                ],
              ),
              const SizedBox(height: 18),

              // Report Cards or Empty State
              if (filtered.isEmpty)
                _buildEmptyState(context)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildReportCard(context, filtered[index]);
                  },
                ),
              const SizedBox(height: 20),

              // Footnote
              Center(
                child: Text(
                  'Only valid reports earn 10 points and appear on the map.',
                  textAlign: TextAlign.center,
                  style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
