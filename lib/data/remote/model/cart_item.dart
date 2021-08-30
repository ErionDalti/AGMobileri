import 'package:azzoa_grocery/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_item.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CartItem {
  @JsonKey(required: true)
  int id;

  @JsonKey(required: true)
  dynamic cartId;

  @JsonKey(required: true)
  dynamic productId;

  @JsonKey(defaultValue: null)
  dynamic variationId;

  @JsonKey(required: true)
  dynamic quantity;

  @JsonKey(required: true)
  dynamic price;

  @JsonKey(defaultValue: kDefaultDouble)
  dynamic tax;

  @JsonKey(defaultValue: null)
  Map<String, String> attrs;

  @JsonKey(defaultValue: kDefaultString)
  String createdAt;

  @JsonKey(defaultValue: kDefaultString)
  dynamic grossTotal;

  @JsonKey(defaultValue: kDefaultString)
  dynamic netTotal;

  @JsonKey(defaultValue: kDefaultString)
  dynamic taxTotal;

  CartItem({
    this.id,
    this.cartId,
    this.productId,
    this.variationId,
    this.attrs,
    this.price,
    this.grossTotal,
    this.netTotal,
    this.taxTotal,
    this.quantity,
    this.tax,
    this.createdAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
