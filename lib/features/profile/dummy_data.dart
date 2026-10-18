import 'package:flutter/material.dart';

/// Temporary dummy data for CleanSpot profile, rewards, and reports screens.
///
/// Designed to match Firestore schema field names (`title`, `description`,
/// `cost`, `code`, `available`) for effortless migration to real backend collections.

/// Represents a mockup user profile.
class DummyUser {
  final String name;
  final String email;
  final String? photoUrl;
  final int points;

  const DummyUser({
    this.name = 'Chathuranga Sandaruwan',
    this.email = 'chathuranga@example.com',
    this.photoUrl,
    this.points = 120,
  });

  // Firestore schema compatibility aliases
  String get displayName => name;
  int get pointsBalance => points;
}

/// Default active dummy user instance.
const DummyUser dummyUser = DummyUser();

/// Represents a reward coupon redeemable with user points.
class DummyCoupon {
  final String id;
  final String title;
  final String description;
  final int cost;
  final String code;
  final IconData icon;
  final bool available;

  const DummyCoupon({
    required this.id,
    required this.title,
    required this.description,
    required this.cost,
    required this.code,
    required this.icon,
    this.available = true,
  });

  // Firestore schema compatibility aliases
  int get pointsCost => cost;
  String get value => description;
  String get status => available ? 'available' : 'redeemed';
}

/// 5 sample reward coupons.
const List<DummyCoupon> dummyCoupons = [
  DummyCoupon(
    id: 'coupon-eco-20',
    title: 'Eco Discount',
    description: 'A sample discount reward',
    cost: 20,
    code: 'ECO20',
    icon: Icons.confirmation_number_outlined,
    available: true,
  ),
  DummyCoupon(
    id: 'coupon-green-30',
    title: 'Green Shopper',
    description: 'A sustainable shopping reward',
    cost: 30,
    code: 'GREEN30',
    icon: Icons.shopping_bag_outlined,
    available: true,
  ),
  DummyCoupon(
    id: 'coupon-shield-45',
    title: 'Community Shield',
    description: 'Repellent and mosquito safety kit voucher',
    cost: 45,
    code: 'SHIELD45',
    icon: Icons.verified_user_outlined,
    available: true,
  ),
  DummyCoupon(
    id: 'coupon-award-60',
    title: 'Clean Champion',
    description: 'Eco-certified home garden supplies voucher',
    cost: 60,
    code: 'CHAMP60',
    icon: Icons.military_tech_outlined,
    available: true,
  ),
  DummyCoupon(
    id: 'coupon-transit-40',
    title: 'Green Transit Pass',
    description: 'Low-emission public transport fare discount',
    cost: 40,
    code: 'TRANSIT40',
    icon: Icons.directions_bus_outlined,
    available: true,
  ),
];

/// Represents a submitted dengue mosquito breeding site report.
class DummyReport {
  final String id;
  final String type;
  final String location;
  final String dateText;
  final String status;

  const DummyReport({
    this.id = '',
    required this.type,
    required this.location,
    required this.dateText,
    required this.status,
  });

  // Helper flags for UI badges
  bool get isPending => status.toLowerCase().contains('pending');
  bool get isReviewed => status.toLowerCase().contains('reviewed');
  bool get isNeedsDetail => status.toLowerCase().contains('detail');
}

/// 3 sample breeding site reports matching mockup states.
const List<DummyReport> dummyReports = [
  DummyReport(
    id: 'report-1',
    type: 'Stagnant water',
    location: 'Sample campus garden',
    dateText: '12 Oct · 9:15 AM',
    status: 'Pending review',
  ),
  DummyReport(
    id: 'report-2',
    type: 'Blocked drain',
    location: 'Sample community lane',
    dateText: '10 Oct · 4:40 PM',
    status: 'Reviewed',
  ),
  DummyReport(
    id: 'report-3',
    type: 'Containers',
    location: 'Sample volunteer centre',
    dateText: '8 Oct · 11:20 AM',
    status: 'Needs detail',
  ),
];

/// Represents a coupon already redeemed by the user.
class DummyRedemption {
  final String id;
  final String title;
  final String description;
  final int points;
  final String code;
  final String dateText;
  final IconData icon;

  const DummyRedemption({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.code,
    required this.dateText,
    this.icon = Icons.confirmation_number_outlined,
  });

  int get cost => points;
}

/// Redeemed coupon list for the user.
const List<DummyRedemption> dummyRedemptions = [
  DummyRedemption(
    id: 'redemption-1',
    title: 'Eco Discount',
    description: 'A sample discount reward',
    points: 20,
    code: 'ECO20',
    dateText: '12 Oct 2026',
    icon: Icons.confirmation_number_outlined,
  ),
];
