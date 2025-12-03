import 'dart:ui';

import 'package:ecare360/core/constants/app_routes.dart';
import 'package:ecare360/core/utils/logger.dart';
import 'package:ecare360/data/models/bed_status_model.dart';
import 'package:ecare360/data/models/doctor_model.dart';
import 'package:ecare360/data/models/patient_model.dart';
import 'package:ecare360/data/services/auth_service.dart';
import 'package:ecare360/data/services/bed_status_service.dart';
import 'package:ecare360/data/services/local_storage_service.dart';
import 'package:ecare360/data/services/user_service.dart';
import 'package:ecare360/features/auth/presentation/providers/auth_provider.dart';
import 'package:ecare360/features/home/presentation/providers/bed_status_provider.dart';
import 'package:ecare360/features/home/presentation/providers/doctor_provider.dart';
import 'package:ecare360/features/home/presentation/providers/patient_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CombinedLoginScreen extends ConsumerStatefulWidget {
  const CombinedLoginScreen({super.key});

  @override
  ConsumerState<CombinedLoginScreen> createState() =>
      _CombinedLoginScreenState();
}

class _CombinedLoginScreenState extends ConsumerState<CombinedLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();

    _emailController.text = "samuel.j@yanthralabs.com";
    _passwordController.text = "yanthra123";
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // LOGIN LOGIC
  // ---------------------------------------------------------------------------

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty) return _showError("Please enter your email.");
    if (password.isEmpty) return _showError("Please enter your password.");

    setState(() => _isLoading = true);

    try {
      final responseIdentity =
          await AuthService().verifyUserIdentity(email: email, phone: null);

      final userId = responseIdentity['userid'];
      final username = responseIdentity['username'];

      final responsePassword = await AuthService().verifyUserPassword(
        userId: userId,
        password: password,
        host: '',
      );

      final accessToken = responsePassword['data']['accesstoken'];
      final refreshToken = responsePassword['data']['refreshtoken'];

      await ref.read(authProvider.notifier).setTokens(
            accessToken,
            refreshToken,
            username,
            userId,
          );

      await _prefetchAppData(accessToken);

      if (_rememberMe) {
        await LocalStorageService.saveEmail(email);
        await LocalStorageService.savePassword(password);
        await LocalStorageService.setRememberMe(true);
      } else {
        LocalStorageService.clearSavedLogin();
      }

      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      _showError(e.toString().replaceFirst("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _prefetchAppData(String token) async {
    try {
      final userService = UserService();
      final bedStatusService = BedStatusService();

      final patients = await _fetchPatients(userService, token);
      final doctors = await _fetchDoctors(userService, token);
      final beds = await _fetchBedStatus(bedStatusService, token);

      ref.read(patientProvider.notifier).setPatients(patients);
      ref.read(doctorProvider.notifier).setDoctors(doctors);
      ref.read(bedStatusProvider.notifier).setBedStatuses(beds);
    } catch (e) {
      _showError("Failed to load data: $e");
    }
  }

  Future<List<PatientModel>> _fetchPatients(
      UserService userService, String token) async {
    final data = await userService.fetchPatients(token);
    final list = data.map((e) => PatientModel.fromJson(e)).toList();

    await LocalStorageService.savePatientsList(list);
    AppLogger.debug("✔ Patients cached");

    return list;
  }

  Future<List<DoctorModel>> _fetchDoctors(
      UserService userService, String token) async {
    final data = await userService.fetchDoctors(token);
    final list = data.map((e) => DoctorModel.fromJson(e)).toList();

    await LocalStorageService.saveDoctorsList(list);
    AppLogger.debug("✔ Doctors cached");

    return list;
  }

  Future<List<BedStatusModel>> _fetchBedStatus(
      BedStatusService service, String token) async {
    final data = await service.fetchBedStatuses(token);

    await LocalStorageService.saveBedStatuses(data);
    AppLogger.debug("✔ Bed statuses cached");

    return data;
  }

  // ---------------------------------------------------------------------------
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  // ---------------------------------------------------------------------------
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        /// SAME SPLASH THEME GRADIENT
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

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildLogo(),
                const SizedBox(height: 30),

                _buildGlassCard(), // ⬅ Glassmorphism Card added

                const SizedBox(height: 40),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGETS (REFACTORED)
  // ---------------------------------------------------------------------------

  Widget _buildLogo() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.4),
            blurRadius: 25,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset('assets/logo.jpg', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildInputFields() {
    return Column(
      children: [
        // EMAIL
        TextField(
          controller: _emailController,
          decoration: _inputStyle("Email", Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),

        // PASSWORD
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _inputStyle("Password", Icons.lock_outline).copyWith(
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              activeColor: Colors.white,
              checkColor: Colors.blueGrey,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
            ),
            const Text(
              "Remember Me",
              style: TextStyle(color: Colors.white),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.white70),
              ),
            )
          ],
        ),
      ],
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.10),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white, width: 1.4),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blueAccent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.blue)
            : const Text(
                "Login",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return const Text(
      "Yanthra Labs • AI Powered CRM\n© 2025 YanthraLabs Private Limited",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 12,
        height: 1.4,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Future<void> _loadSavedCredentials() async {
    final email = await LocalStorageService.getSavedEmail();
    final pass = await LocalStorageService.getSavedPassword();
    final remember = await LocalStorageService.getRememberMe();

    if (remember == true) {
      setState(() {
        _rememberMe = true;
        _emailController.text = email ?? "";
        _passwordController.text = pass ?? "";
      });
    }
  }

  Widget _buildGlassCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 30,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _buildInputFields(),
              const SizedBox(height: 25),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}
