import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../app/theme_proposal.dart';
import '../../services/firestore_service.dart';

/// Shows one saved report's photo, loading it on demand from
/// `reportPhotos/{reportId}` (cached after the first load).
///
/// Shows a placeholder icon while loading and when there is no photo, so lists
/// never wait on image data and never read photos in bulk.
class ReportPhotoView extends StatefulWidget {
  const ReportPhotoView({
    super.key,
    required this.reportId,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderIconSize = 28,
    this.loader,
  });

  final String reportId;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double placeholderIconSize;

  /// Replaces the Firestore lookup (used by tests).
  final Future<Uint8List?> Function(String reportId)? loader;

  @override
  State<ReportPhotoView> createState() => _ReportPhotoViewState();
}

class _ReportPhotoViewState extends State<ReportPhotoView> {
  late Future<Uint8List?> _photo = _load();

  Future<Uint8List?> _load() => widget.reportId.isEmpty
      ? Future.value(null)
      : (widget.loader ?? FirestoreService().getReportPhoto)(widget.reportId);

  @override
  void didUpdateWidget(ReportPhotoView old) {
    super.didUpdateWidget(old);
    if (old.reportId != widget.reportId) _photo = _load();
  }

  Widget _placeholder() => Container(
        width: widget.width,
        height: widget.height,
        color: AppColors.primaryLight,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: AppColors.primary,
          size: widget.placeholderIconSize,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _photo,
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) return _placeholder();
        return Image.memory(
          bytes,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => _placeholder(),
        );
      },
    );
  }
}
