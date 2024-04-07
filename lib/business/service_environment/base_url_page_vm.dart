import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'repository/base_url_service.dart';

class BaseUrlPageViewModel extends GetxController {
  final baseUrlService = Get.find<BaseUrlService>();

  TextEditingController textController = TextEditingController();

  int maxLines = 2;

  String baseUrlTemp = '';
  var errorInfo = ''.obs;

  void updateNickname() {
    if (errorInfo.value.isEmpty) {
      baseUrlService.saveURL(textController.text.toString());
      SmartDialog.showToast("修改成功!");
      SystemNavigator.pop();
      Get.back();
    }
  }

  @override
  void onInit() {
    super.onInit();

    baseUrlTemp = baseUrlService.getURL();
    textController.text = baseUrlTemp;

    textController.addListener(() {
      if (textController.text.isEmpty) {
        errorInfo.value = 'BaseUrl不能为空';
      } else {
        errorInfo.value = '';
      }
    });
  }
}
