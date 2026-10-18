import 'package:flutter/material.dart';

import '../../../app/theme_proposal.dart';

/// A dark green card with large point counter and decorative faint leaf accent.
/// Used on Profile ("YOUR POINTS") and Rewards ("YOUR BALANCE").
class PointsCard extends StatelessWidget {
  final String label;
  final int points;
  final String caption;

  const PointsCard({
    super.key,
    required this.label,
    required this.points,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF145A32),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Richer green circular accent and tilted leaf on the right
          Positioned(
            top: -45,
            right: -45,
            child: Container(
              width: 230,
              height: 230,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1E7544),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: -0.25,
                  child: Icon(
                    Icons.eco_outlined,
                    size: 88,
                    color: const Color(0xFF81C784).withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Small uppercase label
                Text(
                  label.toUpperCase(),
                  style: (textTheme.labelSmall ?? AppTypography.caption).copyWith(
                    color: AppColors.surface.withValues(alpha: 0.75),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),

                // Big points number + "points" suffix
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Flexible(
                      child: Text(
                        '$points',
                        style: (textTheme.displayLarge ?? AppTypography.pointsBig).copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'points',
                      style: (textTheme.bodyLarge ?? AppTypography.body).copyWith(
                        color: AppColors.surface.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Caption
                Text(
                  caption,
                  style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                    color: AppColors.surface.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
