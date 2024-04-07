import '../../../enumm/storage_key_enum.dart';
import 'dao/account_dao.dart';

abstract class AccountDataService {
  // 存储账号
  void saveAccount(AccountStorageKeyEnum accountStorageKeyEnum, String username,
      String password);

  // 读取账号
  AccountDAO getAccount(AccountStorageKeyEnum accountStorageKeyEnum);

  // 删除账号
  void delAccount(
    AccountStorageKeyEnum accountStorageKeyEnum,
  );
}
