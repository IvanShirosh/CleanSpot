import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../features/analysis/analysis_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/map/map_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/report/report_screen.dart';
import '../features/rewards/rewards_screen.dart';
import '../features/symptoms/symptoms_screen.dart';
import 'home_shell.dart';

/// Re-runs the router redirect whenever the auth state changes.
class _AuthRefresh extends ChangeNotifier {
  _AuthRefresh() {
    _sub = FirebaseAuth.instance.authStateChanges().listen(
          (_) => notifyListeners(),
        );
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final router = GoRouter(
  initialLocation: '/home',
  refreshListenable: _AuthRefresh(),
  redirect: (context, state) {
    final signedIn = FirebaseAuth.instance.currentUser != null;
    final atLogin = state.matchedLocation == '/login';
    if (!signedIn) return atLogin ? null : '/login';
    if (atLogin) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/home', redirect: (_, _) => '/map'),
    ShellRoute(
      builder: (_, _, child) => HomeShell(child: child),
      routes: [
        GoRoute(path: '/map', builder: (_, _) => const MapScreen()),
        GoRoute(path: '/report', builder: (_, _) => const ReportScreen()),
        GoRoute(path: '/rewards', builder: (_, _) => const RewardsScreen()),
        GoRoute(path: '/analysis', builder: (_, _) => const AnalysisScreen()),
        GoRoute(path: '/symptoms', builder: (_, _) => const SymptomsScreen()),
        GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      ],
    ),
  ],
);
