import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final VoidCallback? onTap; // 点击事件回调
  final List<Widget> body;
  final BorderRadiusGeometry? borderRadius;
  const SettingItem(
      {super.key, required this.body, this.borderRadius, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12), //设置底部间距
        height: 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: borderRadius ?? BorderRadius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: body,
        ),
      ),
    );
  }
}
