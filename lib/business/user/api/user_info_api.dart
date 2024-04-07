abstract class UserInfoApi {
  // 用户登陆
  dynamic userLogin(String username, String password);

  // 注销账号
  dynamic delAccount(String verifyCode);
}
