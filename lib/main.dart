import 'package:euphor/firebase_options.dart';
import 'package:euphor/screens/logged_in_user_info.dart';
import 'package:euphor/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/onboarding_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: OnboardingService().hasSeenOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final hasSeenOnboarding = snapshot.data ?? false;
          return hasSeenOnboarding
              ? Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return auth.isAuthenticated
                        ? const LoggedInUserInfo()
                        : const WelcomeScreen();
                  },
                )
              : const OnboardingScreen();
        },
      ),
    );
  }
}
