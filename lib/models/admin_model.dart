class AdminModel{

  String? id;
  String? phone;
  String? name;
  String? email;
  String? universityId;
  String? departmentId;
  String? password;
  bool? underGraduate;
  bool? postGraduate;

  AdminModel({
    this.id,
    this.phone,
    this.name,
    this.email,
    this.password,
    this.universityId,
    this.departmentId,
    this.underGraduate,
    this.postGraduate,
  });

  AdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    password=json['password'];
    email=json['email'];
    universityId = json['universityId'];
    departmentId = json['departmentId'];

    underGraduate = json['underGraduate'];
    postGraduate = json['postGraduate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'email':email,
      'password':password,
      'universityId': universityId,
      'departmentId': departmentId,
      'name': name,
      'underGraduate': underGraduate,
      'postGraduate': postGraduate,
    };
  }
}