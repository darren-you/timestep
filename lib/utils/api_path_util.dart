import 'package:get/get.dart';

import '../business/service_environment/repository/base_url_service.dart';

class ApiPathUtil {
  static final baseUrlService = Get.find<BaseUrlService>();
  ApiPathUtil._();

  // static const String springBootBaseUrl = "https://darrenyou.cn/wejinda";
  //static const String springBootBaseUrl = "http://192.168.27.5:8080/wejinda";

  static const String appInfo = "/app/info";
  static const String userLogin = "/user/login";

  static String getSpringBootBaseUrl() {
    return baseUrlService.getURL();
  }

  static void setSpringBootBaseUrl(String baseUrl) {
    return baseUrlService.saveURL(baseUrl);
  }
}
