import 'package:azzoa_grocery/constants.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Category {
  @JsonKey(required: true)
  int id;

  @JsonKey(required: true)
  String name;

  @JsonKey(defaultValue: kDefaultString)
  String slug;

  @JsonKey(defaultValue: kDefaultString)
  String image;

  @JsonKey(defaultValue: kDefaultString)
  String createdAt;

  @JsonKey(defaultValue: null)
  dynamic status;

  @JsonKey(defaultValue: null)
  dynamic parentId;

  @JsonKey(defaultValue: null)
  dynamic childrenCount;

  Category({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.createdAt,
    this.status,
    this.parentId,
    this.childrenCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
