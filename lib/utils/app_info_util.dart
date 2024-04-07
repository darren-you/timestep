class AppInfoUtil {
  AppInfoUtil._();

  static String appVersion = '1.10.7';

  static bool isNewerVersion(String oldVersion, String newVersion) {
    List<String> oldVersionParts = oldVersion.split('.');
    List<String> newVersionParts = newVersion.split('.');

    for (int i = 0; i < newVersionParts.length; i++) {
      int newPart = int.parse(newVersionParts[i]);
      if (i >= oldVersionParts.length) {
        // 如果新版本有额外的部分（例如，1.0.0 vs 1.0.0.1），那么新版本是更新的
        if (newPart > 0) {
          return true;
        }
      } else {
        int oldPart = int.parse(oldVersionParts[i]);
        if (newPart > oldPart) {
          return true;
        } else if (newPart < oldPart) {
          // 如果任何部分的新版本比旧版本小，那么它不是更新的
          return false;
        }
      }
    }

    // 如果所有部分都相同，那么版本号不是更新的
    return false;
  }
}
