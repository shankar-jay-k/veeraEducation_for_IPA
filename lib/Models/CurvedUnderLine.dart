import 'package:flutter/material.dart';

class CurvedDivider extends StatelessWidget {
  final Color color;
  final double height;

  const CurvedDivider({
    required this.color,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(

      size: Size(MediaQuery.of(context).size.width * 0.2, 15),
      painter: CurvedUnderlinePainter(
        color: color,
        height: height,
      ),
    );
  }
}

class CurvedUnderlinePainter extends CustomPainter {
  final Color color;
  final double height;

  CurvedUnderlinePainter({
    required this.color,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height - (height / 4));
    path.quadraticBezierTo(size.width / 2, -(size.height / 0.6),size.width, size.height - (height / 2),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}