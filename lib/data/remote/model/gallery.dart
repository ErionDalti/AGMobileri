import 'dart:convert';

import 'package:azzoa_grocery/constants.dart';
import 'package:azzoa_grocery/data/remote/model/term.dart';
import 'package:json_annotation/json_annotation.dart';

part 'gallery.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Gallery {

  @JsonKey(defaultValue: kDefaultString)
  String url;
  @JsonKey(defaultValue: kDefaultString)
  String thumbUrl;

  Gallery();

  factory Gallery.fromJson(Map<String, dynamic> json) =>
      _$GalleryFromJson(json);

  Map<String, dynamic> toJson() => _$GalleryToJson(this);

  String toJsonString() => json.encode(toJson());
}
