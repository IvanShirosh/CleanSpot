import 'package:flutter/material.dart';

import '../../../app/theme_proposal.dart';

/// A rounded mint-colored container displaying seasonal prevention advice, tips, or guidelines.
class TipBanner extends StatelessWidget {
  final String? title;
  final String text;

  const TipBanner({
    super.key,
    this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final hasTitle = title != null && title!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasTitle) ...[
            Text(
              title!,
              style: (textTheme.titleSmall ?? AppTypography.heading).copyWith(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text(
            text,
            style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
              fontSize: 13,
              color: AppColors.primaryDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
