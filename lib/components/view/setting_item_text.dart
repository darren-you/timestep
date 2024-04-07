import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/assert_util.dart';
import '../container/custom_container.dart';

class SettingItemText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // 点击事件回调
  final List<Widget>? body;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const SettingItemText({
    super.key,
    required this.text,
    this.body,
    this.borderRadius,
    this.onTap,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: padding,
      margin: margin,
      scale: false,
      onTap: onTap,
      borderRadius: borderRadius,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 16,
              child: Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Positioned(
              right: 16,
              child: SvgPicture.asset(
                AssertUtil.iconGo,
                width: 12,
                height: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
