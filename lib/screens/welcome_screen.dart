import 'dart:ui';
import 'package:euphor/core/routes/fade_route.dart';
import 'package:euphor/core/theme/app_theme.dart';
import 'package:euphor/reusables/filled_concentric_circle_painter.dart';
import 'package:euphor/widgets/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  GoogleSignInAccount? _previousUser;
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<Color> circleShades = [
    const Color(0xFF5f7e52), // darkest outer
    const Color(0xFF718e61),
    const Color(0xFF819d6f),
    const Color(0xFF91ab7d),
    const Color(0xFFa2bf8e), // lightest center
  ];
  @override
  void initState() {
    super.initState();
    _loadPreviousGoogleUser();
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPreviousGoogleUser() async {
    final user = await GoogleSignIn().signInSilently();
    if (mounted) {
      setState(() {
        _previousUser = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPrevUser = _previousUser != null;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Stack(children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: FilledConcentricCirclePainter(
                    progress: _animation.value,
                    shades: circleShades,
                  ),
                  child: Container(),
                );
              },
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color: Colors.transparent, // required to trigger the blur
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            try {
                              await authProvider
                                  .signInWithGoogleAccountPicker(context);
                              // Navigate to AuthWrapper if sign in successful
                              if (authProvider.isAuthenticated && mounted) {
                                Navigator.pushReplacement(context,
                                    FadeRoute(page: const AuthWrapper())
                                    // MaterialPageRoute(
                                    //   builder: (context) => const AuthWrapper(),
                                    // ),
                                    );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Error signing in: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                'https://www.google.com/favicon.ico',
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                  if (hasPrevUser)
                    ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              try {
                                await authProvider
                                    .signInSilentlyWithLastUsedAccount(
                                        context, _previousUser);
                                // Navigate to AuthWrapper if sign in successful
                                if (authProvider.isAuthenticated && mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AuthWrapper(),
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Error signing in: ${e.toString()}'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: authProvider.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  'https://www.google.com/favicon.ico',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Sign in with ${_previousUser!.email}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                    )
                ],
              ),
            ),
          ]),
          // Updated Google Sign In Button
        ));
  }
}
