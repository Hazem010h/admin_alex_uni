//make a model in flutter called NewsModel as it has a list of titles and descriptions and images

import 'dart:io';

class NewsModel {
  String? title;
  String? description;
  late final List<File>image;

  NewsModel({
    required this.title,
    required this.description,
    required this.image,
  });

  NewsModel.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    description = map['description'];
    image = map['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
    };
  }
}