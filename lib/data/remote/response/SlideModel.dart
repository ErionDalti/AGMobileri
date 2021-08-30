import 'package:azzoa_grocery/constants.dart';
import 'package:azzoa_grocery/data/remote/model/category_list.dart';

class SlideModel {
  final int id;
  final String imageUrl;

  SlideModel({
    this.id,
    this.imageUrl,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: json["id"],
      imageUrl: json["image"],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.imageUrl;
    return data;
  }
}
