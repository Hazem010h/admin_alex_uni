class NewsModel {
  String? title;
  List<NewsSection>? newsSections;
  DateTime? date; // Add this field

  NewsModel({
    this.title,
    this.newsSections,
    this.date, // Initialize it in the constructor if needed
  });

  NewsModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['newsSections'] != null) {
      newsSections = [];
      json['newsSections'].forEach((v) {
        newsSections!.add(NewsSection.fromJson(v));
      });
    }
    if (json['date'] != null) {
      date = DateTime.parse(json['date']); // Modify the date parsing logic as needed
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'newsSections': newsSections!.map((e) => e.toJson()).toList(),
      'date': date != null ? date!.toUtc().millisecondsSinceEpoch ~/ 3600000 : null, // Convert DateTime to hours
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
