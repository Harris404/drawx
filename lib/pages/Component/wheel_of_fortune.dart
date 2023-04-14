import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math';

class WheelOfFortune extends StatefulWidget {
  final List<String> items;

  const WheelOfFortune({Key? key, required this.items}) : super(key: key);

  @override
  _WheelOfFortuneState createState() => _WheelOfFortuneState();
}

class _WheelOfFortuneState extends State<WheelOfFortune> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _spinAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _animation.addListener(() {
      setState(() {
        _spinAngle = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spinWheel() {
    _controller.stop();
    _controller.value = 0.0;
    final random = Random();
    final targetAngle = random.nextDouble() * 2 * pi;
    _animation = Tween<double>(begin: _spinAngle, end: _spinAngle + 2 * pi * 5 + targetAngle)
        .animate(_controller);
    _controller.forward();
  }
  Widget _buildPointer() {
    return Container(
      width: 5,
      height: 42,
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
        Transform.rotate(
          angle: _spinAngle,
          child: _buildWheel(),
        ),

        Positioned(
          top: 108,
          left: (MediaQuery.of(context).size.width / 2) -49,
          child: _buildPointer(),
        ),
        FloatingActionButton(
          onPressed: _spinWheel,
          child: const Icon(Icons.play_arrow),
        ),
      ],
    );

  }

  Widget _buildWheel() {
    return CustomPaint(
      size: Size.square(300),
      painter: _WheelPainter(items: widget.items),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<String> items;

  _WheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final double itemAngle = 2 * pi / items.length;
    final double radius = min(size.width, size.height) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < items.length; i++) {
      final double startAngle = i * itemAngle;
      final double sweepAngle = itemAngle;

      final Paint paint = Paint()
        ..color = Colors.accents[i % Colors.accents.length]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      final double textAngle = startAngle + sweepAngle / 2;
      final Offset textOffset = Offset(
        center.dx + radius * cos(textAngle) / 2,
        center.dy + radius * sin(textAngle) / 2,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: items[i],
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      textPainter.paint(canvas,
          textOffset - Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }
    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
    }
  }