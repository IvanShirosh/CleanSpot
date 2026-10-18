// lib/features/symptoms/symptom_result_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'symptom_questions.dart';
 
enum RiskLevel { high, medium, low }
 
class SymptomResultScreen extends StatelessWidget {
  final RiskLevel level;
  final VoidCallback onRestart;
 
  const SymptomResultScreen({
    super.key,
    required this.level,
    required this.onRestart,
  });
 
  // Illustrative wording - not clinically approved.
  String get _title => switch (level) {
        RiskLevel.high => 'High Risk',
        RiskLevel.medium => 'Medium Risk',
        RiskLevel.low => 'Low Risk',
      };
 
  String get _advice => switch (level) {
        RiskLevel.high => 'Go to a hospital now.',
        RiskLevel.medium => 'See a doctor and get a blood test.',
        RiskLevel.low => 'Rest, drink fluids, monitor.',
      };
 
  String get _message => switch (level) {
        RiskLevel.high =>
          'A warning sign was reported. Please seek urgent medical assessment.',
        RiskLevel.medium =>
          "Your answers meet the application's medium-risk criteria. "
              'Please seek medical advice and follow the recommended '
              'clinical assessment.',
        RiskLevel.low =>
          "Your answers do not meet the application's high- or medium-risk "
              'criteria. This does not rule out dengue. Monitor your '
              'symptoms and seek medical advice if you are concerned or '
              'your condition worsens.',
      };
 
  Color get _riskColor => switch (level) {
        RiskLevel.high => AppColors.riskHigh,
        RiskLevel.medium => AppColors.riskMedium,
        RiskLevel.low => AppColors.riskLow,
      };
 
  IconData get _icon => switch (level) {
        RiskLevel.high => Icons.error,
        RiskLevel.medium => Icons.warning_amber_rounded,
        RiskLevel.low => Icons.check_circle,
      };
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Result',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.heading,
                ),
              ),
              const SizedBox(height: 16),
              // Result / alert card (sage green) with risk colour accent.
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.alertCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: _riskColor, width: 8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_icon, color: _riskColor, size: 34),
                        const SizedBox(width: 10),
                        Text(
                          _title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.heading,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Advice',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _advice,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _message,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: AppColors.heading,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
 
              // Required medical disclaimer - exact wording.
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.alertCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.heading),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This is not a medical diagnosis. Always consult a doctor.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
 
              ElevatedButton(
                onPressed: () {
                  onRestart(); // reset the questionnaire for next time
                  context.go('/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}