import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme_proposal.dart';
import 'dummy_data.dart';
import 'widgets/widgets.dart';

/// Screen displaying coupons redeemed by the user matching the mockup screenshot.
class MyCouponsScreen extends StatelessWidget {
  final List<DummyRedemption> redemptions;

  const MyCouponsScreen({
    super.key,
    this.redemptions = dummyRedemptions,
  });

  void _copyCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Code copied to clipboard'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF145A32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildCouponCard(BuildContext context, DummyRedemption item) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EDE8), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Icon, Title, Description
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  size: 22,
                  color: const Color(0xFF1B5E3B),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.description,
                      style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // "Redeemed · 20 points" chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              'Redeemed · ${item.points} points',
              style: const TextStyle(
                fontFamily: AppTypography.fontFamily,
                color: Color(0xFF145A32),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Dashed Code Box with Copy button
          CustomPaint(
            painter: const _DashedBorderPainter(
              color: Color(0xFFD4E0D4),
              radius: 14,
              dashWidth: 6,
              dashGap: 4,
              strokeWidth: 1.2,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.code,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF145A32),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _copyCode(context, item.code),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.copy_outlined,
                            size: 18,
                            color: Color(0xFF145A32),
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Copy',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF145A32),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Redemption caption
          Text(
            'Redeemed ${item.dateText} · Demonstration only',
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
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
              color: Color(0xFFE8F5E9),
            ),
            child: const Icon(
              Icons.confirmation_number_outlined,
              color: Color(0xFF145A32),
              size: 26,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No coupons redeemed yet',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Redeem points to unlock rewards and discount vouchers.',
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Back Arrow & Title
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF145A32),
                          size: 26,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/profile');
                          }
                        },
                      ),
                      const SizedBox(width: 14),
                      Text(
                        'My Coupons',
                        style: (textTheme.headlineSmall ?? AppTypography.title).copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Subtitle
                  Text(
                    'A little recognition for your good actions.',
                    style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Info note
                  const InfoNote(
                    text: 'After redemption · Demo reward, not a real offer',
                  ),
                  const SizedBox(height: 20),

                  // Coupons List or Empty State
                  if (redemptions.isEmpty)
                    _buildEmptyState(context)
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: redemptions.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildCouponCard(context, redemptions[index]);
                      },
                    ),
                  const SizedBox(height: 20),

                  // Mint TipBanner: Good actions add up
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5EE),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF145A32).withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Good actions add up',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF145A32),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Continue reporting breeding sites to earn points and explore more sample rewards.',
                          style: TextStyle(
                            fontFamily: AppTypography.fontFamily,
                            fontSize: 14,
                            color: Color(0xFF145A32),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Outlined "Explore Rewards" button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/rewards'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: const Color(0xFF145A32),
                        side: const BorderSide(
                          color: Color(0xFFD0D7D0),
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(
                        Icons.card_giftcard_outlined,
                        size: 22,
                        color: Color(0xFF145A32),
                      ),
                      label: const Text(
                        'Explore Rewards',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF145A32),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
  }
}

/// Custom painter to render a dashed rounded border without dependencies.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;
  final double dashWidth;
  final double dashGap;

  const _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.radius = 14.0,
    this.dashWidth = 6.0,
    this.dashGap = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();

    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        final extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      radius != oldDelegate.radius ||
      dashWidth != oldDelegate.dashWidth ||
      dashGap != oldDelegate.dashGap;
}
