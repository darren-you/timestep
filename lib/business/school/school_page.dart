import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../enumm/appbar_enum.dart';
import '../../enumm/color_enum.dart';
import '../../enumm/nav_enum.dart';
import '../../manager/app_user_info_manager.dart';
import '../time_table/course_table/timetable_vm.dart';
import 'school_page_vm.dart';
import 'vo/school_card_item_vo.dart';
import '../../components/container/custom_container.dart';
import '../../components/view/custom_swiper.dart';
import '../../enumm/course_enum.dart';
import '../../utils/assert_util.dart';
import '../../utils/page_path_util.dart';
import '../home_nav/bnp_vm.dart';
import 'vo/school_fun_vo.dart';

final vm = Get.find<SchoolPageViewModel>();
final navVM = Get.find<BottomNavViewModel>();
final timeTableVM = Get.find<TimeTableViewModel>();

// 功能Item实体
List<SchoolFunVO> schoolFunList = [
  // 第一行
  SchoolFunVO(AssertUtil.examsSvg, "教务网", () {
    Get.toNamed(PagePathUtil.jwwMainPage);
  }),

  SchoolFunVO(AssertUtil.roomSvg, "微校园", () {
    Get.toNamed(PagePathUtil.microCampusPage);
  }),
  SchoolFunVO(AssertUtil.examSvg, "失物招领", () {
    debugPrint("失物招领");
    Get.toNamed(PagePathUtil.lostAndFound);
  }),
  SchoolFunVO(AssertUtil.scoreSvg, "Fun4", () {}),
  SchoolFunVO(AssertUtil.scoreSvg, "Fun5", () {}),

  // 第二行
  SchoolFunVO(AssertUtil.scoreSvg, "Fun6", () {}),
  SchoolFunVO(AssertUtil.scoreSvg, "Fun7", () {}),
  SchoolFunVO(AssertUtil.scoreSvg, "Fun8", () {}),
  SchoolFunVO(AssertUtil.scoreSvg, "Fun9", () {}),
  SchoolFunVO(AssertUtil.scoreSvg, "Fun10", () {}),
];

// Card实体
List<SchoolCardItemVO> schoolCard = [
  SchoolCardItemVO(
    const Icon(
      Icons.wallet,
      color: Colors.white,
    ),
    Text(
      "今日课程",
      style: TextStyle(
        color: MyColors.textMain.color,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(vm.courseCardData.value.info),
            //
          ],
        )),
    Obx(
      () => Expanded(
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(4),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: MyColors.background.color,
          ),
          child: vm.courseCardData.value.data?.name != null
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        //color: MyColors.cardGrey1.color,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              vm.courseCardData.value.startTime,
                              style: const TextStyle(fontSize: 11),
                            ),
                            Text(vm.courseCardData.value.endTime,
                                style: const TextStyle(fontSize: 11))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 3,
                      child: Container(
                        //color: MyColors.cardGrey2.color,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              vm.courseCardData.value.data!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  vm.courseCardData.value.data!.teacher,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    vm.courseCardData.value.data!.address,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : null,
        ),
      ),
    ),
    () {
      navVM.selectBottomNavItem(navVM.bottomNavItems[0]);
      if (timeTableVM.selectCourse == SelectCourseEnum.second) {
        timeTableVM.changeCourse(animate: false);
      } else {
        timeTableVM.toNowWeekPage(animate: false);
      }
    },
  ),
  SchoolCardItemVO(
      const Icon(
        Icons.wallet,
        color: Colors.white,
      ),
      Text(
        "Other Fun",
        style: TextStyle(
          color: MyColors.textMain.color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      Obx(
        () => Expanded(
          child: Container(
            width: double.infinity,
            //color: Colors.amber,
            child: vm.courseCardData.value.data?.name != null
                ? Text(vm.courseCardData.value.data!.name)
                : null,
          ),
        ),
      ),
      null,
      () => {}),
];

Widget _swiperBg(BuildContext context, SchoolPageViewModel controller) {
  return const CustomContainer(
    color: Colors.transparent,
    duration: Duration(milliseconds: 200),
    foreAnim: false,
    scaleValue: 0.96,
    child: CustomSwiper(
      imgUrlList: [
        "https://singlestep.cn/wejinda/res/img/swiper_1.jpeg",
        "https://singlestep.cn/wejinda/res/img/swiper_2.jpeg",
        "https://singlestep.cn/wejinda/res/img/swiper_3.jpeg",
        "https://singlestep.cn/wejinda/res/img/swiper_4.jpeg",
        "https://singlestep.cn/wejinda/res/img/swiper_5.jpeg",
        "https://singlestep.cn/wejinda/res/img/swiper_6.jpeg",
      ],
    ),
  );
}

Widget _customAppBar(BuildContext context, SchoolPageViewModel controller) {
  return // 自定义导航栏
      Align(
    alignment: Alignment.topCenter,
    child: Container(
      padding: EdgeInsets.only(
          top: context.mediaQueryPadding.top, left: 12, right: 12),
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: Colors.white),
      height: 50 + context.mediaQueryPadding.top,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            child: SizedBox(
              width: 36,
              height: 36,
              child: Obx(
                () => (AppUserInfoManager().isLogined() &&
                        AppUserInfoManager()
                            .appUserDTO
                            .value!
                            .userImg
                            .isNotEmpty)
                    ? ClipOval(
                        child: ExtendedImage.network(
                          AppUserInfoManager().appUserDTO.value!.userImg,
                          fit: BoxFit.contain,
                          cache: true,
                          //mode: ExtendedImageMode.editor,
                        ),
                      )
                    : ClipOval(
                        child: Container(
                          width: 36,
                          height: 36,
                          color: Colors.grey,
                          child: const Center(
                            child: Text("未登陆", style: TextStyle(fontSize: 8)),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const Positioned(
            right: 0,
            child: Icon(Icons.notifications),
          ),
        ],
      ),
    ),
  );
}

class SchoolPage extends GetView<SchoolPageViewModel> {
  const SchoolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: const SizedBox(),
    );
  }
}
