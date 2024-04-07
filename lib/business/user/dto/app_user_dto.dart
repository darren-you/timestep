import 'dart:convert';

AppUserDTO appUserDtoFromJson(String str) =>
    AppUserDTO.fromJson(json.decode(str));

String appUserDtoToJson(AppUserDTO data) => json.encode(data.toJson());

class AppUserDTO {
  String username;
  String password;
  String? introduction;
  String? sex;
  String? major;
  String userImg;
  String? userBgImg;
  String email;
  String? loginToken;
  String? userId;
  String? createDate;

  AppUserDTO({
    required this.username,
    required this.password,
    this.introduction,
    this.sex,
    this.major,
    required this.userImg,
    this.userBgImg,
    required this.email,
    this.loginToken,
    this.userId,
    this.createDate,
  });

  AppUserDTO copyWith({
    String? username,
    String? password,
    String? introduction,
    String? sex,
    String? major,
    String? userImg,
    String? userBgImg,
    String? email,
    String? loginToken,
    String? userId,
    String? createDate,
  }) {
    return AppUserDTO(
      username: username ?? this.username,
      password: password ?? this.password,
      introduction: introduction ?? this.introduction,
      sex: sex ?? this.sex,
      major: major ?? this.major,
      userImg: userImg ?? this.userImg,
      userBgImg: userBgImg ?? this.userBgImg,
      email: email ?? this.email,
      loginToken: loginToken ?? this.loginToken,
      userId: userId ?? this.userId,
      createDate: createDate ?? this.createDate,
    );
  }

  factory AppUserDTO.fromJson(Map<String, dynamic> json) => AppUserDTO(
        username: json["username"],
        password: json["password"],
        introduction: json["introduction"] ?? '',
        sex: json["sex"] ?? '',
        major: json["major"] ?? '',
        userImg: json["userImg"],
        userBgImg: json["userBgImg"] ?? '',
        email: json["email"],
        loginToken: json["loginToken"],
        userId: json["userId"],
        createDate: json["createDate"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "introduction": introduction,
        "sex": sex,
        "major": major,
        "userImg": userImg,
        "userBgImg": userBgImg,
        "email": email,
        "loginToken": loginToken,
        "userId": userId,
        "createDate": createDate,
      };
}
