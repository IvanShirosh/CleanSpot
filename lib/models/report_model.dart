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
    };
  }
}
