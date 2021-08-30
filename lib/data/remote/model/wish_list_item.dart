import 'package:azzoa_grocery/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wish_list_item.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class WishListItem {
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
  double grossTotal;

  @JsonKey(defaultValue: kDefaultString)
  double netTotal;

  @JsonKey(defaultValue: kDefaultString)
  double taxTotal;

  WishListItem({
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

  factory WishListItem.fromJson(Map<String, dynamic> json) =>
      _$WishListItemFromJson(json);

  Map<String, dynamic> toJson() => _$WishListItemToJson(this);
}
