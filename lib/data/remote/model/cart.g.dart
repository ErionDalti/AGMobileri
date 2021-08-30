// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'type', 'user_id']);
  return Cart(
    id: json['id'] as int,
    type: json['type'] as String,
    userId: json['user_id'] as dynamic,
    couponId: json['coupon_id'] as dynamic,
    currencyCode: json['currency_code'] as String ?? '',
    couponDiscount: json['coupon_discount'] as dynamic,
    grossTotal: json['gross_total'] as dynamic ?? '',
    netTotal: json['net_total'] as dynamic ?? '',
    taxTotal: json['tax_total'] as dynamic ?? '',
    couponCode: json['coupon_code'] as String,
    createdAt: json['created_at'] as String ?? '',
    items: (json['items'] as List)
        ?.map((e) =>
    e == null ? null : CartItem.fromJson(e as Map<String, dynamic>))
        ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'currency_code': instance.currencyCode,
  'user_id': instance.userId,
  'coupon_id': instance.couponId,
  'coupon_code': instance.couponCode,
  'coupon_discount': instance.couponDiscount,
  'created_at': instance.createdAt,
  'gross_total': instance.grossTotal,
  'net_total': instance.netTotal,
  'tax_total': instance.taxTotal,
  'items': instance.items,
};
