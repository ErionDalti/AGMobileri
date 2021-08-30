// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItem _$CartItemFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['id', 'cart_id', 'product_id', 'quantity', 'price']);
  return CartItem(
    id: json['id'] as int,
    cartId: json['cart_id'] as dynamic,
    productId: json['product_id'] as dynamic,
    variationId: json['variation_id'] as dynamic,
    attrs: (json['attrs'] as Map<String, dynamic>)?.map(
          (k, e) => MapEntry(k, e as String),
    ),
    price: json['price'] as dynamic,
    grossTotal: json['gross_total'] as dynamic ?? '',
    netTotal: json['net_total'] as dynamic ?? '',
    taxTotal: json['tax_total'] as dynamic ?? '',
    quantity: json['quantity'] as dynamic,
    tax: json['tax'] as dynamic ?? 0.0,
    createdAt: json['created_at'] as String ?? '',
  );
}

Map<String, dynamic> _$CartItemToJson(CartItem instance) => <String, dynamic>{
  'id': instance.id,
  'cart_id': instance.cartId,
  'product_id': instance.productId,
  'variation_id': instance.variationId,
  'quantity': instance.quantity,
  'price': instance.price,
  'tax': instance.tax,
  'attrs': instance.attrs,
  'created_at': instance.createdAt,
  'gross_total': instance.grossTotal,
  'net_total': instance.netTotal,
  'tax_total': instance.taxTotal,
};
