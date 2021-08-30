// To parse this JSON data, do
//
//     final dynamicOrderDetailsResponse = dynamicOrderDetailsResponseFromJson(jsonString);

import 'dart:convert';

DynamicOrderDetailsResponse dynamicOrderDetailsResponseFromJson(String str) => DynamicOrderDetailsResponse.fromJson(json.decode(str));

String dynamicOrderDetailsResponseToJson(DynamicOrderDetailsResponse data) => json.encode(data.toJson());

class DynamicOrderDetailsResponse {
  DynamicOrderDetailsResponse({
    this.status,
    this.data,
  });

  int status;
  Data data;

  factory DynamicOrderDetailsResponse.fromJson(Map<String, dynamic> json) => DynamicOrderDetailsResponse(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.stringData,
  });

  String stringData;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    stringData: json["string_data"],
  );

  Map<String, dynamic> toJson() => {
    "string_data": stringData,
  };
}
