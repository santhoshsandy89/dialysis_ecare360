import 'dart:ui';

import 'package:ecare360/core/constants/app_routes.dart';
import 'package:ecare360/core/providers/floor_provider.dart';
import 'package:ecare360/data/services/floor_service.dart';
import 'package:ecare360/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final floorListProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>(
  (ref, accessToken) async {
    if (accessToken.isEmpty) {
      throw Exception('Access token is missing.');
    }
    return FloorService().fetchFloors(accessToken);
  },
);

class FloorSelectionScreen extends ConsumerStatefulWidget {
  const FloorSelectionScreen({super.key});

  @override
  ConsumerState<FloorSelectionScreen> createState() =>
      _FloorSelectionScreenState();
}

class _FloorSelectionScreenState extends ConsumerState<FloorSelectionScreen> {
  String? _selectedFloorId;
  String? _selectedFloorName;
  String? _selectedFloorCode;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final accessToken = authState.authModel?.accessToken;

    if (accessToken == null || accessToken.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Authentication token missing.\nPlease log in again.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    final floorsAsync = ref.watch(floorListProvider(accessToken));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0.05),
        title: const Text(
          "🏥 Select Hospital Floor",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF054A91),
              Color(0xFF0677B7),
              Color(0xFF0AA1DD),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: floorsAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white)),
          error: (err, stack) => Center(
            child: Text(
              "Error loading floors\n$err",
              style: const TextStyle(color: Colors.white),
            ),
          ),
          data: (floors) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    _glassGridWrapper(
                      child: _buildGrid(floors),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildContinueButton(),
    );
  }

  // ---------------------------------------------------------------------------
  // GLASS GRID WRAPPER
  // ---------------------------------------------------------------------------
  Widget _glassGridWrapper({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // GRID VIEW (WITH RESPONSIVE CROSS-AXES)
  // ---------------------------------------------------------------------------
  Widget _buildGrid(List floors) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int count = 2;
        double ratio = 1.05;

        if (constraints.maxWidth > 450) {
          count = 3;
          ratio = 1.0;
        }
        if (constraints.maxWidth > 900) {
          count = 6;
          ratio = 1;
        }

        return GridView.builder(
          itemCount: floors.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            childAspectRatio: ratio, // smaller tiles
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (_, i) => _buildFloorTile(floors[i]),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // GLASS FLOOR TILE
  // ---------------------------------------------------------------------------
  Widget _buildFloorTile(dynamic floor) {
    final bool isSelected = floor['_id'] == _selectedFloorId;

    IconData icon = Icons.apartment;
    final name = floor['name'].toString().toLowerCase();
    if (name.contains("emergency")) icon = Icons.local_hospital;
    if (name.contains("op")) icon = Icons.medical_services;
    if (name.contains("lab")) icon = Icons.science;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFloorId = floor['_id'];
          _selectedFloorName = floor['name'];
          _selectedFloorCode = floor['code'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? Colors.white.withOpacity(0.28)
              : Colors.white.withOpacity(0.12),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white30,
            width: isSelected ? 2.2 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.white.withOpacity(0.3),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isSelected ? 38 : 30, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              floor['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              floor['code'],
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONTINUE BUTTON (GLASS BUTTON)
  // ---------------------------------------------------------------------------
  Widget _buildContinueButton() {
    final bool isEnabled = _selectedFloorId != null;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isEnabled ? 1 : 0.55,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0A6DBD), // lighter top
                      Color(0xFF0AA1DD), // mid
                      Color(0xFF0FC9F4), // brighter bottom
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: !isEnabled
                      ? null
                      : () {
                          ref.read(floorProvider.notifier).setFloor(
                                _selectedFloorName!,
                                id: _selectedFloorId!,
                                code: _selectedFloorCode!,
                              );
                          context.go(AppRoutes.home);
                        },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Continue to ${_selectedFloorName ?? 'Floor'}",
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_forward_ios,
                          size: 18, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
