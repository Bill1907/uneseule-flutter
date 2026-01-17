import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/environment.dart';
import 'features/webview/presentation/screens/webview_screen.dart';

void main() {
  // Initialize app configurations
  WidgetsFlutterBinding.ensureInitialized();

  // Log current environment
  debugPrint(
    'Starting Uneseule WebView app in ${Environment.current.name} mode',
  );
  debugPrint('WebApp URL: ${Environment.webAppUrl}');

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}
