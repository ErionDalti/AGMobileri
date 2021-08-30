// To parse this JSON data, do
//
//     final manualPlaceOrderResponse = manualPlaceOrderResponseFromJson(jsonString);

import 'dart:convert';

ManualPlaceOrderResponse manualPlaceOrderResponseFromJson(String str) => ManualPlaceOrderResponse.fromJson(json.decode(str));

String manualPlaceOrderResponseToJson(ManualPlaceOrderResponse data) => json.encode(data.toJson());

class ManualPlaceOrderResponse {
  ManualPlaceOrderResponse({
    this.status,
    this.data,
  });

  int status;
  Data data;

  factory ManualPlaceOrderResponse.fromJson(Map<String, dynamic> json) => ManualPlaceOrderResponse(
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
    this.jsonObject,
  });

  JsonObject jsonObject;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    jsonObject: JsonObject.fromJson(json["json_object"]),
  );

  Map<String, dynamic> toJson() => {
    "json_object": jsonObject.toJson(),
  };
}

class JsonObject {
  JsonObject({
    this.order,
    this.paymentMethod,
  });

  Order order;
  ManualPaymentMethod paymentMethod;

  factory JsonObject.fromJson(Map<String, dynamic> json) => JsonObject(
    order: Order.fromJson(json["order"]),
    paymentMethod: ManualPaymentMethod.fromJson(json["payment_method"]),
  );

  Map<String, dynamic> toJson() => {
    "order": order.toJson(),
    "payment_method": paymentMethod.toJson(),
  };
}

class Order {
  Order({
    this.track,
    this.couponId,
    this.couponCode,
    this.discount,
    this.shippingMethodId,
    this.shippingMethodName,
    this.shippingCharge,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.statusString,
  });

  dynamic track;
  dynamic couponId;
  dynamic couponCode;
  int discount;
  int shippingMethodId;
  String shippingMethodName;
  int shippingCharge;
  int userId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String statusString;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    track: json["track"],
    couponId: json["coupon_id"],
    couponCode: json["coupon_code"],
    discount: json["discount"],
    shippingMethodId: json["shipping_method_id"],
    shippingMethodName: json["shipping_method_name"],
    shippingCharge: json["shipping_charge"],
    userId: json["user_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    statusString: json["status_string"],
  );

  Map<String, dynamic> toJson() => {
    "track": track,
    "coupon_id": couponId,
    "coupon_code": couponCode,
    "discount": discount,
    "shipping_method_id": shippingMethodId,
    "shipping_method_name": shippingMethodName,
    "shipping_charge": shippingCharge,
    "user_id": userId,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
    "status_string": statusString,
  };
}

class ManualPaymentMethod {
  ManualPaymentMethod({
    this.id,
    this.name,
    this.description,
    this.type,
    this.min,
    this.max,
    this.cred1,
    this.cred2,
    this.cred3,
    this.percentCharge,
    this.fixedCharge,
    this.status,
    this.className,
    this.createdAt,
    this.updatedAt,
    this.inputs,
  });

  int id;
  String name;
  String description;
  String type;
  int min;
  int max;
  dynamic cred1;
  dynamic cred2;
  dynamic cred3;
  int percentCharge;
  int fixedCharge;
  int status;
  dynamic className;
  DateTime createdAt;
  DateTime updatedAt;
  List<Input> inputs;

  factory ManualPaymentMethod.fromJson(Map<String, dynamic> json) => ManualPaymentMethod(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    type: json["type"],
    min: json["min"],
    max: json["max"],
    cred1: json["cred1"],
    cred2: json["cred2"],
    cred3: json["cred3"],
    percentCharge: json["percent_charge"],
    fixedCharge: json["fixed_charge"],
    status: json["status"],
    className: json["class_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    inputs: List<Input>.from(json["inputs"].map((x) => Input.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "type": type,
    "min": min,
    "max": max,
    "cred1": cred1,
    "cred2": cred2,
    "cred3": cred3,
    "percent_charge": percentCharge,
    "fixed_charge": fixedCharge,
    "status": status,
    "class_name": className,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "inputs": List<dynamic>.from(inputs.map((x) => x.toJson())),
  };
}

class Input {
  Input({
    this.id,
    this.belongsToType,
    this.belongsToId,
    this.title,
    this.type,
    this.placeholder,
    this.isRequired,
    this.sort,
    this.createdAt,
    this.updatedAt,
    this.value,
    this.options,
    this.inputType,
  });

  int id;
  String belongsToType;
  int belongsToId;
  String title;
  String type;
  String placeholder;
  int isRequired;
  int sort;
  DateTime createdAt;
  DateTime updatedAt;
  String value;
  List<dynamic> options;
  String inputType;

  factory Input.fromJson(Map<String, dynamic> json) => Input(
    id: json["id"],
    belongsToType: json["belongs_to_type"],
    belongsToId: json["belongs_to_id"],
    title: json["title"],
    type: json["type"],
    placeholder: json["placeholder"] == null ? null : json["placeholder"],
    isRequired: json["is_required"],
    sort: json["sort"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    value: json["value"],
    options: List<dynamic>.from(json["options"].map((x) => x)),
    inputType: json["input_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "belongs_to_type": belongsToType,
    "belongs_to_id": belongsToId,
    "title": title,
    "type": type,
    "placeholder": placeholder == null ? null : placeholder,
    "is_required": isRequired,
    "sort": sort,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "value": value,
    "options": List<dynamic>.from(options.map((x) => x)),
    "input_type": inputType,
  };
}
