import 'package:ecare360/core/providers/floor_provider.dart';
import 'package:ecare360/features/auth/presentation/pages/combined_login_screen.dart';
import 'package:ecare360/features/home/presentation/pages/book_appointment_screen.dart';
import 'package:ecare360/features/home/presentation/pages/floor_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/schedule_treatment/presentation/pages/schedule_treatment_screen.dart'; // Import the new screen
import '../../features/settings/presentation/pages/settings_page.dart';
import '../constants/app_routes.dart';

/// Application router configuration using GoRouter
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // LOGIN SCREEN
      GoRoute(
        path: AppRoutes.combinedLogin,
        name: 'login',
        builder: (context, state) => const CombinedLoginScreen(),
      ),

      // Floor Selection
      GoRoute(
        path: AppRoutes.floorSelection,
        name: 'floorSelection',
        builder: (context, state) => const FloorSelectionScreen(),
      ),

      // Book Appointment
      GoRoute(
        path: AppRoutes.bookAppointment,
        name: 'book-appointment',
        builder: (context, state) => const BookAppointmentScreen(),
      ),

      // Main App Shell
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          final extras = state.extra as Map<String, dynamic>?;
          final selectedFloor = extras?['selectedFloor'] as Floor?;
          return HomePage(initialSelectedFloor: selectedFloor);
        },
        routes: [
          GoRoute(
            path: 'schedule_treatment',
            name: 'schedule_treatment',
            builder: (context, state) => const ScheduleTreatmentSection(),
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page Not Found'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  static GoRouter get router => _router;
}
