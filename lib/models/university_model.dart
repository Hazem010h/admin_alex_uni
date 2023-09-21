class UniversityModel {
  String? uId;
  String? name;
  String? image;

  UniversityModel({
    this.name,
    this.uId,
    this.image,
  });

  UniversityModel.fromJson(Map<String,dynamic>? json){
    name=json!['name'];
    uId=json['uId'];
    image=json['image'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'uId':uId,
      'image':image,
    };
  }
}
