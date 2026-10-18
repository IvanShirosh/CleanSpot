import 'package:flutter/material.dart';

import '../../../app/theme_proposal.dart';
import '../../profile/dummy_data.dart';
import '../../profile/widgets/widgets.dart';
import 'coupon_dialog.dart';
import 'widgets/coupon_card.dart';

/// Reward Shop screen displaying available coupons, user point balance,
/// and redemption options matching the Figma mockup.
class RewardShopScreen extends StatefulWidget {
  final List<DummyCoupon> coupons;
  final int initialPoints;
  final ValueChanged<DummyCoupon>? onRedeem;

  const RewardShopScreen({
    super.key,
    this.coupons = dummyCoupons,
    this.initialPoints = 120,
    this.onRedeem,
  });

  @override
  State<RewardShopScreen> createState() => _RewardShopScreenState();
}

class _RewardShopScreenState extends State<RewardShopScreen> {
  late int _points;

  @override
  void initState() {
    super.initState();
    _points = widget.initialPoints;
  }

  void _handleRedeem(BuildContext context, DummyCoupon coupon) {
    if (_points < coupon.cost) return;

    if (widget.onRedeem != null) {
      widget.onRedeem!(coupon);
    } else {
      showCouponDialog(context, title: coupon.title, code: coupon.code);
      setState(() {
        _points -= coupon.cost;
      });
    }
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
              // Screen Title & Subtitle
              Text(
                'Rewards',
                style: (textTheme.headlineMedium ?? AppTypography.title).copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Good actions deserve recognition.',
                style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),

              // Points Card (YOUR BALANCE)
              PointsCard(
                label: 'YOUR BALANCE',
                points: _points,
                caption: 'Keep making a difference.',
              ),
              const SizedBox(height: 24),

              // Section Heading
              Text(
                'Redeem your points',
                style: (textTheme.titleLarge ?? AppTypography.heading).copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 6),

              // Info note
              const InfoNote(
                text: 'Demo rewards, not real merchant offers',
              ),
              const SizedBox(height: 8),

              // Rewards count
              Text(
                '${widget.coupons.length} rewards available · Scroll to explore all',
                style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),

              // 2-Column GridView of CouponCard widgets
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.coupons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final coupon = widget.coupons[index];
                  return CouponCard(
                    coupon: coupon,
                    userPoints: _points,
                    onRedeem: () => _handleRedeem(context, coupon),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
