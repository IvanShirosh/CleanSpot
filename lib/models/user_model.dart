import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final int pointsBalance;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.displayName,
    required this.pointsBalance,
    required this.createdAt,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      displayName: map['displayName'] as String? ?? '',
      pointsBalance: (map['pointsBalance'] as num?)?.toInt() ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'pointsBalance': pointsBalance,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
