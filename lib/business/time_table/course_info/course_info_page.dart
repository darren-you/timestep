import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/appbar/normal_appbar.dart';
import '../../../components/container/custom_container.dart';
import '../../../components/container/custom_icon_button.dart';
import '../../../components/input/custom_date_picker.dart';
import '../../../components/input/custom_edit.dart';
import '../../../components/view/custom_body.dart';
import '../../../components/view/custom_bottom_sheet.dart';
import '../../../enumm/appbar_enum.dart';
import '../../../enumm/color_enum.dart';
import '../../../utils/assert_util.dart';
import 'course_info_page_vm.dart';

class CourseInfoPage extends GetView<CourseInfoPageViewModel> {
  const CourseInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    var stateHeight = context.mediaQueryPadding.top;

    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: CustomBody(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        appBar: NormalAppBar(
          title: const Text(
            "课表信息",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          rightIcon: CustomIconButton(
            AssertUtil.iconDone,
            backgroundHeight: AppBarOptions.hight50.height,
            backgroundWidth: AppBarOptions.hight50.height,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            onTap: () {
              controller.updateCourseData();
            },
          ),
        ),
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 16)),
            SizedBox(
              height: Get.height -
                  (AppBarOptions.hight50.height + stateHeight + 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 16),
                          alignment: Alignment.centerLeft,
                          height: 66,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "课表名称",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Expanded(
                                  child: CustomEdit(
                                editController: controller.courseNameController,
                              )),
                            ],
                          )),
                      const Padding(padding: EdgeInsets.only(bottom: 16)),
                      Container(
                        width: double.infinity,
                        height: 120,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                alignment: Alignment.centerLeft,
                                height: 60,
                                //color: Colors.amber,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "起始日期",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    CustomContainer(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      //startColor: MyColors.cardGrey1.color,
                                      //endColor: MyColors.cardGrey2.color,
                                      color: MyColors.cardGrey1.color,
                                      borderRadius: BorderRadius.circular(50),
                                      scale: false,
                                      child: Center(
                                        child: Obx(() => Text(formatDate(
                                            controller.courseModel.value
                                                .termStartTime,
                                            [yyyy, '-', m, '-', d]))),
                                      ),
                                      onTap: () {
                                        showMyBottomSheet(
                                          context,
                                          showChild: CustomDatePicekr(
                                            title: "选择日期",
                                            selectNowDate: true,
                                            defaultSelectDateTime: controller
                                                .courseModel
                                                .value
                                                .termStartTime,
                                            startYear: int.parse(formatDate(
                                                controller.courseModel.value
                                                    .termStartTime,
                                                [yyyy])),
                                            endYear: int.parse(formatDate(
                                                controller.courseModel.value
                                                    .termStartTime,
                                                [yyyy])),
                                            enter: (selectTime) {
                                              debugPrint("选择时间: $selectTime");
                                              controller
                                                  .updateCourseTermStartTime(
                                                      selectTime);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                alignment: Alignment.centerLeft,
                                height: 60,
                                //color: Colors.amber,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "课程颜色",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                        Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                        Container(
                                          height: 36,
                                          width: 36,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(50)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomContainer(
                    margin:
                        const EdgeInsets.only(left: 64, right: 64, bottom: 32),
                    scale: true,
                    duration: const Duration(milliseconds: 200),
                    color: MyColors.iconBlue.color,
                    borderRadius: BorderRadius.circular(6),
                    child: const SizedBox(
                      height: 46,
                      child: Center(
                        child: Text(
                          "删除",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    onTap: () {
                      controller.delCourse();
                    },
                  )
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 16)),
          ],
        ),
      ),
    );
  }
}
