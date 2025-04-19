import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AnimatedTextStack extends StatefulWidget {
  const AnimatedTextStack({super.key});

  @override
  State<AnimatedTextStack> createState() => _AnimatedTextStackState();
}

class _AnimatedTextStackState extends State<AnimatedTextStack>
    with SingleTickerProviderStateMixin {
  final List<String> phrases = [
    'affirmations',
    'positivity',
    'health',
    'euphor'
  ];
  int currentIndex = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _startTextRotation();
  }

  void _startTextRotation() {
    timer = Timer.periodic(const Duration(seconds: 2), (Timer t) {
      if (currentIndex < phrases.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        t.cancel(); // stop once "euphor" is shown
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            Lottie.asset(
              "assets/lottie/roses.json",
              reverse: true,
              height: 300,
            ),
            const SizedBox(height: 16),
            Positioned(
              bottom: 115,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: AnimatedDefaultTextStyle(
                  key: ValueKey<String>(phrases[currentIndex]),
                  style: GoogleFonts.sourceSerif4(
                    textStyle: TextStyle(
                      color: const Color(0xFFF2EEAE),
                      fontSize: (currentIndex == 3) ? 64 : 52,
                      fontWeight: FontWeight.bold,
                      shadows: const [
                        Shadow(
                          offset: Offset(2, 10),
                          blurRadius: 100.0,
                          color: Color.fromARGB(173, 17, 89, 82),
                        ),
                      ],
                    ),
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: Text(
                    phrases[currentIndex],
                    key: ValueKey<String>(phrases[currentIndex]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
