class UniversityModel {
  String? uId;
  String? name;
  String? description;
  String? image;

  UniversityModel({
    this.description,
    this.name,
    this.uId,
    this.image,
  });

  UniversityModel.fromJson(Map<String,dynamic>? json){
    description=json!['description'];
    name=json['name'];
    uId=json['uId'];
    image=json['image'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'description':description,
      'uId':uId,
      'image':image,
    };
  }
}
