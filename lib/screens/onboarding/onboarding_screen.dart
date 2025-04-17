import 'package:euphor/core/theme/app_theme.dart';
import 'package:euphor/reusables/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  // ignore: unused_field
  bool _isLastPage = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.backgroundColor,
        actions: [
          TextButton(
            onPressed: () => _pageController.jumpToPage(2),
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
            children: const [
              OnboardingPage(
                title: 'Text 1',
                description:
                    'Welcome to our app! Here you can add more details about the first feature or benefit.',
                image: Icons.star, // Replace with your image
              ),
              OnboardingPage(
                title: 'Text 2',
                description:
                    'This is the second feature or benefit of your app. Make it compelling!',
                image: Icons.favorite, // Replace with your image
              ),
              WelcomeScreen(),
            ],
          ),

          // Navigation buttons and page indicator
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip button

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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
