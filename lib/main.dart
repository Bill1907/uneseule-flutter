import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/environment.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  // Initialize app configurations
  WidgetsFlutterBinding.ensureInitialized();

  // Log current environment
  debugPrint('Starting Uneseule app in ${Environment.current.name} mode');
  debugPrint('API Base URL: ${Environment.apiBaseUrl}');

  runApp(
    // ProviderScope is required for Riverpod state management
    const ProviderScope(child: UneseuleApp()),
  );
}

/// Root application widget
class UneseuleApp extends ConsumerWidget {
  const UneseuleApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Uneseule',
      debugShowCheckedModeBanner: false,

      // Apply custom theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Router configuration
      routerConfig: router,
    );
  }
}
