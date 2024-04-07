import 'dart:convert';

BaseResponse<T> successErrorDataFromJson<T>(String str) =>
    BaseResponse<T>.fromJson(json.decode(str));

String successErrorDataToJson<T>(BaseResponse<T> data) =>
    json.encode(data.toJson());

class BaseResponse<T> {
  BaseResponse({
    required this.code,
    required this.message,
    this.result,
  });

  String code;
  String message;
  T? result;

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse<T>(
        code: json["code"],
        message: json["message"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "result": result,
      };
}
