import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:timestep/business/todo/todo_page_controller.dart';
import 'package:timestep/utils/color_util.dart';
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
            _todoWiget(controller),

            // 底部导航行高度
            Padding(
                padding: EdgeInsets.only(
                    bottom: NavigationOptions.hight55.height.h)),
          ],
        ),
      ),
    );
  }

  /// 自定义日期菜单栏
  Widget _dateInfoWidget(TodoPageController controller) {
    return SizedBox(
      height: 50.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 月份减
          Align(
            alignment: Alignment.centerLeft,
            child: Transform(
              transform: Matrix4.rotationZ(3.14159265358979323846), // π 弧度
              alignment: Alignment.center, // 确保旋转点在中心
              child: CustomIconButton(
                AssertUtil.iconGo,
                padding: EdgeInsets.only(right: 16.w),
                alignment: Alignment.centerRight,
                backgroundWidth: 50.h,
                backgroundHeight: 50.h,
                onTap: () => controller.monthLeftOrRight(isLeft: true),
              ),
            ),
          ),

          // 日期信息
          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: controller.tapDateTextInfo,
              onDoubleTap: controller.doubleTapDateTextInfo,
              child: Container(
                alignment: Alignment.center,
                height: 50.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 20.w),
                    Obx(() => Text(
                          controller.yearMonthText.value,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SizedBox(width: 4.w),
                    Obx(
                      () => controller.isExpanded.value
                          ? SvgPicture.asset(AssertUtil.iconTag,
                              width: 16.w, height: 16.w)
                          : Transform(
                              transform: Matrix4.rotationZ(
                                  3.14159265358979323846), // π 弧度
                              alignment: Alignment.center, // 确保旋转点在中心
                              child: SvgPicture.asset(AssertUtil.iconTag,
                                  width: 16.w, height: 16.w),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 月份加
          Align(
            alignment: Alignment.centerRight,
            child: CustomIconButton(
              AssertUtil.iconGo,
              padding: EdgeInsets.only(right: 16.w),
              alignment: Alignment.centerRight,
              backgroundWidth: 50.h,
              backgroundHeight: 50.h,
              onTap: () => controller.monthLeftOrRight(isLeft: false),
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
            return GestureDetector(
              onTap: () =>
                  controller.tapOneDay(controller.daysInMonthList.value[index]),
              child: Obx(
                () => Container(
                  margin: EdgeInsets.only(
                      left: index == 0 ? 8.w : 4.w,
                      top: 0,
                      right:
                          index == controller.daysInMonthList.value.length - 1
                              ? 8.w
                              : 4.w,
                      bottom: 8.w),
                  width: 42.h,
                  decoration: BoxDecoration(
                    color: controller.daysInMonthList.value[index] ==
                            controller.currentDayDateTime.value
                        ? MyColors.cardGreen.color
                        : MyColors.cardGrey1.color,
                    borderRadius: BorderRadius.circular(10.r),
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

  /// 时间margin
  double _timeMargin(int index) {
    var margin = 0.0.h;
    if (index == 0) {
      margin = 0.0.h;
    } else if (index == 1 || index == 24) {
      margin = 36.h;
    } else {
      margin = 44.h;
    }

    return margin;
  }

  /// ToDo 内容部分
  Widget _todoWiget(TodoPageController controller) {
    return Expanded(
      child: Obx(
        () => PageView.builder(
          itemCount: controller.daysInMonthList.value.length,
          controller: controller.todoPageController,
          onPageChanged: (pageIndex) =>
              controller.todoPageChanged(pageIndex + 1),
          itemBuilder: (context, index) {
            return MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 8.h,
                      child: Column(
                        children: List.generate(25, (index) {
                          return Container(
                            alignment: Alignment.topCenter,
                            width: 36.w,
                            //height: 60.h,
                            margin: EdgeInsets.only(top: _timeMargin(index)),
                            //color: ColorUtil.getRandomColor(),
                            child: Container(
                              alignment: Alignment.center,
                              height: 16.h,
                              //color: Colors.amber,
                              child: Text(
                                '$index:00',
                                style: TextStyle(fontSize: 10.sp),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Positioned(
                      //left: 36,
                      //top: 0,
                      child: Row(
                        children: [
                          SizedBox(width: 36.w),
                          Expanded(
                            child: Column(
                              children: [
                                SizedBox(height: 8.h),
                                Column(
                                  children: List.generate(24, (index) {
                                    return Container(
                                      alignment: Alignment.center,
                                      //margin: EdgeInsets.only(top: index == 0 ? 8.h : 0),
                                      height: 60.h,
                                      color: ColorUtil.getRandomColor(),
                                    );
                                  }),
                                ),
                                SizedBox(height: 8.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
