import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../enumm/storage_key_enum.dart';
import '../../../utils/storage_util.dart';
import 'account_data_service.dart';
import 'dao/account_dao.dart';

// 用户登陆账号信息相关
class AccountDataImpl extends GetxService implements AccountDataService {
  @override
  void delAccount(AccountStorageKeyEnum accountStorageKeyEnum) {
    GetStorageUtil.removeData(accountStorageKeyEnum.username);
    GetStorageUtil.removeData(accountStorageKeyEnum.password);

    debugPrint("删除 $accountStorageKeyEnum > > > 账号信息完成✅");
  }

  @override
  AccountDAO getAccount(AccountStorageKeyEnum accountStorageKeyEnum) {
    final username = GetStorageUtil.readData(accountStorageKeyEnum.username);
    final password = GetStorageUtil.readData(accountStorageKeyEnum.password);

    debugPrint("读取 $accountStorageKeyEnum > > > 账号信息完成✅");

    return AccountDAO(username: username, password: password);
  }

  @override
  void saveAccount(AccountStorageKeyEnum accountStorageKeyEnum, String username,
      String password) {
    GetStorageUtil.writeData(accountStorageKeyEnum.username, username);
    GetStorageUtil.writeData(accountStorageKeyEnum.password, password);

    debugPrint("保存 $accountStorageKeyEnum > > > 账号信息完成✅");
  }
}
