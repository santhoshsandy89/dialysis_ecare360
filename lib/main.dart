import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import

import 'core/constants/app_constants.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'package:ecare360/features/session_management/presentation/providers/bp_entry_list_provider.dart'; // Add this import
import 'package:ecare360/features/session_management/presentation/providers/serology_provider.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // No longer using LocalStorageService.init() directly here.
  // SharedPreferences will be provided via Riverpod.

  // Initialize logger
  AppLogger.info('eCare360 app starting...');

  final prefs = await SharedPreferences.getInstance(); // Get SharedPreferences instance

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        // serologyProvider is implicitly dependent on sharedPreferencesProvider
        // and will get the overridden instance automatically.
        // bpEntryListProvider is also implicitly dependent on sharedPreferencesProvider.
      ],
      child: const ECare360App(),
    ),
  );
}

/// Main application widget
class ECare360App extends StatelessWidget {
  const ECare360App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Router configuration
      routerConfig: AppRouter.router,

      // Localization
      locale: const Locale('en', 'US'),
      supportedLocales: const [
        Locale('en', 'US'),
      ],
    );
  }
}
