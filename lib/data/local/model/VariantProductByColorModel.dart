import 'dart:convert';

class VariantByColor {
  JsonObject data;
  int status;

  VariantByColor({this.data, this.status});

  VariantByColor.fromJson(Map<String, dynamic> json) {
    print("VariantColor :");
    data = json['data'] == null ? null : JsonObject.fromJson(json['data']);
    status = json['status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.data == null ? null : this.data.toJson();
    data['status'] = this.status;
    return data;
  }
}

class JsonObject {
  JsonObjectModel json_object;

  JsonObject({this.json_object});

  JsonObject.fromJson(Map<String, dynamic> json) {
    print("VariantColor :");
    json_object = json['json_object'] == null
        ? null
        : JsonObjectModel.fromJson(json['json_object']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['json_object'] =
        this.json_object == null ? null : this.json_object.toJson();
    return data;
  }
}

class GaleryModel {
  String url;
  String thumb_url;

  GaleryModel({this.url, this.thumb_url});

  GaleryModel.fromJson(Map<String, dynamic> json) {
    print("Galery :");
    url = json['url'];
    thumb_url = json['thumb_url'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['thumb_url'] = this.thumb_url;
    return data;
  }
}

class JsonObjectModel {
  int id;
  String parent_id;
  String category_id;
  String slug;
  String title;
  String created_at;
  String updated_at;

  String content;
  String image;
  List<GaleryModel> gallery;
  String views;
  String per;
  String unit;
  int sale_price;
  int general_price;
  int tax;

  String sku;
  String stock;
  String delivery_time;
  String delivery_time_type;
  String is_free_shipping;
  String status;
  int price_off;
  String type;
  int star;

  JsonObjectModel(
      {this.id,
      this.parent_id,
      this.slug,
      this.created_at,
      this.updated_at,
      this.category_id,
      this.content,
      this.delivery_time,
      this.delivery_time_type,
      this.gallery,
      this.general_price,
      this.image,
      this.is_free_shipping,
      this.per,
      this.price_off,
      this.sale_price,
      this.sku,
      this.star,
      this.status,
      this.stock,
      this.tax,
      this.title,
      this.type,
      this.unit,
      this.views});

  JsonObjectModel.fromJson(Map<String, dynamic> data) {
    print("Attribute Color Model :");
    id = data['id'];
    parent_id = data['parent_id'];
    slug = data['slug'];
    created_at = data['created_at'];
    updated_at = data['updated_at'];
    created_at = data['created_at'];
    updated_at = data['updated_at'];
    category_id = data['category_id'];
    content = data['content'];
    delivery_time = data['delivery_time'];
    delivery_time_type = data['delivery_time_type'];
    List<GaleryModel> listGalery = [];
    if (data['gallery'] == null) {
      listGalery = null;
    } else {
      data['gallery'].forEach((v) {
        listGalery.add(new GaleryModel.fromJson(v));
      });
      this.gallery = listGalery;
      general_price = data['general_price'];
      image = data['image'];
      is_free_shipping = data['is_free_shipping'];
      per = data['per'];
      price_off = data['price_off'];
      sale_price = data['sale_price'];
      sku = data['sku'];
      star = data['star'];
      status = data['status'];
      stock = data['stock'];
      tax = data['tax'];
      title = data['title'];
      type = data['type'];
      unit = data['unit'];
      views = data['views'];
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parent_id;
    data['slug'] = this.slug;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    data['category_id'] = this.category_id;
    data['content'] = this.content;
    data['delivery_time'] = this.delivery_time;
    data['delivery_time_type'] = this.delivery_time_type;
    data['gallery'] = (this.gallery == null || this.gallery == [])
        ? []
        : this.gallery.map((v) => v.toJson()).toList();
    data['general_price'] = this.general_price;
    data['image'] = this.image;
    data['is_free_shipping'] = this.is_free_shipping;
    data['per'] = this.per;
    data['price_off'] = this.price_off;
    data['sale_price'] = this.sale_price;
    data['sku'] = this.sku;
    data['star'] = this.star;
    data['status'] = this.status;
    data['stock'] = this.stock;
    data['tax'] = this.tax;
    data['title'] = this.title;
    data['type'] = this.type;
    data['unit'] = this.unit;
    data['views'] = this.views;
    return data;
  }
}
