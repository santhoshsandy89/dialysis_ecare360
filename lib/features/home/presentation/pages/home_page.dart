import 'package:ecare360/core/providers/floor_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_activities.dart';
import '../widgets/upcoming_appointments.dart';

class HomePage extends ConsumerStatefulWidget {
  final Floor? initialSelectedFloor;

  const HomePage({super.key, this.initialSelectedFloor});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialSelectedFloor != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(floorProvider.notifier).setFloor(
              widget.initialSelectedFloor!.name,
              id: widget.initialSelectedFloor!.id,
              code: widget.initialSelectedFloor!.code,
            );
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndShowFloorSelection();
      });
    }
  }

  Future<void> _checkAndShowFloorSelection() async {
    final current = ref.read(floorProvider);
    if (current == null) await _showFloorSelectionDialog();
  }

  Future<void> _showFloorSelectionDialog() async {
    await context.push(AppRoutes.floorSelection);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentFloor = ref.watch(floorProvider);
    final userName = authState.authModel?.user.firstName ?? 'User';

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            ///---------------------------------------------
            ///       CUSTOM TOP HEADER (More Modern)
            ///---------------------------------------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Column(
                children: [
                  HomeAppBar(
                    userName: userName,
                    selectedFloor: currentFloor,
                    onProfileTap: () => context.push(AppRoutes.profile),
                    onNotificationTap: () =>
                        context.push(AppRoutes.notifications),
                    onFloorChangeTap: _showFloorSelectionDialog,
                    onExitTap: () {
                      showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Exit App'),
                          content: const Text('Are you sure you want to exit?'),
                          actions: [
                            TextButton(
                              child: const Text('No'),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            TextButton(
                              child: const Text('Yes'),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ],
                        ),
                      ).then((confirmed) {
                        if (confirmed == true) {
                          context.go(AppRoutes.usernameLogin);
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  /// Floor pill (Amazon category-style)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => _showFloorSelectionDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.apartment,
                                size: 18, color: Colors.white),
                            const SizedBox(width: 6),
                            Text(
                              currentFloor != null
                                  ? '${currentFloor.name} (${currentFloor.code})'
                                  : 'No Floor Selected',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Floating Search Bar (Amazon-style)
                  Container(
                    height: 46,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.black54),
                        SizedBox(width: 10),
                        Text(
                          'Search health records, reports...',
                          style: TextStyle(color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ///---------------------------------------------
            ///             MAIN CONTENT SCROLL
            ///---------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Greeting
                    Text(
                      'Hello, $userName 👋',
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your health overview for today',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// Card Section Wrapper
                    _sectionWrapper(child: const QuickActions()),
                    const SizedBox(height: 20),

                    /* _sectionWrapper(child: const HealthSummary()),
                    const SizedBox(height: 20),*/

                    _sectionWrapper(child: const UpcomingAppointments()),
                    const SizedBox(height: 20),

                    _sectionWrapper(child: const RecentActivities()),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Wrapper for card-like modern sections
  Widget _sectionWrapper({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
