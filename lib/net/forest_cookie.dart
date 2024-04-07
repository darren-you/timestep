class ForestCookie {
  ForestCookie({
    required this.name,
    required this.value,
    required this.createTime,
    required this.maxAge,
    required this.domain,
    required this.path,
    required this.secure,
    required this.httpOnly,
    required this.hostOnly,
    required this.persistent,
    required this.expiresTime,
  });

  String name;
  String value;
  DateTime createTime;
  String maxAge;
  String domain;
  String path;
  bool secure;
  bool httpOnly;
  bool hostOnly;
  bool persistent;
  int expiresTime;

  factory ForestCookie.fromJson(Map<String, dynamic> json) => ForestCookie(
        name: json["name"],
        value: json["value"],
        createTime: DateTime.parse(json["createTime"]),
        maxAge: json["maxAge"],
        domain: json["domain"],
        path: json["path"],
        secure: json["secure"],
        httpOnly: json["httpOnly"],
        hostOnly: json["hostOnly"],
        persistent: json["persistent"],
        expiresTime: json["expiresTime"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "createTime": createTime.toIso8601String(),
        "maxAge": maxAge,
        "domain": domain,
        "path": path,
        "secure": secure,
        "httpOnly": httpOnly,
        "hostOnly": hostOnly,
        "persistent": persistent,
        "expiresTime": expiresTime,
      };
}
