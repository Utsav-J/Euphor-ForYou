import 'package:euphor/core/routes/fade_route.dart';
import 'package:euphor/providers/auth_provider.dart';
import 'package:euphor/screens/main_screen.dart';
import 'package:euphor/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (authProvider.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${authProvider.error}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        FadeRoute(page: const WelcomeScreen()),
                      );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!authProvider.isAuthenticated) {
          return const WelcomeScreen();
        }

        return const MainScreen();
      },
    );
  }
}
