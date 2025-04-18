import 'package:euphor/core/theme/app_theme.dart';
import 'package:euphor/providers/auth_provider.dart';
import 'package:euphor/widgets/onboarding_page.dart';
import 'package:euphor/services/onboarding_service.dart';
import 'package:euphor/widgets/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    await OnboardingService().completeOnboarding();
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthWrapper()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLastPage
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: AppTheme.backgroundColor,
              actions: [
                TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),
              ],
            ),
      body: Stack(
        children: [
          // PageView with onboarding screens
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 2;
              });
            },
            children: [
              const OnboardingPage(
                title: 'Text 1',
                description:
                    'Welcome to our app! Here you can add more details about the first feature or benefit.',
                image: Icons.star, // Replace with your image
              ),
              const OnboardingPage(
                title: 'Text 2',
                description:
                    'This is the second feature or benefit of your app. Make it compelling!',
                image: Icons.favorite, // Replace with your image
              ),
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  if (authProvider.isAuthenticated) {
                    // If user is already authenticated, complete onboarding and go to AuthWrapper
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _completeOnboarding();
                    });
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const WelcomeScreen();
                },
              ),
            ],
          ),

          // Navigation buttons and page indicator
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip button
                TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),

                // Page indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    spacing: 16,
                    dotColor: Colors.grey.shade300,
                    activeDotColor: Theme.of(context).primaryColor,
                  ),
                ),

                // Next/Done button
                TextButton(
                  onPressed: () {
                    if (_isLastPage) {
                      _completeOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(_isLastPage ? 'Done' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
