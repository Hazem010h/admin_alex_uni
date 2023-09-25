//make a model in flutter called NewsModel as it has a list of titles and descriptions and images

// import 'dart:io';
//
// class NewsModel {
//   String? title;
//   String? description;
//   late final List<File>image;
//
//   NewsModel({
//     required this.title,
//     required this.description,
//     required this.image,
//   });
//
//   NewsModel.fromMap(Map<String, dynamic> map) {
//     title = map['title'];
//     description = map['description'];
//     image = map['image'];
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'description': description,
//       'image': image,
//     };
//   }
// }

class NewsModel {
  String? title;
  List<NewsSection>? newsSections;

  NewsModel({
    this.title,
    this.newsSections,
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['newsSections'] != null) {
      newsSections = [];
      json['newsSections'].forEach((v) {
        newsSections!.add(NewsSection.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'newsSections': newsSections!.map((e) => e.toJson()).toList(),
    };
  }
}

class NewsSection {
  String? title;
  String? image;
  String? imageDescription;
  String? description;

  NewsSection({
    this.image,
    this.imageDescription,
    this.title,
    this.description,
  });

  NewsSection.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    imageDescription = json['imageDescription'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'imageDescription': imageDescription,
      'title': title,
      'description': description,
    };
  }
}
