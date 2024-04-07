import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

class WebDocPageViewModel extends GetxController {
  Color appbarBgColor = Colors.transparent;
  late String title;
  late String url;
  late WebViewController webViewController;

  @override
  void onInit() {
    final arg = Get.arguments as Map;
    title = arg["title"];
    url = arg["url"];
    appbarBgColor = arg["appbarBgColor"];

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            debugPrint("加载进度 > > >: $progress");
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));

    super.onInit();
  }
}
