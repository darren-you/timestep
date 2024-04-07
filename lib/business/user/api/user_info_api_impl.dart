import 'user_info_api.dart';

class UserInfoApiImpl implements UserInfoApi {
  @override
  userLogin(String username, String password) {
    final body = {
      "username": username,
      "password": password,
    };
  }

  @override
  delAccount(String verifyCode) {
    final query = {
      "verifyCode": verifyCode,
    };
  }
}
