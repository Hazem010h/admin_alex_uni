class UniversityModel {
  String? uId;
  String? name;
  String? description;

  UniversityModel({
    this.description,
    this.name,
    this.uId,
  });

  UniversityModel.fromJson(Map<String,dynamic>? json){
    description=json!['description'];
    name=json['name'];
    uId=json['uId'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'description':description,
      'uId':uId,
    };
  }
}
