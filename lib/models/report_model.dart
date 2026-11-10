import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String id;
  final String reporterId;
  final String photoUrl;
  final GeoPoint location;
  final String geohash;
  final String status; // 'pending' | 'approved' | 'rejected'
  final int confirmationCount;
  final DateTime createdAt;
  final DateTime lastConfirmedAt;

  /// Set by the AI photo check; null on reports created before it existed.
  final String? aiCategory;
  final double? aiConfidence;
  final String? aiReason;

  const ReportModel({
    required this.id,
    required this.reporterId,
    required this.photoUrl,
    required this.location,
    required this.geohash,
    required this.status,
    required this.confirmationCount,
    required this.createdAt,
    required this.lastConfirmedAt,
    this.aiCategory,
    this.aiConfidence,
    this.aiReason,
  });

  factory ReportModel.fromMap(String id, Map<String, dynamic> map) {
    final created = (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    return ReportModel(
      id: id,
      reporterId: map['reporterId'] as String? ?? '',
      photoUrl: map['photoUrl'] as String? ?? '',
      location: map['location'] as GeoPoint? ?? const GeoPoint(0, 0),
      geohash: map['geohash'] as String? ?? '',
      status: map['status'] as String? ?? 'pending',
      confirmationCount: (map['confirmationCount'] as num?)?.toInt() ?? 0,
      createdAt: created,
      lastConfirmedAt:
          (map['lastConfirmedAt'] as Timestamp?)?.toDate() ?? created,
      aiCategory: map['aiCategory'] as String?,
      aiConfidence: (map['aiConfidence'] as num?)?.toDouble(),
      aiReason: map['aiReason'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reporterId': reporterId,
      'photoUrl': photoUrl,
      'location': location,
      'geohash': geohash,
      'status': status,
      'confirmationCount': confirmationCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastConfirmedAt': Timestamp.fromDate(lastConfirmedAt),
      if (aiCategory != null) 'aiCategory': aiCategory,
      if (aiConfidence != null) 'aiConfidence': aiConfidence,
      if (aiReason != null) 'aiReason': aiReason,
    };
  }
}
