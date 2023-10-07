class UniversityModel {
  String? uId;
  String? englishName;
  String? arabicName;
  String? image;

  UniversityModel({
    this.englishName,
    this.arabicName,
    this.uId,
    this.image,
  });

  UniversityModel.fromJson(Map<String,dynamic>? json){
    englishName=json!['name'];
    arabicName=json['arabicName'];
    image=json['image'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':englishName,
      'arabicName':arabicName,
      'image':image,
    };
  }
}
