import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor, int alpha) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      // 设置透明度
      //一个16进制颜色#b74093. 因为Color还需要传入透明度, 255就是最大值(也就是不透明), 转为16进制就是0xFF, 所以我们只需这样表示:
      // const color = Color(0xffb74093);
      //print("透明度 alpha: ${alpha ~/ 100}");
      var opacity = 'FF';
      if (alpha <= 100 && 0 <= alpha) {
        opacity = (alpha / 100 * 255).toInt().toRadixString(16);
      }
      //print("透明度 $opacity");

      hexColor = "$opacity$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor, {int alpha = 100})
      : super(_getColorFromHex(hexColor, alpha));
}
