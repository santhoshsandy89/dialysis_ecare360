import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Splash screen page
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // Progress bar animation
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 4));
      //await ref.read(authProvider.notifier).initialize();
      await Future.delayed(const Duration(seconds: 4));

      if (mounted) {
        context.go(AppRoutes.combinedLogin);
      }
      /*if (mounted) {
        final authState = ref.read(authProvider);
        if (authState.isAuthenticated) {
          context.go(AppRoutes.home);
        } else {
          context.go(AppRoutes.combinedLogin);
        }
      }*/
    } catch (_) {
      if (mounted) context.go(AppRoutes.combinedLogin);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // BEAUTIFUL GRADIENT BACKGROUND
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF63D489),
              Color(0xFF4FAF6A),
              Color(0xFF3B7F52),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            /// Animated App Logo
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            blurRadius: 25,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.asset(
                          'assets/logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            /// App Name
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                'Ecare360',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                  shadows: [
                    Shadow(blurRadius: 10, color: Colors.black26),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            /// Tagline
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Your Health, Our Priority',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ),

            const Spacer(),

            /// Branding Footer Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Yanthra Labs: AI Powered CRM Solution',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Delivering innovative IT solutions that enhance efficiency\nand empower digital transformation.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Innovating AI-Powered Solutions for a Smarter Tomorrow.\n© 2025 YanthraLabs Private Limited. All Rights Reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Beta version 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (_, __) {
                          return LinearProgressIndicator(
                            value: _progressAnimation.value,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
