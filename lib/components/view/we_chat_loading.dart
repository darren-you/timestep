import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_util.dart';

class CircleLoadingIndicator extends StatefulWidget {
  const CircleLoadingIndicator({super.key});

  @override
  CircleLoadingIndicatorState createState() => CircleLoadingIndicatorState();
}

class CircleLoadingIndicatorState extends State<CircleLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          alignment: Alignment.center,
          width: context.width / 2.6,
          height: context.width / 2.6,
          decoration: BoxDecoration(
            color: HexColor("4E4E4E"),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 24),
              Text(
                "正在加载...",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}
