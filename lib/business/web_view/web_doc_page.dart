import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../components/appbar/normal_appbar.dart';
import '../../components/view/custom_body.dart';
import '../../enumm/appbar_enum.dart';
import '../../enumm/color_enum.dart';
import 'web_doc_page_vm.dart';

class WebDocPage extends GetView<WebDocPageViewModel> {
  const WebDocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: CustomBody(
        appBar: NormalAppBar(
          title: Text(
            controller.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          color: controller.appbarBgColor,
        ),
        scroller: false,
        body: SizedBox(
          height: context.height -
              AppBarOptions.hight50.height -
              context.mediaQueryPadding.top -
              context.mediaQueryPadding.bottom,
          width: context.width,
          child: WebViewWidget(controller: controller.webViewController),
        ),
      ),
    );
  }
}
