// lib/features/symptoms/symptoms_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'symptom_questions.dart';
import 'symptom_result_screen.dart';

class SymptomsScreen extends StatefulWidget {
  const SymptomsScreen({super.key});

  @override
  State<SymptomsScreen> createState() => _SymptomsScreenState();
}

class _SymptomsScreenState extends State<SymptomsScreen> {
  int _index = 0;
  bool _showWarnings = false; // warning-sign list, shown after Q4
  final Set<int> _ticked = {};
  // One entry per question; null = not answered yet.
  final List<bool?> _answers = List.filled(symptomQuestions.length, null);

  void _answer(bool value) {
    setState(() => _answers[_index] = value);

    if (_index < symptomQuestions.length - 1) {
      setState(() => _index++);
    } else {
      setState(() => _showWarnings = true);
    }
  }

  void _back() {
    if (_showWarnings) {
      setState(() => _showWarnings = false);
    } else if (_index > 0) {
      setState(() => _index--);
    }
  }

  void _restart() {
    setState(() {
      _index = 0;
      _showWarnings = false;
      _ticked.clear();
      for (var i = 0; i < _answers.length; i++) {
        _answers[i] = null;
      }
    });
  }

  void _finish() {
    // Prevent submitting an incomplete questionnaire.
    if (_answers.contains(null)) return;

    final bool hasWarningSign = _ticked.isNotEmpty;
    bool hasFever = false;
    int otherSymptomCount = 0;

    for (var i = 0; i < symptomQuestions.length; i++) {
      if (_answers[i] != true) continue;
      final q = symptomQuestions[i];
      if (q.isFever) {
        hasFever = true;
      } else {
        otherSymptomCount++;
      }
    }

    RiskLevel level;
    if (hasWarningSign) {
      level = RiskLevel.high;
    } else if (hasFever && otherSymptomCount >= 2) {
      level = RiskLevel.medium;
    } else {
      level = RiskLevel.low;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SymptomResultScreen(level: level, onRestart: _restart),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showWarnings) return _buildWarningScreen();

    final total = symptomQuestions.length;
    final question = symptomQuestions[_index];
    final progress = (_index + 1) / total;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _titleBar('Symptom Checker', _leave),
              const SizedBox(height: 16),
              Text(
                'Question ${_index + 1} of $total',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.heading,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // One question per card.
              Card(
                color: AppColors.alertCard,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1.35,
                      fontWeight: FontWeight.bold,
                      color: AppColors.heading,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Yes / No buttons.
              Row(
                children: [
                  Expanded(child: _answerButton('YES', true)),
                  const SizedBox(width: 16),
                  Expanded(child: _answerButton('NO', false)),
                ],
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _index > 0 ? _back : null,
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: AppColors.button),
                    ),
                  ),
                  TextButton(
                    onPressed: _restart,
                    child: const Text(
                      'Restart',
                      style: TextStyle(color: AppColors.button),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Progress bar.
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: AppColors.alertCard,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.button,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).round()}% complete',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.heading),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Leaves the symptom checker (back to the previous page, or Home).
  void _leave() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  Widget _titleBar(String title, VoidCallback onBack) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.button),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onBack,
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.heading,
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        ), // balances the arrow so the title stays centred
      ],
    );
  }

  Widget _buildWarningScreen() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _titleBar('Warning Signs', _back),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.alertCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tick any warning signs you have',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < warningSigns.length; i++)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: AppColors.button,
                        title: Text(
                          warningSigns[i],
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.heading,
                          ),
                        ),
                        value: _ticked.contains(i),
                        onChanged: (v) => setState(
                          () => v == true ? _ticked.add(i) : _ticked.remove(i),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _finish,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.button,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'See Result',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _back,
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: AppColors.button),
                    ),
                  ),
                  TextButton(
                    onPressed: _restart,
                    child: const Text(
                      'Restart',
                      style: TextStyle(color: AppColors.button),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _answerButton(String label, bool value) {
    final selected = _answers[_index] == value;
    return ElevatedButton(
      onPressed: () => _answer(value),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.button,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: selected ? AppColors.heading : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
