import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:timestep/business/todo/todo_page_controller.dart';
import 'package:timestep/components/container/custom_container.dart';
import 'package:timestep/services/app_init_service.dart';

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

  /// 日期、第几周、菜单按钮
  Widget _dateInfoWidget(TodoPageController controller) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 课表名称
          Positioned(
            left: 32,
            child: CustomContainer(
              borderRadius: BorderRadius.circular(25),
              scaleValue: 0.9,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 34,
                height: 34,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  //color: MyColors.background.color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Transform.rotate(
                  angle: -600.0,
                  child: SvgPicture.asset(AssertUtil.iconGo),
                ),
              ),
            ),
          ),

          // 标题周信息
          Align(
            alignment: Alignment.center,
            child: // 居中标题第几周
                GestureDetector(
              onTap: () {
                // 展开月预览图菜单
                controller.tapDateTextInfo();
              },
              onDoubleTap: () {},
              child: Container(
                //color: Colors.amber,
                alignment: Alignment.center,
                width: 100,
                height: 50,
                child: Text(controller.monthDayText.value),
              ),
            ),
          ),

          // 菜单按钮
          Positioned(
            right: 32,
            child: CustomContainer(
              borderRadius: BorderRadius.circular(25),
              scaleValue: 0.9,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: 34,
                height: 34,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  //color: MyColors.background.color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SvgPicture.asset(AssertUtil.iconGo),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 课表预览周item中Text颜色
  Color _dayItemTextColor(DateTime dayDateTime) {
    Color color = MyColors.textMain.color;

    if (dayDateTime == controller.currentDayDateTime.value) {
      color = MyColors.textWhite.color;
    } else if (dayDateTime.isBefore(controller.currentDayDateTime.value)) {
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
          controller: controller.dateTimeScrollController,
          itemCount: controller.daysInMonthList.value.length,
          itemBuilder: (context, index) {
            logger.d(
                'datetimeNow: ${controller.currentDayDateTime.value} $index datetime: ${controller.daysInMonthList.value[index]}');
            return GestureDetector(
              onTap: () {
                //controller.tapCourseWeek(index);
              },
              child: Obx(
                () => Container(
                  // margin: const EdgeInsets.symmetric(
                  //     horizontal: 4, vertical: 2),
                  margin: const EdgeInsets.only(
                      left: 4, top: 0, right: 4, bottom: 8),
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
