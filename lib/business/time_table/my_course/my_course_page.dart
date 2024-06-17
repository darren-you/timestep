import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../components/container/custom_container.dart';
import '../../../components/container/custom_icon_button.dart';
import '../../../components/view/custom_body.dart';
import '../../../components/appbar/normal_appbar.dart';
import '../../../components/view/custom_bottom_sheet.dart';
import '../../../components/view/setting_item_text.dart';
import '../../../enumm/appbar_enum.dart';
import '../../../enumm/color_enum.dart';
import '../../../enumm/course_enum.dart';
import '../../../utils/assert_util.dart';
import '../../../utils/my_screen_util.dart';
import '../course_table/timetable_vm.dart';
import 'model/course_info.dart';
import '../repository/local_test_course_data.dart';
import '../../../utils/page_path_util.dart';
import '../course_setting/seeting_page_vm.dart';
import 'my_course_page_vm.dart';

/// 课程Item颜色
Color itemColor(int index) {
  final controller = Get.find<TimeTableSeetingPageViewModel>();

  if (index == 0) {
    return MyColors.cardGreen.color;
  } else if (index == 1 &&
      controller.changeCourseEnum.value == ChangeCourseEnum.on) {
    return MyColors.iconBlue.color;
  } else {
    return Colors.white;
  }
}

/// 点击导入课表Icon
Future<dynamic> _showBottomSheet(BuildContext context) {
  // 点击添加按钮，弹出BottomSheet
  return showMyBottomSheet(
    context,
    showChild: Container(
      color: Colors.white,
      width: context.width,
      height: 262,
      margin: EdgeInsets.only(bottom: context.mediaQueryPadding.bottom),

      /// iPhone 存在导航条
      child: Column(
        children: [
          Container(
            //color: Colors.amber,
            height: 60,
            child: const Center(
              child: Text(
                "导入课表",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 120,
            child: Column(
              children: [
                SettingItemText(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  text: "从教务网导入",
                  borderRadius: BorderRadius.circular(0),
                  onTap: () {
                    Navigator.pop(context); // 关闭BottomSheet在路由
                    Get.toNamed(PagePathUtil.importFromJwwPage);
                  },
                ),
                SettingItemText(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  text: "从分享口令导入",
                  borderRadius: BorderRadius.circular(0),
                  onTap: () {
                    Get.find<TimeTableViewModel>().importCourseData(
                        CourseInfo.getCourseInfoList(
                            localTestCourseData['result']),
                        "测试课表",
                        DateTime.now(),
                        CourseItemColorEnum.color_2);

                    Get.find<MyCoursePageViewModel>().getAllCourseModel();

                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 82,
            padding: const EdgeInsets.all(16),
            //color: Colors.amber,
            child: CustomContainer(
              duration: const Duration(milliseconds: 200),
              borderRadius: BorderRadius.circular(30),
              color: MyColors.background.color,
              child: Center(
                child: Text(
                  "取消",
                  style: TextStyle(
                    color: MyColors.textMain.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                debugPrint("点击按钮...");
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

/// 所有课程列表
Widget _courseList(BuildContext context) {
  final controller = Get.find<MyCoursePageViewModel>();
  final ttspVM = Get.find<TimeTableSeetingPageViewModel>();

  return Obx(
    () => AnimationLimiter(
      child: ReorderableListView.builder(
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            key: ValueKey("$index"),
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              // 滑动动画效果
              verticalOffset: 50.0,
              child: FadeInAnimation(
                // 淡入动画效果
                child: CustomContainer(
                  scale: false,
                  onTap: () {
                    controller.updateCourseModel(index);
                  },
                  margin: EdgeInsets.only(bottom: 16, top: index == 0 ? 16 : 0),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  borderRadius: BorderRadius.circular(12),
                  color: itemColor(index),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller
                              .allCourseModel.value.courseModelList[index].name,
                          style: TextStyle(
                            color: index == 0 ||
                                    (index == 1 &&
                                        ttspVM.changeCourseEnum.value ==
                                            ChangeCourseEnum.on)
                                ? Colors.white
                                : MyColors.textMain.color,
                            fontSize: 20,
                          ),
                        ),
                        SvgPicture.asset(
                          AssertUtil.iconGo,
                          colorFilter: index == 0 ||
                                  (index == 1 &&
                                      ttspVM.changeCourseEnum.value ==
                                          ChangeCourseEnum.on)
                              ? const ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn)
                              : null,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: controller.allCourseModel.value.courseModelList.length,
        onReorder: (oldIndex, newIndex) {
          // 如果newIndex超出了范围，将其设置为列表长度减一
          if (newIndex >
              controller.allCourseModel.value.courseModelList.length) {
            newIndex =
                controller.allCourseModel.value.courseModelList.length - 1;
          }
          // 如果拖拽的是向下移动，则减去1，因为Flutter在计算新索引时会将其加1
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          controller.reorderCourse(oldIndex, newIndex);
        },
        onReorderStart: (index) {
          // 每次开始拖拽时触发触觉反馈
          HapticFeedback.heavyImpact();
        },
        proxyDecorator: (Widget child, int index, Animation<double> animation) {
          // 使用Tween链来定义缩小再放大的动画
          final Animation<double> scaleAnimation = TweenSequence<double>([
            TweenSequenceItem(
                tween: Tween<double>(begin: 1.0, end: 0.95), weight: 30),
            TweenSequenceItem(
                tween: Tween<double>(begin: 0.95, end: 1.04), weight: 70),
          ]).animate(animation);

          return AnimatedBuilder(
            animation: scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: scaleAnimation.value,
                alignment: Alignment.center, // 确保变换是相对于中心的
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 6, // 扩散范围
                        blurRadius: 20, // 模糊程度
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: child,
                  ),
                ),
              );
            },
            child: child,
          );
        },
      ),
    ),
  );
}

class MyCoursePage extends GetView<MyCoursePageViewModel> {
  const MyCoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        scroller: true,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        appBarHeight: MyScreenUtil.getInstance().statusBarHeight +
            AppBarOptions.hight50.height,
        appBar: NormalAppBar(
          title: const Text(
            "我的课表",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          rightIcon: CustomIconButton(
            AssertUtil.iconAdd,
            alignment: Alignment.centerRight,
            backgroundHeight: AppBarOptions.hight50.height,
            backgroundWidth: AppBarOptions.hight50.height,
            padding: const EdgeInsets.only(right: 16),
            onTap: () {
              _showBottomSheet(context);
            },
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: context.height -
                context.mediaQueryPadding.top -
                context.mediaQueryPadding.bottom -
                AppBarOptions.hight50.height,
            width: context.width,
            child: _courseList(context),
          ),
        ),
      ),
    );
  }
}
