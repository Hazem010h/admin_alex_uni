class DepartmentModel{

  String? id;
  String? universityId;
  String? name;
  bool? underGraduate;
  bool? postGraduate;

  DepartmentModel({
    this.id,
    this.universityId,
    this.name,
    this.underGraduate,
    this.postGraduate,
  });

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    universityId = json['universityId'];
    name = json['name'];
    underGraduate = json['underGraduate'];
    postGraduate = json['postGraduate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'universityId': universityId,
      'name': name,
      'underGraduate': underGraduate,
      'postGraduate': postGraduate,
    };
  }
}