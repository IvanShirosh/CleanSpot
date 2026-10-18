import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme_proposal.dart';
import 'dummy_data.dart';
import 'widgets/widgets.dart';

/// CleanSpot Profile screen displaying active user stats, menu options,
/// and authentication actions.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  Future<void> _showSignOutDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (ctx) {
        final textTheme = Theme.of(ctx).textTheme;

        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: AppColors.border, width: 1),
          ),
          title: Text(
            'Sign Out',
            style: (textTheme.titleLarge ?? AppTypography.heading).copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out?',
            style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: (textTheme.labelLarge ?? AppTypography.body).copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // TODO: Manuja's auth hook (e.g. FirebaseAuth.instance.signOut())
              },
              child: Text(
                'Sign out',
                style: (textTheme.labelLarge ?? AppTypography.body).copyWith(
                  color: AppColors.errorText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final initials = _getInitials(dummyUser.name);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              Text(
                'Profile',
                style: (textTheme.headlineMedium ?? AppTypography.title).copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Centered Avatar & Info
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.primaryLight,
                      backgroundImage: dummyUser.photoUrl != null &&
                              dummyUser.photoUrl!.isNotEmpty
                          ? NetworkImage(dummyUser.photoUrl!)
                          : null,
                      child: dummyUser.photoUrl == null ||
                              dummyUser.photoUrl!.isEmpty
                          ? Text(
                              initials,
                              style: (textTheme.titleLarge ?? AppTypography.heading).copyWith(
                                color: AppColors.primaryDark,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      dummyUser.name,
                      style: (textTheme.titleLarge ?? AppTypography.heading).copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dummyUser.email,
                      style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Points Card
              PointsCard(
                label: 'YOUR POINTS',
                points: dummyUser.points,
                caption: 'Earn more by reporting breeding sites.',
              ),
              const SizedBox(height: 20),

              // Navigation Tiles
              MenuTile(
                icon: Icons.assignment_outlined,
                title: 'My Reports',
                subtitle: 'Track your submitted reports',
                onTap: () => context.push('/profile/reports'),
              ),
              const SizedBox(height: 12),
              MenuTile(
                icon: Icons.confirmation_number_outlined,
                title: 'My Coupons',
                subtitle: 'View your redeemed rewards',
                onTap: () => context.push('/profile/coupons'),
              ),
              const SizedBox(height: 12),
              MenuTile(
                icon: Icons.analytics_outlined,
                title: 'Dengue Analysis',
                subtitle: 'Weekly trends & district statistics',
                onTap: () => context.push('/analysis'),
              ),
              const SizedBox(height: 12),
              MenuTile(
                icon: Icons.health_and_safety_outlined,
                title: 'Symptom Checker',
                subtitle: 'Clinical guide & risk self-check',
                onTap: () => context.push('/symptoms'),
              ),
              const SizedBox(height: 28),

              // Sign Out Button
              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _showSignOutDialog(context),
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text('Sign Out'),
                ),
              ),
              const SizedBox(height: 12),

              // Demo User Note
              Center(
                child: Text(
                  'Fictional demonstration user',
                  style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
