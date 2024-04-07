// To parse this JSON data, do
//
//     final appInfoTo = appInfoToFromJson(jsonString);

import 'dart:convert';

AppInfoRecDTO appInfoToFromJson(String str) =>
    AppInfoRecDTO.fromJson(json.decode(str));

String appInfoToToJson(AppInfoRecDTO data) => json.encode(data.toJson());

class AppInfoRecDTO {
  String appVersion;
  String updateDesc;

  AppInfoRecDTO({
    required this.appVersion,
    required this.updateDesc,
  });

  factory AppInfoRecDTO.fromJson(Map<String, dynamic> json) => AppInfoRecDTO(
        appVersion: json["appVersion"],
        updateDesc: json["updateDesc"],
      );

  Map<String, dynamic> toJson() => {
        "appVersion": appVersion,
        "updateDesc": updateDesc,
      };
}
