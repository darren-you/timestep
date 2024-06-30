import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../enumm/appbar_enum.dart';
import '../../utils/assert_util.dart';
import '../container/custom_icon_button.dart';

// 自定义状态栏控件
class NormalAppBar extends StatelessWidget {
  final Widget title;
  final Color? stateBarBackgroundColor;
  final Brightness? stateBarContentColor;
  final Color? color;
  final Widget? child;
  final VoidCallback? onTapBack;
  final Widget? rightIcon;
  final bool showBackIcon;
  final String? iconBack;

  const NormalAppBar({
    super.key,
    this.stateBarBackgroundColor = Colors.transparent,
    this.stateBarContentColor = Brightness.dark,
    this.color = Colors.transparent,
    this.child,
    required this.title,
    this.onTapBack,
    this.rightIcon,
    this.iconBack = AssertUtil.iconBack,
    this.showBackIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    var stateHeight = context.mediaQueryPadding.top;

    return Container(
      padding: EdgeInsets.only(top: stateHeight), // 设置顶部 AppBar 的顶部内边距为状态栏的高
      width: context.width,
      height: AppBarOptions.hight50.height + stateHeight,
      color: color,
      child: Stack(
        children: [
          // 左侧返回 Icon
          showBackIcon
              ? Positioned(
                  left: 0,
                  child: CustomIconButton(
                    iconBack!,
                    backgroundHeight: AppBarOptions.hight50.height,
                    backgroundWidth: AppBarOptions.hight50.height,
                    padding: const EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    //padding: const EdgeInsets.only(left: 12),
                    onTap: () {
                      onTapBack != null ? onTapBack!() : Get.back();
                    },
                  ),
                )
              : const SizedBox(),

          // 居中标题
          Align(
            alignment: Alignment.center,
            child: title,
          ),

          // 右侧 Icon
          if (rightIcon != null)
            Positioned(
              right: 0,
              child: rightIcon!,
            ),

          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     color: Colors.black12.withOpacity(0.05),
          //     height: 0.5,
          //   ),
          // )
        ],
      ),
    );
  }
}
