import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../enumm/color_enum.dart';
import '../../enumm/nav_enum.dart';
import '../../utils/page_path_util.dart';
import 'bnp_vm.dart';
import 'nav_item_vo.dart';

// 底部导航栏Item
Widget navItem(Rx<BottomNavItemVO> item) {
  final controller = Get.find<BottomNavViewModel>();
  return Expanded(
    child: GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        controller.selectBottomNavItem(item);
      },
      onLongPress: () {
        if (controller.bottomNavItems.indexOf(item) == 2) {
          Get.toNamed(PagePathUtil.editBaseUrlPage);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => SvgPicture.asset(
                item.value.assertIcon,
                width: 30,
                height: 30,
                colorFilter: item.value.isSelected
                    ? ColorFilter.mode(MyColors.iconBlue.color, BlendMode.srcIn)
                    : null,
              ),
            ),
            Obx(() => Text(
                  item.value.text,
                  style: TextStyle(
                      color: item.value.isSelected
                          ? MyColors.iconBlue.color
                          : MyColors.iconGrey1.color,
                      fontSize: 12),
                )),
          ],
        ),
      ),
    ),
  );
}

class BottomNavPage extends GetView<BottomNavViewModel> {
  const BottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.width,
        height: context.height,
        // fix 此处使用padding.bottom 会造成iOS在App预览Card状态时，底部无内容
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        color: Colors.white,
        child: Stack(
          children: [
            // https://juejin.cn/post/6844903791972581390#comment 保存页面状态
            // ViewPager
            Align(
              alignment: Alignment.topCenter,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(), // 禁止滑动
                controller: controller.pageController,
                children: controller.pagerList,
                onPageChanged: (value) {
                  if (value == 2) {
                    // 初始化状态栏、导航栏
                    if (Platform.isAndroid) {
                      SystemChrome.setSystemUIOverlayStyle(
                          const SystemUiOverlayStyle(
                        statusBarIconBrightness: Brightness.light,
                      ));
                    } else if (Platform.isIOS) {
                      SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle.light.copyWith(
                        statusBarIconBrightness: Brightness.light,
                      ));
                    }
                  } else {
                    // 初始化状态栏、导航栏
                    if (Platform.isAndroid) {
                      SystemChrome.setSystemUIOverlayStyle(
                          const SystemUiOverlayStyle(
                        statusBarIconBrightness: Brightness.dark,
                      ));
                    } else if (Platform.isIOS) {
                      // iOS 状态栏深色、白色 只能修改 SystemUiOverlayStyle.dark / SystemUiOverlayStyle.light
                      SystemChrome.setSystemUIOverlayStyle(
                          SystemUiOverlayStyle.dark.copyWith(
                        statusBarIconBrightness: Brightness.dark,
                      ));
                    }
                  }
                },
              ),
            ),

            // 底部导航栏
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: context.width,
                height: NavigationOptions.hight55.height,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: controller.bottomNavItems.map((item) {
                    return navItem(item);
                  }).toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
