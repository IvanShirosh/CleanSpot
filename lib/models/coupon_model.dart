class CouponModel {
  final String id;
  final String code;
  final String value;
  final int pointsCost;
  final String status; // 'available' | 'redeemed'

  const CouponModel({
    required this.id,
    required this.code,
    required this.value,
    required this.pointsCost,
    required this.status,
  });

  factory CouponModel.fromMap(String id, Map<String, dynamic> map) {
    return CouponModel(
      id: id,
      code: map['code'] as String? ?? '',
      value: map['value'] as String? ?? '',
      pointsCost: (map['pointsCost'] as num?)?.toInt() ?? 0,
      status: map['status'] as String? ?? 'available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'value': value,
      'pointsCost': pointsCost,
      'status': status,
    };
  }
}
