import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/container/custom_icon_button.dart';
import '../../../enumm/color_enum.dart';
import '../../../enumm/nav_enum.dart';
import 'components/course_week.dart';
import '../../../enumm/course_enum.dart';
import '../../../utils/assert_util.dart';
import '../../../utils/page_path_util.dart';
import 'timetable_vm.dart';

// 课表预览周item中Text颜色
Color courseItemTextColor(int index, int currentWeekIndex) {
  final vm = Get.find<TimeTableViewModel>();

  Color color = MyColors.textMain.color;

  if ((index + 1) == currentWeekIndex) {
    color = MyColors.textWhite.color;
  } else if ((index + 1) < vm.nowWeek) {
    color = MyColors.cardGrey2.color;
  }

  return color;
}

class TimeTablePages extends GetView<TimeTableViewModel> {
  const TimeTablePages({super.key});

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
                  //日期、第几周、菜单按钮
                  SizedBox(
                    height: 50.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 课表名称
                        Positioned(
                          left: 10,
                          child: GestureDetector(
                            onDoubleTap: () {
                              if (controller.changeCourseSate.value ==
                                  ChangeCourseEnum.on) {
                                controller.changeCourse(animate: true);
                              }
                            },
                            child: SizedBox(
                              height: 50,
                              width: 65,
                              child: Center(
                                child: Obx(
                                  () => Text(
                                    controller.courseModel.value.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: MyColors.textMain.color,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
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
                              // 展开周预览图菜单
                              controller.openMoreInfo();
                            },
                            onDoubleTap: () {
                              controller.toNowWeekPage();
                            },
                            child: Container(
                              //color: Colors.amber,
                              width: 100,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '第 ',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Obx(() => Text(
                                        controller.currentWeekIndex.value
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: controller
                                                      .currentWeekIndex.value ==
                                                  controller.nowWeek
                                              ? Colors.red
                                              : MyColors.iconGrey1.color,
                                        ),
                                      )),
                                  const Text(
                                    ' 周',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // 菜单按钮
                        Positioned(
                          right: 0,
                          child: CustomIconButton(
                            AssertUtil.iconMenu,
                            //background: Colors.blue,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            onTap: () {
                              Get.toNamed(PagePathUtil.timeTableSettingPage);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 隐藏菜单，显示课表周信息
                  Obx(
                    () => AnimatedContainer(
                      duration: const Duration(milliseconds: 360),
                      curve: Curves.easeInOut,
                      height: controller.isExpanded.value ? 50.h : 0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        controller: controller.courseWeekListController,
                        itemCount:
                            controller.courseModel.value.courseAllPages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              controller.tapCourseWeek(index);
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
                                  color: (index + 1) ==
                                          controller.currentWeekIndex.value
                                      ? MyColors.cardGreen.color
                                      : MyColors.cardGrey1.color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: courseItemTextColor(index,
                                          controller.currentWeekIndex.value),
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
                  ),
                  // 周标题栏
                  Container(
                    color: MyColors.background.color,
                    height: 26.h,
                    child: Row(
                      children: [
                        // 月
                        Container(
                          alignment: Alignment.center,
                          width: 36.w,
                          child: const Text("月"),
                        ),
                        // 一、二、三、四、五、六、日
                        Expanded(
                          child: Obx(() => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    controller.weekDay.value.day, (index) {
                                  return Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child:
                                          Text(WeekTextEnum.startM.text[index]),
                                    ),
                                  );
                                }).toList(),
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 课表内容
            Obx(() {
              debugPrint("绘制课程周视图Pages");

              return controller.courseModel.value.courseAllPages.isNotEmpty
                  ? Expanded(
                      child: PageView.builder(
                        itemCount:
                            controller.courseModel.value.courseAllPages.length,
                        controller: controller.pageController,
                        onPageChanged: (pageIndex) {
                          controller.changePage(pageIndex);
                        },
                        itemBuilder: (context, index) {
                          debugPrint("重新绘制 课表数据");
                          return CourseWeek(
                              controller
                                  .courseModel.value.courseAllPages[index],
                              index);
                        },
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                            height: 140.w,
                            width: 140.w,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('images/no_course.png'),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 12)),
                          const Center(
                            child: Text(
                              "暂无课表数据",
                              style: TextStyle(color: Colors.black45),
                            ),
                          )
                        ],
                      ),
                    );
            }),

            // 底部导航行高度
            Padding(
              padding:
                  EdgeInsets.only(bottom: NavigationOptions.hight55.height.h),
            ),
          ],
        ),
      ),
    );
  }
}
