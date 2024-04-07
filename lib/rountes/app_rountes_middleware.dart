import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enumm/storage_key_enum.dart';
import '../utils/page_path_util.dart';
import '../utils/storage_util.dart';

// 首次进入App需要读取本地数据进行登陆
class UserLoginMw extends GetMiddleware {
  UserLoginMw();

  @override
  RouteSettings? redirect(String? route) {
    // if (!GetStorageUtil.hasData(AccountStorageKeyEnum.appUser.username)) {
    //   debugPrint("$route 无本地 App用户账号信息❌ 重定向 -> AppRountes.userLoginPage");

    //   return const RouteSettings(name: PagePathUtil.userLoginPage);
    // }

    return super.redirect(route);
  }
}
