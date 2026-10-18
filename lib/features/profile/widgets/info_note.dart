import 'package:flutter/material.dart';

import '../../../app/theme_proposal.dart';

/// A subtle secondary row presenting hints, disclaimers, or metadata with an icon.
class InfoNote extends StatelessWidget {
  final String text;
  final IconData icon;

  const InfoNote({
    super.key,
    required this.text,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 15,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
