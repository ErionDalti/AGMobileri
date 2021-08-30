// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'title']);
  return Product(
    id: json['id'] as int,
    parentId: json['parent_id'] as String,
    categoryId: json['category_id'] as dynamic,
    shopId: json['shop_id'] as dynamic,
    title: json['title'] as String,
    slug: json['slug'] as String ?? '',
    excerpt: json['excerpt'] as String ?? '',
    content: json['content'] as String ?? '',
    image: json['image'] as String ?? '',
    views: json['views'] as dynamic,
    per: json['per'] as dynamic,
    unit: json['unit'] as String ?? '',
    salePrice: (json['sale_price'] as num)?.toDouble(),
    generalPrice: (json['general_price'] as num)?.toDouble(),
    tax: json['tax'] as dynamic,
    sku: json['sku'] as dynamic,
    stock: json['stock'] as dynamic,
    deliveryTime: json['delivery_time'] as String,
    deliveryTimeType: json['delivery_time_type'] as dynamic,
    isFreeShipping: json['is_free_shipping'] as dynamic,
    status: json['status'] as dynamic,
    createdAt: json['created_at'] as String ?? '',
    priceOff: (json['price_off'] as num)?.toDouble(),
    type: json['type'] as String ?? '',
    star: (json['star'] as num)?.toDouble() ?? 0.0,
    variations: (json['variations'] as List)
            ?.map((e) =>
                e == null ? null : Product.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    attrs: (json['attrs'] as List)
            ?.map((e) => e == null
                ? null
                : Attribute.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    gallery: (json['gallery'] as List)
            ?.map((e) =>
                e == null ? null : Gallery.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  )..averageRating = (json['average_rating'] as num)?.toDouble() ?? 0.0;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'parent_id': instance.parentId,
      'category_id': instance.categoryId,
      'shop_id': instance.shopId,
      'title': instance.title,
      'slug': instance.slug,
      'excerpt': instance.excerpt,
      'content': instance.content,
      'image': instance.image,
      'views': instance.views,
      'per': instance.per,
      'unit': instance.unit,
      'sale_price': instance.salePrice,
      'general_price': instance.generalPrice,
      'tax': instance.tax,
      'sku': instance.sku,
      'stock': instance.stock,
      'delivery_time': instance.deliveryTime,
      'delivery_time_type': instance.deliveryTimeType,
      'is_free_shipping': instance.isFreeShipping,
      'created_at': instance.createdAt,
      'status': instance.status,
      'price_off': instance.priceOff,
      'type': instance.type,
      'star': instance.star,
      'average_rating': instance.averageRating,
      'variations': instance.variations,
      'attrs': instance.attrs,
      'gallery': instance.gallery,
    };
