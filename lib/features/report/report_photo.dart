import 'package:flutter/material.dart';

import '../../app/theme_proposal.dart';

/// Site photo for the report flow. Falls back to a plain green block when no
/// photo was picked.
class ReportPhoto extends StatelessWidget {
  const ReportPhoto({
    super.key,
    required this.url,
    this.height = 220,
    this.radius = 16,
    this.showScanFrame = false,
  });

  final String? url;
  final double height;
  final double radius;

  /// Draws the corner brackets and scan line used on the AI checking screen.
  final bool showScanFrame;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.primaryDark,
      child: const Center(
        child: Icon(Icons.water_drop_outlined, size: 44, color: Colors.white70),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url == null)
              fallback
            else
              Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
            if (showScanFrame)
              const CustomPaint(painter: _ScanFramePainter()),
          ],
        ),
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  const _ScanFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    const inset = 16.0;
    const len = 26.0;
    final l = inset;
    final t = inset;
    final r = size.width - inset;
    final b = size.height - inset;

    // Four corner brackets.
    canvas.drawPath(
      Path()
        ..moveTo(l, t + len)
        ..lineTo(l, t)
        ..lineTo(l + len, t)
        ..moveTo(r - len, t)
        ..lineTo(r, t)
        ..lineTo(r, t + len)
        ..moveTo(l, b - len)
        ..lineTo(l, b)
        ..lineTo(l + len, b)
        ..moveTo(r - len, b)
        ..lineTo(r, b)
        ..lineTo(r, b - len),
      paint,
    );

    // Scan line.
    canvas.drawLine(
      Offset(l, size.height * 0.5),
      Offset(r, size.height * 0.5),
      paint..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_ScanFramePainter old) => false;
}
