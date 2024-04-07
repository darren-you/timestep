import '../../../utils/api_path_util.dart';
import '../../../utils/dio_util.dart';
import 'app_info_api.dart';

class AppInfoApiImpl implements AppInfoApi {
  @override
  getAppInfo() {
    return DioUtil.get(ApiPathUtil.appInfo);
  }
}
