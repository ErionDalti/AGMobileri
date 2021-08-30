// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attribute _$AttributeFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'name']);
  return Attribute()
    ..id = json['id'] as int
    ..productId = json['product_id'] as String
    ..attributeId = json['attribute_id'] as String
    ..name = json['name'] as String
    ..title = json['title'] as String
    ..type = json['type'] as String
    ..slug = json['slug'] as String
    ..position = json['position'] as String
    // ..content =
    //     (json['content'] as List)?.map((e) => e as String)?.toList() ?? []
    ..terms = (json['terms'] as List)
            ?.map((e) =>
                e == null ? null : Term.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        []
    ..createdAt = json['created_at'] as String ?? '';
}

Map<String, dynamic> _$AttributeToJson(Attribute instance) => <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'attribute_id': instance.attributeId,
      'name': instance.name,
      'title': instance.title,
      'type': instance.type,
      'slug': instance.slug,
      'position': instance.position,
      'content': instance.content,
      'terms': instance.terms,
      'created_at': instance.createdAt,
    };
