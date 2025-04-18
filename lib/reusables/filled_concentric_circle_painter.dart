import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class FilledConcentricCirclePainter extends CustomPainter {
  final double progress;
  final List<Color> shades;

  FilledConcentricCirclePainter({required this.progress, required this.shades});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = sqrt(pow(size.width, 2) + pow(size.height, 2));

    for (int i = 0; i < shades.length; i++) {
      final double offset = i * 0.2;
      final double phase = (progress + offset) % 1;
      final double radius = phase * maxRadius;

      final Paint paint = Paint()
        ..style = PaintingStyle.fill
        ..color = shades[i].withOpacity(1 - phase);

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
