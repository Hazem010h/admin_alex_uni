class AdminModel{

  String? id;
  String? phone;
  String? name;
  String? email;
  String? universityId;
  String? departmentId;
  bool? underGraduate;
  bool? postGraduate;
  bool? isAvailable;
  bool? showInDepartment;

  AdminModel({
    this.id,
    this.phone,
    this.name,
    this.email,
    this.universityId,
    this.departmentId,
    this.underGraduate,
    this.postGraduate,
    this.isAvailable=false,
    this.showInDepartment=true,
  });

  AdminModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    name = json['name'];
    email=json['email'];
    universityId = json['universityId'];
    departmentId = json['departmentId'];
    underGraduate = json['underGraduate'];
    postGraduate = json['postGraduate'];
    isAvailable=json['isAvailable'];
    showInDepartment=json['showInDepartment'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'email':email,
      'universityId': universityId,
      'departmentId': departmentId,
      'name': name,
      'underGraduate': underGraduate,
      'postGraduate': postGraduate,
      'isAvailable':isAvailable,
      'showInDepartment':showInDepartment,
    };
  }
}