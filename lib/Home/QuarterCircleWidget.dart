import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
class QuarterCirclePainter extends CustomPainter {
  final CircleAlignment circleAlignment;
  final Color color;

  const QuarterCirclePainter({required this.circleAlignment, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = 44.0;
    final offset = circleAlignment == CircleAlignment.topLeft
        ? Offset(.0, .0)
        : circleAlignment == CircleAlignment.topRight
        ? Offset(size.width, .0)
        : circleAlignment == CircleAlignment.bottomLeft
        ? Offset(.0, size.height)
        : Offset(size.width, size.height);
    canvas.drawCircle(offset, radius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(QuarterCirclePainter oldDelegate) {
    return color == oldDelegate.color &&
        circleAlignment == oldDelegate.circleAlignment;
  }
}
enum CircleAlignment {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}
