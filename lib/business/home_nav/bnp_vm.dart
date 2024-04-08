import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timestep/business/overview/overview_page.dart';

import '../../components/view/custom_bottom_sheet_msg_dialog.dart';
import '../../components/keep_alive_wrapper.dart';
import '../../manager/app_user_info_manager.dart';
import '../../utils/app_info_util.dart';
import '../../utils/assert_util.dart';
import '../app/check_update/dto/app_info_rec_dto.dart';
import 'nav_item_vo.dart';
import '../app/api/app_info_api.dart';
import '../user/api/user_info_api.dart';
import '../user/repository/account_data_service.dart';
import '../../net/net_manager.dart';
import '../../utils/page_path_util.dart';
import '../user/account_center/user_page.dart';
import '../todo/todo_page.dart';
import '../time_table/course_table/time_table_page.dart';
import '../user/account_center/user_page_vm.dart';

class BottomNavViewModel extends GetxController {
  final accountDataService = Get.find<AccountDataService>();
  final userInfoApi = Get.find<UserInfoApi>();
  final userVm = Get.find<UserPageViewModel>();
  final appInfoApi = Get.find<AppInfoApi>();
  // ViewPageController默认选中第一页
  final pageController = PageController(initialPage: 0);

  // PagerView 中加载的页面
  final pagerList = const [
    KeepAliveWrapper(child: TimeTablePages()),
    KeepAliveWrapper(child: TodoPage()),
    KeepAliveWrapper(child: OverViewPage()),
  ];

  // 底部导航栏 Item
  final bottomNavItems = [
    BottomNavItemVO("课表", AssertUtil.iconCourse, () {}, isSelected: true).obs,
    BottomNavItemVO("日程", AssertUtil.iconCourse, () {}).obs,
    BottomNavItemVO("概览", AssertUtil.iconMy, () {}).obs,
  ];

  // 点击底部导航栏Item时，将对应的Item设为选中状态
  void selectBottomNavItem(Rx<BottomNavItemVO> currentItem) {
    var currentPageIndex = pageController.page;
    var netPageIndex = bottomNavItems.indexOf(currentItem);
    if ((currentPageIndex! - netPageIndex).abs() != 1) {
      pageController.jumpToPage(netPageIndex);
    } else {
      // 让ViewPager滑动到选中页面
      pageController.animateToPage(
        netPageIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
      );
    }

    // 更改 ItemModel 状态
    for (var item in bottomNavItems) {
      item.update((oldItem) {
        oldItem?.isSelected = (item == currentItem);
      });
    }
  }

  /// App账号自动登陆
  Future<void> _appUserLogin() async {
    debugPrint("进入软件自动登录: > > > > ");
    await AppUserInfoManager().autoAppUserLogin();
    debugPrint("进入软件自动登录完成: > > > > ✅");
  }

  /// 检测app更新
  void _checkAppUpdate() {
    NetManager.request(
        netFun: appInfoApi.getAppInfo(),
        onDataSuccess: (rightData) async {
          final appInfoTo = AppInfoRecDTO.fromJson(rightData);

          final newAppVersion = appInfoTo.appVersion; // 1.0.1
          final oldAppVersion = AppInfoUtil.appVersion; // 1.0.0

          if (AppInfoUtil.isNewerVersion(
              AppInfoUtil.appVersion, appInfoTo.appVersion)) {
            showBottomMsgDialog(
              Get.context!,
              title: "软件更新",
              msg: "本地: $oldAppVersion    —>    最新: $newAppVersion 🌃",
              rightButtonText: '查看',
              entr: () {
                Get.toNamed(PagePathUtil.appUpdatePage,
                    arguments: appInfoTo.updateDesc);
              },
            );
          }
        });
  }

  @override
  void onReady() async {
    super.onReady();

    // 这里需要在 onReady 生命周期中才，自动登录，不然UiTree还未绘制完成
    await _appUserLogin();
    _checkAppUpdate();
  }
}
