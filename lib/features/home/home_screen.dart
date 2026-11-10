import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme_proposal.dart';
import '../profile/current_user.dart';
import '../profile/dummy_data.dart';
import '../profile/widgets/widgets.dart';

/// CleanSpot Home Dashboard screen matching Figma Page 3.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = CurrentUser.fromAuth();
    final firstName = user.firstName;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Greeting & Avatar Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello, $firstName',
                          style: (textTheme.headlineSmall ?? AppTypography.title).copyWith(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'A small action can protect a whole street.',
                          style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User Avatar
                  InkWell(
                    onTap: () => context.go('/profile'),
                    borderRadius: BorderRadius.circular(24),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: user.photoUrl != null &&
                              user.photoUrl!.isNotEmpty
                          ? NetworkImage(user.photoUrl!)
                          : null,
                      child: user.photoUrl == null ||
                              user.photoUrl!.isEmpty
                          ? Text(
                              user.initials,
                              style: const TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDark,
                                fontSize: 16,
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Info Note
              const InfoNote(
                text: 'Demo community · Scroll for more',
              ),
              const SizedBox(height: 18),

              // Mint Points Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        UserPoints(
                          builder: (context, points) => Text(
                            '$points',
                            style: (textTheme.displayLarge ?? AppTypography.pointsBig).copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'points earned',
                          style: (textTheme.bodyLarge ?? AppTypography.body).copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.spa_outlined,
                          color: AppColors.primaryDark,
                          size: 26,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Every report helps your community.',
                      style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Big "Report a Breeding Site" Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/report'),
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                  label: const Text(
                    'Report a Breeding Site',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Two Quick Action Cards: Risk Map & Rewards
              Row(
                children: [
                  // Risk Map Card
                  Expanded(
                    child: InkWell(
                      onTap: () => context.go('/map'),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.map_outlined,
                              color: AppColors.primary,
                              size: 26,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Risk Map',
                              style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Explore nearby',
                              style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Rewards Card
                  Expanded(
                    child: InkWell(
                      onTap: () => context.go('/rewards'),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.card_giftcard_outlined,
                              color: AppColors.primary,
                              size: 26,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Rewards',
                              style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Use your points',
                              style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Seasonal Reminder Card: "After rain, take a look around"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.umbrella_outlined,
                          color: AppColors.warningText,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'After rain, take a look around',
                            style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check plant pots, tyres and drains for standing water. Demo seasonal reminder.',
                      style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Reports Section
              Text(
                'Recent reports',
                style: (textTheme.titleLarge ?? AppTypography.heading).copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),

              // Recent Report Card (Stagnant water)
              InkWell(
                onTap: () => context.push('/profile/reports'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              dummyReports.first.type,
                              style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          StatusChip.fromStatus(
                            text: dummyReports.first.status,
                            status: dummyReports.first.status,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dummyReports.first.location,
                        style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dummyReports.first.dateText,
                        style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
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
