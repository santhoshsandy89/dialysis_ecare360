import 'package:ecare360/core/constants/app_colors.dart';
import 'package:ecare360/core/constants/app_text_styles.dart';
import 'package:ecare360/core/utils/logger.dart';
import 'package:ecare360/data/models/bed_status_model.dart';
import 'package:ecare360/data/services/bed_status_service.dart';
import 'package:ecare360/features/auth/presentation/widgets/custom_button.dart';
import 'package:ecare360/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:ecare360/features/home/presentation/providers/bed_status_provider.dart';
import 'package:ecare360/features/home/presentation/providers/doctor_provider.dart';
import 'package:ecare360/features/home/presentation/providers/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/doctor_model.dart';
import '../../../../data/models/patient_model.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/services/local_storage_service.dart';
import '../../../../data/services/user_service.dart';
import '../providers/auth_provider.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  final String username;
  final String userId;

  const PasswordScreen({
    super.key,
    required this.username,
    required this.userId,
  });

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    // For development (optional)
    _passwordController.text = "yanthra123";
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // PASSWORD VERIFICATION
  // ---------------------------------------------------------------------------
  Future<void> _verifyPassword() async {
    if (widget.userId.isEmpty) {
      return _showError('User Id is missing. Please go back and try again.');
    }

    if (_passwordController.text.isEmpty) {
      return _showError('Please enter your password.');
    }

    setState(() => _isLoading = true);

    try {
      final response = await AuthService().verifyUserPassword(
        userId: widget.userId,
        password: _passwordController.text,
        host: '',
      );

      final accessToken = response['data']['accesstoken'];
      final refreshToken = response['data']['refreshtoken'];

      if (accessToken != null && refreshToken != null) {
        await ref.read(authProvider.notifier).setTokens(
              accessToken,
              refreshToken,
              widget.username,
              widget.userId,
            );
      }

      await _prefetchAppData(accessToken);
    } catch (e) {
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // PRE-FETCH DATA (Patients, Doctors, Bed Statuses)
  // ---------------------------------------------------------------------------
  Future<void> _prefetchAppData(String? accessToken) async {
    if (accessToken == null) return;

    final userService = UserService();
    final bedStatusService = BedStatusService();

    try {
      // Patients
      final patientList = await _fetchPatients(userService, accessToken);
      ref.read(patientProvider.notifier).setPatients(patientList);

      // Doctors
      final doctorList = await _fetchDoctors(userService, accessToken);
      ref.read(doctorProvider.notifier).setDoctors(doctorList);

      // Bed statuses
      final bedStatuses = await _fetchBedStatus(bedStatusService, accessToken);
      ref.read(bedStatusProvider.notifier).setBedStatuses(bedStatuses);

      // Floors
    } catch (e) {
      _showError('Failed to pre-fetch data: $e');
    }
  }

  Future<List<PatientModel>> _fetchPatients(
      UserService userService, String token) async {
    final patientsData = await userService.fetchPatients(token);
    final patients = patientsData.map((e) => PatientModel.fromJson(e)).toList();

    await LocalStorageService.savePatientsList(patients);
    AppLogger.debug("✔ Patients cached");

    return patients;
  }

  Future<List<DoctorModel>> _fetchDoctors(
      UserService userService, String token) async {
    final doctorsData = await userService.fetchDoctors(token);
    final doctors = doctorsData.map((e) => DoctorModel.fromJson(e)).toList();

    await LocalStorageService.saveDoctorsList(doctors);
    AppLogger.debug("✔ Doctors cached");

    return doctors;
  }

  Future<List<BedStatusModel>> _fetchBedStatus(
      BedStatusService bedStatusService, String token) async {
    final bedStatusData = await bedStatusService.fetchBedStatuses(token);

    await LocalStorageService.saveBedStatuses(bedStatusData);
    AppLogger.debug("✔ Bed Statuses Cached");

    return bedStatusData;
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UI
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            return isWide
                ? Row(
                    children: [
                      Expanded(child: _buildLeftPanel()),
                      Expanded(child: _buildRightPanel()),
                    ],
                  )
                : Column(
                    children: [
                      _buildLeftPanel(),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(32),
                            child: _buildPasswordContent(),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  // Left green panel
  Widget _buildLeftPanel() {
    return Container(
      color: const Color(0xFF63D489),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Image.asset('assets/logo.jpg'),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Yanthra Labs: AI Powered CRM Solution',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Delivering innovative, customized IT solutions for a digital-driven world.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            top: 40,
            left: 16,
            child: BackButton(color: AppColors.white),
          )
        ],
      ),
    );
  }

  // Right side panel
  Widget _buildRightPanel() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: _buildPasswordContent(),
      ),
    );
  }

  // Password widget column
  Widget _buildPasswordContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CircleAvatar(
          radius: 70,
          backgroundColor: const Color(0xFF63D489).withOpacity(0.2),
          child: Image.asset('assets/profile.png'),
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome, ${widget.username}!',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 32),
        CustomTextField(
          controller: _passwordController,
          hintText: 'Enter your password',
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 24),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width:
                    double.infinity, // 👈 Makes button match text field width
                height: 48,
                child: CustomButton(
                  text: 'Login',
                  onPressed: _verifyPassword,
                  backgroundColor: const Color(0xFF63D489),
                ),
              ),
        const SizedBox(height: 40),
        const Text(
          'Innovating AI-Powered Solutions for a Smarter Tomorrow.\n© 2025 YanthraLabs Pvt Ltd.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
