import 'package:get_storage/get_storage.dart';

// 本地存储相关服务
class GetStorageUtil {
  GetStorageUtil._();

  static final _dataBox = GetStorage();

  // 写入数据
  static writeData(String key, dynamic writeData) {
    _dataBox.write(key, writeData);
  }

  // 读取数据
  static dynamic readData(String key) {
    return _dataBox.read(key);
  }

  // 是否拥有数据
  static bool hasData(String key) {
    return _dataBox.hasData(key);
  }

  // 删除数据
  static void removeData(String key) {
    _dataBox.remove(key);
  }

  //  删除所有数据
  static void clearAllData() {
    _dataBox.erase();
  }
}
