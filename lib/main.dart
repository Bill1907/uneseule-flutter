import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/environment.dart';
import 'core/theme/app_theme.dart';

void main() {
  // Initialize app configurations
  WidgetsFlutterBinding.ensureInitialized();

  // Log current environment
  debugPrint('🚀 Starting Uneseule app in ${Environment.current.name} mode');
  debugPrint('📡 API Base URL: ${Environment.apiBaseUrl}');

  runApp(
    // ProviderScope is required for Riverpod state management
    const ProviderScope(child: UneseuleApp()),
  );
}

/// Root application widget
class UneseuleApp extends StatelessWidget {
  const UneseuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uneseule',
      debugShowCheckedModeBanner: false,

      // Apply custom theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Temporary home screen (will be replaced with proper navigation)
      home: const HomeScreen(),
    );
  }
}

/// Temporary home screen for Phase 0 POC
///
/// This will be replaced with proper navigation and feature screens
/// as we implement Issues #2, #3, #4, #5
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('윤슬 (Uneseule)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.pets,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Welcome text
            Text(
              'Welcome to Uneseule',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Voice AI Companion Doll',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 48),

            // Environment info
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    context,
                    'Environment',
                    Environment.current.name.toUpperCase(),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'API URL', Environment.apiBaseUrl),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Phase 0 Status
            Text(
              '🚧 Phase 0 POC - Issue #1 Complete',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Next: Bluetooth, API, WebRTC integration',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Flexible(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
