import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import '../../../components/view/setting_item_text.dart';
import '../../../enumm/color_enum.dart';
import '../../../manager/app_user_info_manager.dart';
import '../../../utils/assert_util.dart';
import '../../../utils/page_path_util.dart';
import 'user_page_vm.dart';

/// 用户性别图标
Widget _sexIcon(UserPageViewModel controller) {
  if (AppUserInfoManager().appUserDTO.value!.sex!.isEmpty ||
      AppUserInfoManager().appUserDTO.value!.sex! == '保密') {
    return const SizedBox();
  }
  if (AppUserInfoManager().appUserDTO.value!.sex == '男') {
    return SvgPicture.asset(
      AssertUtil.manSvg,
      width: 26,
      height: 26,
    );
  }
  if (AppUserInfoManager().appUserDTO.value!.sex == '女') {
    return SvgPicture.asset(
      AssertUtil.womanSvg,
      width: 26,
      height: 26,
    );
  }

  return const SizedBox();
}

/// 用户背景图片
Widget _userBg(BuildContext context, UserPageViewModel controller) {
  debugPrint("用户背景图片 ----------------重新绘制");
  return Obx(
    // Transform.translate offset实现背景图部分，与ListView同时发生移动
    () => Transform.translate(
      offset: Offset(
          0, controller.offset.value < 0 ? 0 : -(controller.offset.value)),
      child: Container(
        color: Colors.transparent,
        height: context.height / 2.9,
        width: context.width,
        child: Transform.scale(
          scale: controller.userBgPicScale.value,
          child: Stack(
            children: [
              AppUserInfoManager().isLogined()
                  ? SizedBox(
                      height: context.height / 2.91,
                      width: context.width,
                      child: ExtendedImage.network(
                        AppUserInfoManager()
                                .appUserDTO
                                .value!
                                .userBgImg!
                                .isEmpty
                            //userbgdefault
                            ? "https://singlestep.cn/wejinda/res/img/mybg1.jpg"
                            : AppUserInfoManager().appUserDTO.value!.userBgImg!,
                        fit: BoxFit.cover,
                        cache: true,
                        //cancelToken: cancellationToken,
                      ),
                    )
                  : SizedBox(
                      height: context.height / 2.91,
                      width: context.width,
                      child: ExtendedImage.asset(
                        AssertUtil.userBg,
                        fit: BoxFit.cover,
                        //cancelToken: cancellationToken,
                      ),
                    ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0, 1),
                    end: const Alignment(0, -0.2),
                    colors: [
                      //Colors.blue,
                      MyColors.background.color,
                      MyColors.background.color.withOpacity(0.6),
                      MyColors.background.color.withOpacity(0.0),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _userLogined(BuildContext context, UserPageViewModel controller) {
  return Container(
    //color: Colors.amber,
    height: context.height / 3.2,
    child: Column(
      children: [
        // 头像、性别、专业
        GestureDetector(
          onTap: () => Get.toNamed(PagePathUtil.accountPage),
          child: Container(
            margin: const EdgeInsets.only(top: 60),
            height: 60,
            child: Row(
              children: [
                // 头像
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ClipOval(
                    child: ExtendedImage.network(
                      AppUserInfoManager().appUserDTO.value!.userImg,
                      fit: BoxFit.contain,
                      //mode: ExtendedImageMode.editor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // 信息部分
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppUserInfoManager().appUserDTO.value!.username,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        //const SizedBox(height: 12),
                        Row(
                          children: [
                            // 性别
                            _sexIcon(controller),
                            const SizedBox(
                              width: 4,
                            ),
                            // 专业
                            (AppUserInfoManager()
                                        .appUserDTO
                                        .value!
                                        .major!
                                        .isNotEmpty &&
                                    AppUserInfoManager()
                                            .appUserDTO
                                            .value!
                                            .major !=
                                        '保密')
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: MyColors.cardGreen.color,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      AppUserInfoManager()
                                          .appUserDTO
                                          .value!
                                          .major!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),

                            (AppUserInfoManager().appUserDTO.value!.sex ==
                                        '保密' &&
                                    AppUserInfoManager()
                                            .appUserDTO
                                            .value!
                                            .major ==
                                        '保密')
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      '待完善',
                                      style: TextStyle(
                                        color: MyColors.textSecond.color,
                                        fontSize: 10,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  child: SvgPicture.asset(
                    AssertUtil.iconGo,
                    width: 12,
                    height: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),
        Expanded(
          child: Container(
            alignment: Alignment.topLeft,
            //color: Colors.amber,
            child: Text(
              AppUserInfoManager().appUserDTO.value!.introduction ?? '',
              maxLines: 2,
              style: const TextStyle(
                overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _userNotLogin(BuildContext context, UserPageViewModel controller) {
  return Container(
    alignment: Alignment.topCenter,
    height: context.height / 3.2,
    child: GestureDetector(
      onTap: () => Get.toNamed(PagePathUtil.userLoginPage),
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(top: 60),
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 信息部分
            const Text(
              '去登陆',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Align(
              child: SvgPicture.asset(
                AssertUtil.iconGo,
                width: 12,
                height: 12,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class UserPage extends GetView<UserPageViewModel> {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint(
        'screen height: ${context.mediaQuery.size.height} status height: ${context.mediaQueryPadding.top} bottom height: ${context.mediaQueryPadding.bottom}');
    return Scaffold(
      backgroundColor: MyColors.background.color,
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(), // 这里设置滚动物理属性
          children: [
            const SizedBox(height: 12),
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                //color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SettingItemText(
                    borderRadius: BorderRadius.circular(10),
                    text: "We锦大公众号",
                    onTap: () {
                      debugPrint("点击 We锦大公众号");
                    },
                  ),
                  SettingItemText(
                    text: "关于We锦大",
                    onTap: () {
                      debugPrint("点击 关于We锦大");
                      Get.toNamed(PagePathUtil.aboutWejindaPage);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
