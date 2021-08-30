// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gallery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gallery _$GalleryFromJson(Map<String, dynamic> json) {
  return Gallery()
    ..url = json['url'] as  String ?? ''
    ..thumbUrl = json['thumb_url'] as String ?? '';
}

Map<String, dynamic> _$GalleryToJson(Gallery instance) => <String, dynamic>{
  'url': instance.url,
  'thumb_url': instance.thumbUrl,
};
