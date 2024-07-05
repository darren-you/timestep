import '../../../utils/storage_util.dart';
import 'base_url_service.dart';

class BaseUrlImpl implements BaseUrlService {
  @override
  String getURL() {
    var baseUrl = GetStorageUtil.readData("BaseUrl");

    if (baseUrl == null || baseUrl == "") {
      baseUrl = "https://darrenyou.cn/wejinda";
    }
    return baseUrl;
  }

  @override
  void saveURL(String baseURL) {
    GetStorageUtil.writeData("BaseUrl", baseURL);
  }
}
