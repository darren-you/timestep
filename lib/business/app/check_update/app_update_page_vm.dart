import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/app_info_api.dart';
import '../../../utils/app_info_util.dart';
import '../../../net/net_manager.dart';
import 'dto/app_info_rec_dto.dart';

class AppUpdatePageViewModel extends GetxController {
  final appInfoApi = Get.find<AppInfoApi>();
  final oldAppVersion = AppInfoUtil.appVersion; // 1.0.0

  var updateDesc = ''.obs;
  final Uri _url = Uri.parse('https://singlestep.cn/wejinda/app/download');

  Future<void> downloadApk() async {
    if (!await launchUrl(_url)) {
      throw Exception('打开链接 $_url 错误');
    }
  }

  @override
  void onInit() {
    super.onInit();

    if (null != Get.arguments) {
      updateDesc.value = Get.arguments;
    } else {
      _checkAppUpdate();
    }
  }

  // 检测app更新
  void _checkAppUpdate() {
    NetManager.request(
        netFun: appInfoApi.getAppInfo(),
        onDataSuccess: (rightData) async {
          final appInfoTo = AppInfoRecDTO.fromJson(rightData);
          updateDesc.value = appInfoTo.updateDesc;
        });
  }
}
