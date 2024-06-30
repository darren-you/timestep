import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timestep/business/todo/todo_page_controller.dart';
import 'package:timestep/services/app_init_service.dart';
import 'package:timestep/utils/date_util.dart';

import '../../components/container/custom_icon_button.dart';
import '../../enumm/color_enum.dart';
import '../../enumm/nav_enum.dart';
import '../../utils/assert_util.dart';

class TodoPage extends GetView<TodoPageController> {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Column(
          children: [
            // 自定义导航栏
            Container(
              padding: EdgeInsets.only(
                  top: context
                      .mediaQueryPadding.top), // 设置顶部 AppBar 的顶部内边距为状态栏的高
              color: Colors.white,
              child: Column(
                children: [
                  _dateInfoWidget(controller),
                  _invisibleDateTimeWidget(controller),
                ],
              ),
            ),

            // Todo内容
            Expanded(
              child: PageView.builder(
                itemCount: 5,
                //controller: controller.pageController,
                onPageChanged: (pageIndex) {},
                itemBuilder: (context, index) {
                  return Center(
                    child: Text("第 $index 页"),
                  );
                },
              ),
            ),

            // 底部导航行高度
            Padding(
                padding:
                    EdgeInsets.only(bottom: NavigationOptions.hight55.height)),
          ],
        ),
      ),
    );
  }

  /// 自定义日期菜单栏
  Widget _dateInfoWidget(TodoPageController controller) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 月份减
          Positioned(
            left: 16,
            child: Transform.rotate(
              angle: -600.0,
              child: CustomIconButton(
                AssertUtil.iconGo,
                onTap: () {
                  controller.monthLeftOrRight(isLeft: true);
                },
              ),
            ),
          ),

          // 日期信息
          Align(
            alignment: Alignment.center,
            child: // 居中标题第几周
                GestureDetector(
              onTap: () {
                // 展开月预览图菜单
                controller.tapDateTextInfo();
              },
              onDoubleTap: () {
                // 回到本月
                controller.doubleTapDateTextInfo();
              },
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                width: 100,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Text(controller.yearMonthText.value)),
                    SizedBox(width: 4.w),
                    Obx(
                      () => controller.isExpanded.value
                          ? SvgPicture.asset(AssertUtil.iconTag)
                          : Transform(
                              transform: Matrix4.rotationZ(
                                  3.14159265358979323846), // π 弧度
                              alignment: Alignment.center, // 确保旋转点在中心
                              child: SvgPicture.asset(AssertUtil.iconTag),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 月份加
          Positioned(
            right: 16,
            child: CustomIconButton(
              AssertUtil.iconGo,
              onTap: () {
                controller.monthLeftOrRight(isLeft: false);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 日item中Text颜色
  Color _dayItemTextColor(DateTime dayDateTime) {
    final nowDateTime = DateTime.now();
    Color color = MyColors.textMain.color;

    if (dayDateTime == controller.currentDayDateTime.value) {
      color = MyColors.textWhite.color;
    } else if (!(DateUtil.isSameDay(dayDateTime, nowDateTime)) &&
        dayDateTime.isBefore(nowDateTime)) {
      color = MyColors.cardGrey2.color;
    }

    return color;
  }

  /// 隐藏日期Scroller
  Widget _invisibleDateTimeWidget(TodoPageController controller) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        height: controller.isExpanded.value ? 50.h : 0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: controller.dayInMonthScrollController,
          itemCount: controller.daysInMonthList.value.length,
          itemBuilder: (context, index) {
            // logger.d(
            //     'datetimeNow: ${controller.currentDayDateTime.value} $index datetime: ${controller.daysInMonthList.value[index]}');
            return GestureDetector(
              onTap: () {
                controller.tapOneDay(controller.daysInMonthList.value[index]);
              },
              child: Obx(
                () => Container(
                  // margin: const EdgeInsets.symmetric(
                  //     horizontal: 4, vertical: 2),
                  margin: EdgeInsets.only(
                      left: index == 0 ? 8 : 4,
                      top: 0,
                      right:
                          index == controller.daysInMonthList.value.length - 1
                              ? 8
                              : 4,
                      bottom: 8),
                  // 一行显示 7 个周Item
                  //width: context.width / 7 - 8,
                  width: 42.h,
                  decoration: BoxDecoration(
                    color: controller.daysInMonthList.value[index] ==
                            controller.currentDayDateTime.value
                        ? MyColors.cardGreen.color
                        : MyColors.cardGrey1.color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                        color: _dayItemTextColor(
                            controller.daysInMonthList.value[index]),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
