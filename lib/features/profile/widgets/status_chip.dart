import 'package:flutter/material.dart';

import '../../../app/theme_proposal.dart';

/// Available status chip types with associated visual palettes.
enum StatusChipType {
  pending,
  reviewed,
  needsDetail;

  /// Helper parser for dynamic or backend status strings
  static StatusChipType fromString(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('pending')) return StatusChipType.pending;
    if (lower.contains('reviewed') || lower.contains('approved') || lower.contains('valid')) {
      return StatusChipType.reviewed;
    }
    if (lower.contains('detail') || lower.contains('rejected') || lower.contains('error') || lower.contains('needs')) {
      return StatusChipType.needsDetail;
    }
    return StatusChipType.pending;
  }
}

/// A pill badge displaying state for reports or activities.
/// - pending: orange background and text
/// - reviewed: green background and text
/// - needsDetail: red background and text
class StatusChip extends StatelessWidget {
  final String text;
  final StatusChipType type;

  const StatusChip({
    super.key,
    required this.text,
    required this.type,
  });

  /// Factory constructor to construct a chip directly from a status string
  factory StatusChip.fromStatus({
    Key? key,
    required String text,
    required String status,
  }) {
    return StatusChip(
      key: key,
      text: text,
      type: StatusChipType.fromString(status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;

    switch (type) {
      case StatusChipType.pending:
        bgColor = AppColors.warningBg;
        textColor = AppColors.warningText;
        break;
      case StatusChipType.reviewed:
        bgColor = AppColors.primaryLight;
        textColor = AppColors.primaryDark;
        break;
      case StatusChipType.needsDetail:
        bgColor = AppColors.errorBg;
        textColor = AppColors.errorText;
        break;
    }

    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: (textTheme.labelSmall ?? AppTypography.caption).copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
