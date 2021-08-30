// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderSummary _$OrderSummaryFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'user_id']);
  return OrderSummary(
    id: json['id'] as int,
    userId: json['user_id'] as dynamic,
    track: json['track'] as String,
    couponId: json['coupon_id'] as dynamic,
    couponCode: json['coupon_code'] as dynamic,
    discount: (json['discount'] as dynamic)?.toDouble() ?? 0,
    shippingMethodId: json['shipping_method_id'] as dynamic,
    shippingMethodName: json['shipping_method_name'] as String ?? '',
    shippingCharge: (json['shipping_charge'] as dynamic)?.toDouble() ?? 0.0,
    status: json['status'] as dynamic,
    createdAt: json['created_at'] as String ?? '',
  )..statusString = json['status_string'] as String ?? '';
}

Map<String, dynamic> _$OrderSummaryToJson(OrderSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'track': instance.track,
      'coupon_id': instance.couponId,
      'coupon_code': instance.couponCode,
      'discount': instance.discount,
      'shipping_method_id': instance.shippingMethodId,
      'shipping_method_name': instance.shippingMethodName,
      'shipping_charge': instance.shippingCharge,
      'created_at': instance.createdAt,
      'status': instance.status,
      'status_string': instance.statusString,
    };
