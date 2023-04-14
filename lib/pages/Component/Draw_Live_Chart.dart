import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:drawx/pages/Component/wheel_of_fortune.dart';

class LivePieChart extends StatefulWidget {
  final List<double> data;
  final List<String> labels;

  LivePieChart({required this.data, required this.labels});

  @override
  _LivePieChartState createState() => _LivePieChartState();
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height-30),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class _LivePieChartState extends State<LivePieChart> {
  List<Color> colors = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0XffFA4A42),
    const Color(0xffFE9539),
    Colors.yellow
  ];

  double _rotationAngle = 0;

  Widget _buildPointer() {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomPaint(
            size: Size(60, 60),
            painter: _PointerPainter(),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections =
    _generateSectionsFromData(widget.data, widget.labels);

    return Stack(
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 5,
            startDegreeOffset: -90 + _rotationAngle,
            borderData: FlBorderData(
              show: false,
            ),
            sections: sections,
          ),
        ),
        _buildPointer(), // 添加指针部件
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.rotate_right),
            onPressed: () {
              setState(() {
                _rotationAngle += Random().nextInt(1080) + 570;
              });
            },
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _generateSectionsFromData(
      List<double> data, List<String> labels) {
    return List.generate(data.length, (index) {
      final value = data[index];
      final color = colors[index % colors.length];
      final label = labels[index];

      return PieChartSectionData(
        value: value,
        radius: 150,
        color: color,
        title: '',
        showTitle: false,
        titlePositionPercentageOffset: 0.5,
        badgeWidget: Text(
          label,
          style:
          const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        badgePositionPercentageOffset: 0.5,
      );
    });
  }
}


//Draw Live Widget moved here
class DrawLiveWidget extends StatefulWidget {
  const DrawLiveWidget({super.key});

  @override
  _DrawLiveWidgetState createState() => _DrawLiveWidgetState();
}

class _DrawLiveWidgetState extends State<DrawLiveWidget> {
  List<double> prob = [];
  List<String> options = [];
  final TextEditingController _controller = TextEditingController();

  void _calculateProb() {
    prob.add(1.0);
    for (int i = 0; i < options.length; i++) {
      prob[i] = (1 / options.length) * 100.0;
    }
  }

  void _checkEmptyElement() {
    if (options.contains("")) {
      prob.remove(prob[0]);
      options.removeWhere((item) => item.isEmpty);
    }
    _calculateProb();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: SizedBox(
            height: 300,
            width: 300,
            child: WheelOfFortune(items: options), // 修改为 WheelOfFortune 小部件
          ),
        ),
        SizedBox(
          width: 450,
          height: 60,
          child: TextField(
            obscureText: false,
            controller: _controller,
            onSubmitted: (value) {
              setState(() {
                options.add(_controller.text);
                _checkEmptyElement();
                _controller.clear();
              });
            },
            decoration: InputDecoration(
              suffix: TextButton(
                onPressed: () {
                  setState(() {
                    options.add(_controller.text);
                    _checkEmptyElement();
                    _controller.clear();
                  });
                },
                child: const Text('Add'),
              ),
              border: const OutlineInputBorder(),
              labelText: "Name",
            ),
          ),
        ),
      ],
    );
  }
}