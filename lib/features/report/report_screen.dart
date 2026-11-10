import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme_proposal.dart';
import '../ai_validation/capture_result.dart';
import '../ai_validation/capture_service.dart';

/// The 4 step states of the AI report verification workflow:
/// 1. [form]      - Image 1: "Report a Breeding Site"
/// 2. [checking]  - Image 2: "AI is Checking Your Report"
/// 3. [approved]  - Image 3: "Report Verified Successfully"
/// 4. [rejected]  - Image 4: "Report Not Approved"
enum ReportFlowStep {
  form,
  checking,
  approved,
  rejected,
}

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  ReportFlowStep _currentStep = ReportFlowStep.form;

  // Animation controller for the AI scanning beam
  late final AnimationController _scanController;
  late final Animation<double> _scanAnimation;

  final String _samplePhotoUrl =
      'https://images.unsplash.com/photo-1584467735871-8e85353a8413?w=600&auto=format&fit=crop&q=80';

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scanAnimation = CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  // Live camera photo + GPS fix from captureReportPhoto(); null until taken.
  CaptureResult? _capture;
  bool _capturing = false;

  Future<void> _takePhoto() async {
    setState(() => _capturing = true);
    final result = await captureReportPhoto();
    if (!mounted) return;
    setState(() {
      _capturing = false;
      if (result.isOk) _capture = result;
    });
    if (!result.isOk && !result.wasCancelled) _showMessage(result.message!);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _submitReport() {
    if (_capture?.isOk != true) return;
    setState(() {
      _currentStep = ReportFlowStep.checking;
    });
  }

  void _resetToForm() {
    setState(() {
      _capture = null;
      _currentStep = ReportFlowStep.form;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top workflow stepper helper bar (allows instant switching between all 4 stages & My Reports)
            _buildStageSwitcherBar(),

            // Active step content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _buildCurrentStepContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent(BuildContext context) {
    switch (_currentStep) {
      case ReportFlowStep.form:
        return _buildFormStep(context);
      case ReportFlowStep.checking:
        return _buildCheckingStep(context);
      case ReportFlowStep.approved:
        return _buildApprovedStep(context);
      case ReportFlowStep.rejected:
        return _buildRejectedStep(context);
    }
  }

  // ---------------------------------------------------------------------------
  // Quick Stage Switcher Bar
  // ---------------------------------------------------------------------------
  Widget _buildStageSwitcherBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'UI FLOW',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStepPill('1. Report', ReportFlowStep.form),
                  const SizedBox(width: 6),
                  _buildStepPill('2. Checking', ReportFlowStep.checking),
                  const SizedBox(width: 6),
                  _buildStepPill('3. Approved', ReportFlowStep.approved),
                  const SizedBox(width: 6),
                  _buildStepPill('4. Rejected', ReportFlowStep.rejected),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => context.push('/profile/reports'),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list_alt, size: 14, color: AppColors.primaryDark),
                  SizedBox(width: 4),
                  Text(
                    'Reports',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepPill(String label, ReportFlowStep step) {
    final isSelected = _currentStep == step;
    return InkWell(
      onTap: () => setState(() => _currentStep = step),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 1: Report a Breeding Site (Image 1)
  // ---------------------------------------------------------------------------
  Widget _buildFormStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Header Title & Subtitle
        Text(
          'Report a Breeding Site',
          style: (textTheme.headlineSmall ?? AppTypography.title).copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'A clear photo helps AI validate your report.',
          style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 18),

        // Card 1: Site photo
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
                  Text(
                    'Site photo',
                    style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _capture == null ? 'No photo yet' : '1 photo added',
                    style: const TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Live photo preview (placeholder until a photo is taken)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _capture == null
                    ? Container(
                        height: 170,
                        color: AppColors.primaryLight,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.photo_camera_outlined,
                          size: 48,
                          color: AppColors.primary,
                        ),
                      )
                    : Image.memory(
                        _capture!.jpegBytes!,
                        height: 170,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 14),

              // Camera and Upload Photo Outlined Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _capturing ? null : _takePhoto,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        side: const BorderSide(color: AppColors.border, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: _capturing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Camera',
                              style: TextStyle(
                                fontFamily: AppTypography.fontFamily,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      // Verified reports must be live photos.
                      onPressed: () => _showMessage(
                        'Please use the camera so your report can be verified',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        side: const BorderSide(color: AppColors.border, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: const Text(
                        'Upload Photo',
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Card 2: Illustrative Map card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            children: [
              // Stylized mini map preview
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _IllustrativeMapPainter(),
                    child: Center(
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(alpha: 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Location info row
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primaryDark,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _capture == null
                                ? 'Location not added yet'
                                : 'Location added',
                            style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _capture == null
                                ? 'Take a photo to add your location'
                                : '${_capture!.latitude!.toStringAsFixed(5)}, '
                                    '${_capture!.longitude!.toStringAsFixed(5)}'
                                    ' · ±${_capture!.accuracyMeters!.round()} m',
                            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Water guidance section
        Text(
          'Make the water clearly visible',
          style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Photograph standing water, discarded tyres, open containers or blocked drains in good light.',
          style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),

        // Submit Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            // Enabled only after a camera photo with a valid GPS fix.
            onPressed: _capture?.isOk == true ? _submitReport : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.border,
              disabledForegroundColor: AppColors.textSecondary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Submit Report',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Footnote
        Center(
          child: Text(
            'Demo report · Current balance: 120 points',
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 2: AI is Checking Your Report (Image 2)
  // ---------------------------------------------------------------------------
  Widget _buildCheckingStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Top Tag
        const Text(
          'REPORT VALIDATION',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),

        // Title
        Text(
          'AI is Checking Your\nReport',
          style: (textTheme.headlineSmall ?? AppTypography.title).copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),

        // Subtitle
        Text(
          "We're checking your image for a possible mosquito breeding site.",
          style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 18),

        // Photo with Scanner Viewfinder Reticle Overlay
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                _samplePhotoUrl,
                height: 210,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  height: 210,
                  color: AppColors.primaryLight,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            // Viewfinder Corner Brackets Overlay
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CustomPaint(
                  painter: _ViewfinderReticlePainter(),
                ),
              ),
            ),

            // Animated Horizontal Scan Line
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _scanAnimation,
                builder: (context, _) {
                  return FractionallySizedBox(
                    alignment: Alignment(0, (_scanAnimation.value * 2) - 1),
                    heightFactor: 0.05,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.0),
                            Colors.white,
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Location & Time under image
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: AppColors.primaryDark,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Sample campus garden · 13 Oct, 9:41 AM',
              style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Analyzing Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with percentage
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Analyzing site details',
                    style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    '65%',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 7,
                  backgroundColor: AppColors.primaryLight,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // Checklist Items
              _buildChecklistItem(
                icon: Icons.check_circle_outline,
                iconColor: AppColors.primaryDark,
                text: 'Photo received',
                textColor: AppColors.textPrimary,
              ),
              const SizedBox(height: 12),
              _buildChecklistItem(
                icon: Icons.crop_free,
                iconColor: AppColors.primaryDark,
                text: 'Checking for standing water',
                textColor: AppColors.textPrimary,
              ),
              const SizedBox(height: 12),
              _buildChecklistItem(
                icon: Icons.access_time,
                iconColor: AppColors.textSecondary,
                text: 'Checking for duplicate reports',
                textColor: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Points Info Highlight Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.shield_outlined,
                color: AppColors.primaryDark,
                size: 22,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Each valid report earns 10 points. Your balance updates after verification.',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 13,
                    color: AppColors.primaryDark,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Simulation Decision Buttons (Instant toggle to test both approved and rejected outcomes)
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => _currentStep = ReportFlowStep.approved),
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Simulate Approved'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _currentStep = ReportFlowStep.rejected),
                icon: const Icon(Icons.close, size: 18, color: AppColors.errorText),
                label: const Text(
                  'Simulate Rejected',
                  style: TextStyle(color: AppColors.errorText),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.errorText),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Footnote
        Center(
          child: Text(
            'Illustrative checking state · Balance: 120 points',
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChecklistItem({
    required IconData icon,
    required Color iconColor,
    required String text,
    required Color textColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 3: Report Verified Successfully (Image 3)
  // ---------------------------------------------------------------------------
  Widget _buildApprovedStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Tag
        const Text(
          'REPORT RESULT · APPROVED',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),

        // Big Green Checkmark Icon Badge
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: AppColors.primaryDark,
            size: 32,
          ),
        ),
        const SizedBox(height: 14),

        // Title
        Text(
          'Report Verified\nSuccessfully',
          style: (textTheme.headlineSmall ?? AppTypography.title).copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),

        // Subtitle
        Text(
          'Thank you for helping make your community safer.',
          style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 18),

        // Card with Image & Detected Site Type
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  _samplePhotoUrl,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 170,
                    color: AppColors.primaryLight,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DETECTED SITE TYPE',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Discarded tyre with standing water',
                      style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sample campus garden · 13 Oct, 9:41 AM',
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
        ),
        const SizedBox(height: 14),

        // Points Earned Highlight Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.spa_outlined,
                color: AppColors.primaryDark,
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '+10 Points Earned',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Updated balance: 130 points · Previously 120',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 13,
                        color: AppColors.primaryDark.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Action Buttons
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => context.go('/home'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'View on Map',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: _resetToForm,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Submit Another Report',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Footnote
        Center(
          child: Text(
            'Illustrative report · Fictional location',
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STEP 4: Report Not Approved (Image 4)
  // ---------------------------------------------------------------------------
  Widget _buildRejectedStep(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Tag
        const Text(
          'REPORT RESULT · REJECTED ALTERNATIVE',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),

        // Subtitle
        Text(
          'An alternative outcome from the 120-point balance.',
          style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),

        // Card 1: Report Not Approved
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Red Signal Slash Icon
              const Icon(
                Icons.portable_wifi_off_outlined,
                color: AppColors.errorText,
                size: 38,
              ),
              const SizedBox(height: 14),

              Text(
                'Report Not Approved',
                style: (textTheme.headlineSmall ?? AppTypography.title).copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Duplicate report. This photo and location match a site already submitted. No new points were awarded.',
                style: (textTheme.bodyMedium ?? AppTypography.body).copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _resetToForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Card 2: 0 Points Earned Highlight
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.errorBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.errorText.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.errorText,
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '0 Points Earned',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.errorText,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Balance unchanged: 120 points',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Card 3: For your next report
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
              Text(
                'For your next report',
                style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              _buildTipItem(
                icon: Icons.fact_check_outlined,
                text: 'Choose a different, unreported site.',
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                icon: Icons.camera_alt_outlined,
                text: 'Use a sharp, well-lit photo that clearly shows standing water.',
              ),
              const SizedBox(height: 12),
              _buildTipItem(
                icon: Icons.location_on_outlined,
                text: 'Confirm the location matches the photo.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Footnote
        Center(
          child: Text(
            'Illustrative rejection · Not part of the approved path',
            style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primaryDark, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for the illustrative mini map in Step 1
class _IllustrativeMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFEFF5EF);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 26
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPath = Path();
    roadPath.moveTo(-20, size.height * 0.6);
    roadPath.lineTo(size.width * 0.38, size.height * 0.55);
    roadPath.lineTo(size.width * 0.52, size.height * 0.45);
    roadPath.lineTo(size.width + 20, size.height * 0.45);
    canvas.drawPath(roadPath, roadPaint);

    final blockPaint = Paint()..color = const Color(0xFFE2EDE2);
    final blockRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.68, 6, size.width * 0.22, size.height * 0.7),
      const Radius.circular(8),
    );
    canvas.drawRRect(blockRect, blockPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for the camera reticle corner brackets in Step 2
class _ViewfinderReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    const cornerLength = 24.0;

    // Top-Left ┌
    canvas.drawLine(const Offset(0, 0), const Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(0, cornerLength), paint);

    // Top-Right ┐
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom-Left └
    canvas.drawLine(Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - cornerLength), paint);

    // Bottom-Right ┘
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
