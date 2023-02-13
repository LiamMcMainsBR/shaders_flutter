import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;

  ShaderPainter(FragmentShader fragmentShader, this.time)
      : shader = fragmentShader;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.shader = shader;
    shader.setFloat(0, time);
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
