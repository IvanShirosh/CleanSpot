import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme_proposal.dart';
import 'report_photo.dart';

/// "AI is Checking Your Report" screen (Figma: AI Verification).
/// Demo only: shows a fixed 65% state, then moves on to the approved result.
class ReportVerificationScreen extends StatefulWidget {
  const ReportVerificationScreen({super.key, this.photoUrl});

  final String? photoUrl;

  @override
  State<ReportVerificationScreen> createState() =>
      _ReportVerificationScreenState();
}

class _ReportVerificationScreenState extends State<ReportVerificationScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // TODO: replace with the real AI verification result.
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) context.go('/report/result', extra: widget.photoUrl);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'REPORT VALIDATION',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'AI is Checking Your Report',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "We're checking your image for a possible mosquito breeding "
                'site.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              ReportPhoto(url: widget.photoUrl, height: 230, showScanFrame: true),
              const SizedBox(height: 6),
              const Row(
                children: [
                  Icon(Icons.location_on, size: 14, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'Sample campus garden · 13 Oct, 9:41 AM',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Analyzing site details',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '65%',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 8,
                        backgroundColor: AppColors.primaryLight,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const _Step(Icons.check_circle_outline, 'Photo received'),
                    const _Step(
                      Icons.center_focus_strong_outlined,
                      'Checking for standing water',
                    ),
                    const _Step(
                      Icons.schedule,
                      'Checking for duplicate reports',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: AppColors.primaryDark,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Each valid report earns 10 points. Your balance '
                        'updates after verification.',
                        style: TextStyle(color: AppColors.primaryDark),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Illustrative checking state · Balance: 120 points',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

class _Step extends StatelessWidget {
  const _Step(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryDark),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
