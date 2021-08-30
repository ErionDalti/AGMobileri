class AttributeColors {
  JsonArrayClass data;
  int status;

  AttributeColors({this.data, this.status});

  AttributeColors.fromJson(Map<String, dynamic> json) {
    print("AttributeColors :");
    print(json['data']);
    data = json['data'] == null ? null : JsonArrayClass.fromJson(json['data']);
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data == null ? null : this.data.toJson();
    data['status'] = this.status;
    return data;
  }
}

class JsonArrayClass {
  List<AttributeColorModel> json_array;

  JsonArrayClass({this.json_array});
  JsonArrayClass.fromJson(Map<String, dynamic> json) {
    print("Json Array :");
    print(json['json_array']);
    List<AttributeColorModel> values = [];
    if (json['json_array'] == null) {
      values = null;
    } else {
      json['json_array'].forEach((v) {
        values.add(new AttributeColorModel.fromJson(v));
      });
      this.json_array = values;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['json_array'] = (this.json_array == null || json_array == [])
        ? []
        : this.json_array.map((v) => v.toJson()).toList();
    return data;
  }
}

class AttributeColorModel {
  int id;
  String attribute_id;
  String name;
  String slug;
  String data;
  String created_at;
  String updated_at;

  AttributeColorModel(
      {this.id,
      this.attribute_id,
      this.name,
      this.slug,
      this.data,
      this.created_at,
      this.updated_at});

  AttributeColorModel.fromJson(Map<String, dynamic> json) {
    print("Attribute Color Model :");
    print(json);
    id = json['id'];
    attribute_id = json['attribute_id'];
    name = json['name'];
    slug = json['slug'];
    data = json['data'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attribute_id'] = this.attribute_id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['data'] = this.data;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    return data;
  }
}

enum PageTransitionType {
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}
