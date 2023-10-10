class AdminModel{

  String? id;
  String? phone;
  String? name;
  String? email;
  String? universityId;
  String? departmentId;
  bool? postGraduate;
  bool? isAvailable;
  bool? reviewPosts;
  bool? showInDepartment;

  AdminModel({
    this.id,
    this.phone,
    this.name,
    this.email,
    this.universityId,
    this.departmentId,
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
    postGraduate = json['postGraduate'];
    isAvailable=json['isAvailable'];
    reviewPosts=json['reviewPosts'];
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
      'postGraduate': postGraduate,
      'isAvailable':isAvailable,
      'reviewPosts':reviewPosts,
      'showInDepartment':showInDepartment,
    };
  }
}