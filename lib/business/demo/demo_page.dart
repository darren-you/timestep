import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'demo_page_controller.dart';

class DemoPage extends GetView<DemoPageController> {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(controller.state.toString()),
          )
        ],
      ),
    );
  }
}
