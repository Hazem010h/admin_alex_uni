class DepartmentModel{

  String? id;
  String? universityId;
  String? name;
  bool? underGraduate;
  bool? postGraduate;
  String? departmentImage;
  String? description;

  DepartmentModel({
    this.id,
    this.universityId,
    this.name,
    this.departmentImage,
    this.underGraduate,
    this.postGraduate,
    this.description,
  });

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    universityId = json['universityId'];
    name = json['name'];
    departmentImage = json['departmentImage'];
    underGraduate = json['isUndergraduate'];
    postGraduate = json['isPostgraduate'];
    description = json['description'];
  }

  Map<String, dynamic> toMap() {
    return {
      'universityId': universityId,
      'departmentImage': departmentImage,
      'description': description,
      'name': name,
      'isUndergraduate': underGraduate,
      'isPostgraduate': postGraduate,
    };
  }
}