import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:timestep/utils/my_screen_util.dart';

import 'rountes/app_rountes.dart';
import 'rountes/app_rountes_listener.dart';
import 'services/app_init_service.dart';
import 'utils/page_path_util.dart';

// flutter build apk --split-per-abi

// Xcode编译问题
// delete Podfile
// run 【flutter clean】, 【flutter pub get】 in your Flutter program, then Podfile will be generated
// In new Podfile, adjust platform to 14.0 and Uncomment that line
// run 【pod install】 in your iOS program
void main() async {
  // 全局初始化
  await AppInitService.init();
  runApp(const WejindaApp());
}

class WejindaApp extends StatelessWidget {
  const WejindaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          // navigatorKey: Toast.navigatorKey, //加上此配置
          //navigatorObservers: [FlutterSmartDialog.observer],
          // Dialog 初始化
          builder: FlutterSmartDialog.init(),
          initialRoute: PagePathUtil.bottomNavPage,
          getPages: AppRountes.appRoutes,
          defaultTransition: Transition.native, // 页面跳转默认动画
          routingCallback: RoutingListener.routingListner,
          theme: ThemeData(platform: TargetPlatform.iOS),
          debugShowCheckedModeBanner: true,
          onInit: () {
            MyScreenUtil.getInstance().init(context);
          },
        );
      },
    );
  }
}
