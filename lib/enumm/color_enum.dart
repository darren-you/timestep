import 'package:flutter/material.dart';

/*
  @description 定义自定义颜色枚举类
 */
enum MyColors {
  background1(color: Color.fromARGB(250, 240, 240, 240)),
  background(color: Color(0xFFF4F6F5)),
  // 文本相关
  textMain(color: Color(0xFF333333)), // 主要文本颜色
  textSecond(color: Color(0xFFCCCCCC)), // 灰色
  textRed(color: Color(0xFFFE0000)), // 红色字体
  textBlue(color: Color(0xFF0099FF)), // 蓝色字体
  textWhite(color: Colors.white), // 白色字体

  // 图标相关
  iconGrey1(color: Color(0xFFCCCCCC)), // 灰色1
  iconGrey2(color: Color(0xFFE6E6E6)), // 灰色2
  iconBlue(color: Color(0xFF0099FF)), // 蓝色
  iconBlack(color: Color(0xFF333333)), // 黑色图标

  // Card 相关
  cardWhite(color: Colors.white), // 白色
  cardBackground(color: Color(0xFFFAFAFA)), // 背景浅灰色
  cardGrey1(color: Color(0xFFF0F0F0)), // 灰色1
  cardGrey2(color: Color(0xFFCCCCCC)), // 灰色2
  cardGreen(color: Color(0xFF2EC84E)),
  coloBlue(color: Color(0xFF0099FF)),

  // Notifaction阴影
  notifationBackground(color: Colors.black12),

  endColor(color: Colors.amber);

  final Color color;
  const MyColors({
    required this.color,
  });
}
