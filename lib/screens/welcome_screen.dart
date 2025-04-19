import 'dart:ui';
import 'package:euphor/core/routes/fade_route.dart';
import 'package:euphor/core/theme/app_theme.dart';
import 'package:euphor/widgets/animated_text_stack.dart';
import 'package:euphor/widgets/filled_concentric_circle_painter.dart';
import 'package:euphor/widgets/auth_wrapper.dart';
import 'package:euphor/widgets/glassmorphic_sign_in_button.dart';
import 'package:flutter/cupertino.dart';
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
            const Center(
              child: SizedBox(
                height: 300,
                child: AnimatedTextStack(),
                // child: Stack(children: [
                //   Lottie.asset(
                //     "assets/lottie/roses.json",
                //     reverse: true,
                //   ),
                //   Positioned(
                //     bottom: 110,
                //     left: 60,
                //     child: Text(
                //       'euphor',
                //       textAlign: TextAlign.center,
                //       style: GoogleFonts.sourceSerif4(
                //         textStyle: const TextStyle(
                //           color: AppTheme.accentColor,
                //           fontSize: 64,
                //           fontWeight: FontWeight.bold,
                //           fontFamily: 'SourceSerif4',
                //         ),
                //         shadows: [
                //           const Shadow(
                //             offset: Offset(2, 10),
                //             blurRadius: 100.0,
                //             color: Color.fromARGB(173, 17, 89, 82),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ]),
              ),
            ),
            Positioned(
              // width: 390,
              // bottom: 80,
              // left: 10,
              width: MediaQuery.of(context).size.width * 0.9,
              bottom: MediaQuery.of(context).size.height * 0.08,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GlassmorphicSignInButton(
                    authProvider: authProvider,
                    text: "Sign in with Google",
                    isLoading: authProvider.isLoading,
                    leading: Image.network(
                      'https://www.google.com/favicon.ico',
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () async {
                      try {
                        await authProvider
                            .signInWithGoogleAccountPicker(context);
                        if (authProvider.isAuthenticated && context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            FadeRoute(page: const AuthWrapper()),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error signing in: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (hasPrevUser)
                    GlassmorphicSignInButton(
                      authProvider: authProvider,
                      text: 'Continue with ${_previousUser!.displayName}',
                      leading: const Icon(
                        CupertinoIcons.person_alt_circle_fill,
                        color: AppTheme.accentColor,
                        size: 26,
                      ),
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        try {
                          await authProvider.signInSilentlyWithLastUsedAccount(
                              context, _previousUser);
                          if (authProvider.isAuthenticated && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthWrapper()),
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
                    )
                ],
              ),
            ),
          ]),
          // Updated Google Sign In Button
        ));
  }
}
