import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _userRef(String uid) =>
      _db.collection('users').doc(uid);

  /// Creates users/{uid} with 0 points on first sign-in. No-op if it exists.
  Future<void> createUserIfMissing(String uid, String displayName) async {
    final ref = _userRef(uid);
    final snap = await ref.get();
    if (snap.exists) return;
    final user = UserModel(
      uid: uid,
      displayName: displayName,
      pointsBalance: 0,
      createdAt: DateTime.now(),
    );
    await ref.set(user.toMap());
  }

  Stream<UserModel?> watchUser(String uid) {
    return _userRef(uid).snapshots().map(
          (s) => s.exists ? UserModel.fromMap(s.id, s.data()!) : null,
        );
  }
}
