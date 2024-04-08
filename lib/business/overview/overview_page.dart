import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import 'overview_page_vm.dart';

class OverViewPage extends GetView<OverViewPageViewModel> {
  const OverViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: const SizedBox(),
    );
  }
}
