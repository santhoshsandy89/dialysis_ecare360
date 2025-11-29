import 'package:ecare360/core/constants/app_colors.dart';
import 'package:ecare360/core/utils/validators.dart';
import 'package:ecare360/data/services/auth_service.dart';
import 'package:ecare360/features/auth/domain/entities/auth_state.dart';
import 'package:ecare360/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UsernameScreen extends ConsumerStatefulWidget {
  const UsernameScreen({super.key});

  @override
  ConsumerState<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends ConsumerState<UsernameScreen> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // Hardcode for development
    _usernameController.text = "samuel.j@yanthralabs.com";
  }

  Future<void> _verifyUsername() async {
    if (_usernameController.text.isEmpty) {
      _showSnackBar('Please enter your username, email, or phone number.');
      return;
    }

    ref.read(authProvider.notifier).setLoading(true);

    try {
      final String input = _usernameController.text.trim();
      final bool isEmail = input.contains('@');

      final response = await AuthService().verifyUserIdentity(
        email: isEmail ? input : null,
        phone: !isEmail ? input : null,
      );

      if (mounted) {
        context.pushNamed(
          'password',
          queryParameters: {
            'username': response['username'] as String,
            'userId': response['userid'] as String,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        ref.read(authProvider.notifier).setLoading(false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final formKey = GlobalKey<FormState>();
    ref.listen(authProvider, (previous, next) {
      if (next.hasError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage ?? 'An error occurred'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;

          return isWide
              ? Row(
                  children: [
                    /// LEFT PANEL — Landscape
                    Expanded(
                      flex: 1,
                      child: _buildLeftPanel(),
                    ),

                    /// RIGHT PANEL — Landscape
                    Expanded(
                      flex: 1,
                      child: _buildRightPanel(authState, formKey),
                    ),
                  ],
                )
              : Column(
                  children: [
                    /// LEFT PANEL — Portrait (on top)
                    _buildLeftPanel(),

                    /// RIGHT PANEL — Portrait (below)
                    Expanded(
                      child: _buildRightPanel(authState, formKey),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF63D489),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            child: Image.asset(
              'assets/logo.jpg',
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Yanthra Labs: AI Powered CRM Solution',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Delivering innovative, customized IT solutions that enhance efficiency and drive success in a digital-driven world.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(
    AuthState authState,
    GlobalKey<FormState> formKey,
  ) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Log In to Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF63D489),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: authState.isLoading ? null : _verifyUsername,
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Innovating AI-Powered Solutions for a Smarter Tomorrow.\n© 2025 YanthraLabs Private Limited. All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
