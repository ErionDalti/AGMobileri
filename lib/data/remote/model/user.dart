import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  @JsonKey(required: true)
  int id;

  @JsonKey(required: true)
  String name;

  @JsonKey(required: true)
  String username;

  @JsonKey(required: true)
  String email;

  @JsonKey(required: true)
  String phone;

  @JsonKey(required: false)
  String email_verified_at;

  @JsonKey(required: false)
  String phone_verified_at;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.phone,
    this.email_verified_at,
    this.phone_verified_at
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
