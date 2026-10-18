import 'package:flutter/material.dart';

import '../../app/theme_proposal.dart';
import '../profile/widgets/widgets.dart';

/// Data model representing a breeding site report incident on the map.
class MapIncident {
  final String id;
  final String title;
  final String location;
  final String dateText;
  final String badgeText;
  final String risk; // 'Low' | 'Medium' | 'High'
  final Offset relativePos; // (0.0 to 1.0)
  final String imageUrl;

  const MapIncident({
    required this.id,
    required this.title,
    required this.location,
    required this.dateText,
    required this.badgeText,
    required this.risk,
    required this.relativePos,
    required this.imageUrl,
  });
}

const List<MapIncident> _demoIncidents = [
  MapIncident(
    id: 'inc-1',
    title: 'Stagnant Water',
    location: 'Sample campus garden',
    dateText: '12 Oct 2026 · Sample photo',
    badgeText: 'Valid report · Demo',
    risk: 'Medium',
    relativePos: Offset(0.35, 0.48),
    imageUrl:
        'https://images.unsplash.com/photo-1584467735871-8e85353a8413?w=300&auto=format&fit=crop&q=80',
  ),
  MapIncident(
    id: 'inc-2',
    title: 'Blocked Drain',
    location: 'Sample community lane',
    dateText: '10 Oct 2026 · Sample photo',
    badgeText: 'Under review · Demo',
    risk: 'High',
    relativePos: Offset(0.58, 0.42),
    imageUrl:
        'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=300&auto=format&fit=crop&q=80',
  ),
  MapIncident(
    id: 'inc-3',
    title: 'Discarded Containers',
    location: 'Volunteer centre perimeter',
    dateText: '08 Oct 2026 · Sample photo',
    badgeText: 'Action needed · Demo',
    risk: 'Low',
    relativePos: Offset(0.74, 0.53),
    imageUrl:
        'https://images.unsplash.com/photo-1578328819058-b69f3a3b0f6b?w=300&auto=format&fit=crop&q=80',
  ),
];

/// Risk Map screen displaying breeding site heatmap and marker indicators
/// matching Figma Page 5.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _viewMode = 'heatmap'; // 'heatmap' | 'markers'
  String _timeRange = '7d'; // '7d' | '30d' | 'all'
  late MapIncident _selectedIncident;

  @override
  void initState() {
    super.initState();
    _selectedIncident = _demoIncidents.first;
  }

  Widget _buildViewModeToggle() {
    final isHeatmap = _viewMode == 'heatmap';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _viewMode = 'heatmap'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isHeatmap ? AppColors.primaryLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Heatmap',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: isHeatmap ? FontWeight.bold : FontWeight.w500,
                    color:
                        isHeatmap ? AppColors.primaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => setState(() => _viewMode = 'markers'),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isHeatmap ? AppColors.primaryLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Markers',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 14,
                    fontWeight: !isHeatmap ? FontWeight.bold : FontWeight.w500,
                    color:
                        !isHeatmap ? AppColors.primaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilterChip(String label, String value) {
    final isSelected = _timeRange == value;

    return InkWell(
      onTap: () => setState(() => _timeRange = value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildMapCanvas(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            // Stylized vector map terrain & heatmap painter
            Positioned.fill(
              child: CustomPaint(
                painter: _MapTerrainPainter(
                  showHeatmap: _viewMode == 'heatmap',
                ),
              ),
            ),

            // Map Pins
            for (final incident in _demoIncidents)
              Positioned(
                left: (incident.relativePos.dx * width) - 18,
                top: (incident.relativePos.dy * height) - 18,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIncident = incident;
                    });
                  },
                  child: _buildPin(incident == _selectedIncident),
                ),
              ),

            // Map placeholder badge
            Positioned(
              left: 16,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: const Text(
                  'MAP PLACEHOLDER · No actual geography',
                  style: TextStyle(
                    fontFamily: AppTypography.fontFamily,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPin(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isSelected ? 42 : 36,
      height: isSelected ? 42 : 36,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.surface,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.35),
            blurRadius: isSelected ? 10 : 6,
            spreadRadius: isSelected ? 2 : 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.location_on,
          color: AppColors.surface,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildRiskLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const Text(
            'Demo risk',
            style: TextStyle(
              fontFamily: AppTypography.fontFamily,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          _buildLegendItem('Low', AppColors.primary),
          const SizedBox(width: 14),
          _buildLegendItem('Medium', AppColors.warningText),
          const SizedBox(width: 14),
          _buildLegendItem('High', AppColors.errorText),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle pill
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          // Incident details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 76,
                  height: 76,
                  color: AppColors.primaryLight,
                  child: Image.network(
                    _selectedIncident.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return const Center(
                        child: Icon(
                          Icons.yard_outlined,
                          size: 32,
                          color: AppColors.primaryDark,
                        ),
                      );
                    },
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Text & Badge Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedIncident.title,
                      style: (textTheme.titleMedium ?? AppTypography.heading).copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _selectedIncident.location,
                      style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _selectedIncident.dateText,
                      style: (textTheme.bodySmall ?? AppTypography.caption).copyWith(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Status Badge Chip
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedIncident.badgeText,
                        style: const TextStyle(
                          fontFamily: AppTypography.fontFamily,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Title, Info Note, and Filters
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Risk Map',
                    style:
                        (textTheme.headlineMedium ?? AppTypography.title).copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const InfoNote(
                    text: 'Demo map · Points are not real incidents',
                  ),
                  const SizedBox(height: 14),

                  // Heatmap / Markers Toggle
                  _buildViewModeToggle(),
                  const SizedBox(height: 10),

                  // Time Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTimeFilterChip('Last 7 Days', '7d'),
                        const SizedBox(width: 8),
                        _buildTimeFilterChip('Last 30 Days', '30d'),
                        const SizedBox(width: 8),
                        _buildTimeFilterChip('All Time', 'all'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // Map Area (expands to take available space)
            Expanded(
              child: _buildMapCanvas(context),
            ),

            // Risk Level Legend
            _buildRiskLegend(),

            // Bottom Selected Incident Detail Card
            _buildDetailCard(context),
          ],
        ),
      ),
    );
  }
}

/// Custom painter rendering the clean cartography and soft heatmap risk clusters.
class _MapTerrainPainter extends CustomPainter {
  final bool showHeatmap;

  _MapTerrainPainter({required this.showHeatmap});

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Base terrain background
    final bgPaint = Paint()..color = const Color(0xFFEDF3ED);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // 2. Green park area on the left
    final parkPaint = Paint()..color = const Color(0xFFDCEADF);
    final parkPath = Path()
      ..moveTo(0, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.32,
        size.width * 0.26,
        size.height * 0.58,
      )
      ..quadraticBezierTo(
        size.width * 0.22,
        size.height * 0.70,
        0,
        size.height * 0.68,
      )
      ..close();
    canvas.drawPath(parkPath, parkPaint);

    // 3. Water canal / lake on the right
    final waterPaint = Paint()..color = const Color(0xFFD6E8ED);
    final waterPath = Path()
      ..moveTo(size.width * 0.76, size.height * 0.28)
      ..quadraticBezierTo(
        size.width * 0.85,
        size.height * 0.25,
        size.width,
        size.height * 0.28,
      )
      ..lineTo(size.width, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.80,
        size.height * 0.78,
        size.width * 0.76,
        size.height * 0.70,
      )
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // 4. White arterial roads
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFD9E3D9)
      ..strokeWidth = 17
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Road 1: Diagonal cross road
    final r1 = Path()
      ..moveTo(0, size.height * 0.58)
      ..lineTo(size.width, size.height * 0.36);

    // Road 2: Vertical crossing road
    final r2 = Path()
      ..moveTo(size.width * 0.22, size.height * 0.32)
      ..lineTo(size.width * 0.44, size.height * 0.75);

    // Road 3: Top-right highway
    final r3 = Path()
      ..moveTo(size.width * 0.50, size.height * 0.34)
      ..lineTo(size.width * 0.38, size.height * 0.72);

    // Draw borders then fills
    for (final r in [r1, r2, r3]) {
      canvas.drawPath(r, roadBorderPaint);
    }
    for (final r in [r1, r2, r3]) {
      canvas.drawPath(r, roadPaint);
    }

    // 5. Heatmap overlay (if enabled)
    if (showHeatmap) {
      final heatCenter = Offset(size.width * 0.52, size.height * 0.44);

      // Low risk outer halo
      final lowPaint = Paint()
        ..color = const Color(0xFFE89874).withValues(alpha: 0.22);
      canvas.drawCircle(heatCenter, size.width * 0.25, lowPaint);

      // Medium risk mid ring
      final medPaint = Paint()
        ..color = const Color(0xFFE57373).withValues(alpha: 0.30);
      canvas.drawCircle(heatCenter, size.width * 0.16, medPaint);

      // High risk inner hotspot
      final highPaint = Paint()
        ..color = const Color(0xFFD32F2F).withValues(alpha: 0.28);
      canvas.drawCircle(heatCenter, size.width * 0.08, highPaint);
    }
  }

  @override
  bool shouldRepaint(_MapTerrainPainter oldDelegate) =>
      showHeatmap != oldDelegate.showHeatmap;
}
