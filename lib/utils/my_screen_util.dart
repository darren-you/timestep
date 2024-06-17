import 'package:flutter/material.dart';

class MyScreenUtil {
  static final MyScreenUtil _screenUtil = MyScreenUtil._();

  late double screenHeight;
  late double screenWidth;
  late double statusBarHeight;
  late double bottomNavBarHeight;

  bool inited = false;

  MyScreenUtil._();

  factory MyScreenUtil._instance() {
    return _screenUtil;
  }

  static MyScreenUtil getInstance() => MyScreenUtil._instance();

  void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    statusBarHeight = MediaQuery.of(context).padding.top;
    bottomNavBarHeight = MediaQuery.of(context).padding.bottom;

    inited = true;
  }

  double getScreenHeight() {
    if (inited) throw Exception('ScreenUtil not init!');
    return screenHeight;
  }

  double getScreenWidth() {
    if (inited) throw Exception('ScreenUtil not init!');
    return screenWidth;
  }

  double getStatusBarHeight() {
    if (inited) throw Exception('ScreenUtil not init!');
    return statusBarHeight;
  }

  double getBottomNavBarHeight() {
    if (inited) throw Exception('ScreenUtil not init!');
    return bottomNavBarHeight;
  }
}

class Demo {
  void test() {
    MyScreenUtil._();
  }
}
