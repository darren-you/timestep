import 'package:flutter/widgets.dart';

// 底部导航栏 Item
class BottomNavItemVO {
  String text;
  String assertIcon;
  VoidCallback onPressed;
  bool isSelected;

  BottomNavItemVO(this.text, this.assertIcon, this.onPressed,
      {this.isSelected = false});
}
