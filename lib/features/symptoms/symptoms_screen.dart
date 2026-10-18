import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme_proposal.dart';

class _SymptomQuestion {
  final String question;
  final String details;
  final bool isWarningSign;

  const _SymptomQuestion({
    required this.question,
    required this.details,
    this.isWarningSign = false,
  });
}

const List<_SymptomQuestion> _questions = [
  _SymptomQuestion(
    question: 'Have you had a fever in the last 2 days?',
    details: 'Sudden high fever (above 38.5°C / 101°F) is a primary indicator.',
  ),
  _SymptomQuestion(
    question:
        'Are you experiencing severe headaches, eye pain, or muscle/joint aches?',
    details: 'Retro-orbital pain (pain behind the eyes) and severe body aches.',
  ),
  _SymptomQuestion(
    question:
        'Have you noticed any skin rashes, red spots, or unusual bruising?',
    details: 'Petechiae (tiny red or purple spots) and flushing of the skin.',
  ),
  _SymptomQuestion(
    question:
        'Do you have persistent vomiting, abdominal pain, or extreme fatigue?',
    details: 'These are clinical warning signs requiring immediate medical care.',
    isWarningSign: true,
  ),
];

/// Interactive Dengue Symptom Checker matching the CleanSpot design.
class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  int _currentIndex = 0;
  final Map<int, bool?> _answers = {};
  bool _isCompleted = false;

  void _selectAnswer(bool value) {
    setState(() {
      _answers[_currentIndex] = value;
    });
  }

  void _next() {
    if (_answers[_currentIndex] == null) return;

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      setState(() {
        _isCompleted = true;
      });
    }
  }

  void _back() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _restart() {
    setState(() {
      _currentIndex = 0;
      _answers.clear();
      _isCompleted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Back Arrow
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primary,
                      size: 26,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      if (_isCompleted) {
                        _restart();
                      } else if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Symptom Checker',
                      style: (textTheme.headlineMedium ?? AppTypography.title)
                          .copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'A few simple questions to help you decide when to get support.',
                style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),

              // "Your wellbeing comes first" Tip Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColors.primaryDark.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.monitor_heart_outlined,
                          color: AppColors.primaryDark,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Your wellbeing comes first',
                          style: (textTheme.titleMedium ?? AppTypography.heading)
                              .copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'If you feel seriously unwell, seek medical help now. Do not wait for this checklist.',
                      style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                        color: AppColors.primaryDark,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Main content: either questionnaire or result
              if (!_isCompleted) ...[
                // Question Counter & Demo Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_currentIndex + 1} of ${_questions.length}',
                      style: (textTheme.titleSmall ?? AppTypography.caption)
                          .copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Text(
                      'Demo questionnaire',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Linear Progress Indicator
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / _questions.length,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 24),

                // Question Card
                _buildQuestionCard(),
                const SizedBox(height: 16),

                // Medical Disclaimer
                Text(
                  'This is not a medical diagnosis. Always consult a doctor.',
                  style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 32),

                // Bottom Action Buttons (Back / Next)
                _buildActionButtons(),
              ] else ...[
                // Results View
                _buildResultsView(),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard() {
    final currentQ = _questions[_currentIndex];
    final selectedAnswer = _answers[_currentIndex];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Title
          Text(
            currentQ.question,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 24),

          // "Yes" Option
          _buildOptionButton(
            label: 'Yes',
            isSelected: selectedAnswer == true,
            onTap: () => _selectAnswer(true),
          ),
          const SizedBox(height: 14),

          // "No" Option
          _buildOptionButton(
            label: 'No',
            isSelected: selectedAnswer == false,
            onTap: () => _selectAnswer(false),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.6)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            if (!isSelected) const Spacer(),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.primaryDark,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final canGoBack = _currentIndex > 0;
    final hasAnswered = _answers[_currentIndex] != null;
    final isLast = _currentIndex == _questions.length - 1;

    return Row(
      children: [
        // Back Button
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: canGoBack ? _back : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEBEFEB),
                foregroundColor: AppColors.textPrimary,
                disabledBackgroundColor:
                    const Color(0xFFEBEFEB).withValues(alpha: 0.6),
                disabledForegroundColor:
                    AppColors.textSecondary.withValues(alpha: 0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Back',
                style: TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Next Button
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: hasAnswered ? _next : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.surface,
                disabledBackgroundColor:
                    AppColors.border.withValues(alpha: 0.6),
                disabledForegroundColor: AppColors.textSecondary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                isLast ? 'View Result' : 'Next',
                style: const TextStyle(
                  fontFamily: AppTypography.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    final hasWarning = _answers[3] == true;
    final hasFever = _answers[0] == true;
    final hasAches = _answers[1] == true;
    final hasRashes = _answers[2] == true;

    final isHighRisk = hasWarning;
    final isModerateRisk = !hasWarning && (hasFever || hasAches || hasRashes);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHighRisk
                    ? Icons.warning_amber_rounded
                    : (isModerateRisk
                        ? Icons.info_outline
                        : Icons.check_circle_outline),
                color: isHighRisk
                    ? AppColors.error
                    : (isModerateRisk ? AppColors.warning : AppColors.primary),
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isHighRisk
                      ? 'Immediate Medical Attention Recommended'
                      : (isModerateRisk
                          ? 'Medical Consultation Advised'
                          : 'Low Dengue Indicator'),
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isHighRisk
                        ? AppColors.error
                        : (isModerateRisk
                            ? AppColors.warningText
                            : AppColors.primaryDark),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            isHighRisk
                ? 'You indicated warning signs such as severe abdominal pain or persistent vomiting. These can indicate severe dengue progression. Please visit the nearest hospital or emergency center immediately.'
                : (isModerateRisk
                    ? 'You reported fever or body aches consistent with viral or dengue fever. Monitor your temperature, stay hydrated with fluids/ORS, avoid self-medicating with NSAIDs (aspirin/ibuprofen), and consult a doctor for a Full Blood Count (FBC) test.'
                    : 'You did not report common acute dengue symptoms. Continue taking preventive measures against mosquito bites, especially at dawn and dusk.'),
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 14),
          const Row(
            children: [
              Icon(Icons.phone_in_talk_outlined,
                  size: 20, color: AppColors.primary),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sri Lanka Suwa Seriya: 1990 | Health Hotline: 1999',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _restart,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Retake Quiz'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
