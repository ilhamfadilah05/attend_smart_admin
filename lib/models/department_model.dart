class DepartmentModel {
  String? id;
  String? idCompany;
  String? name;

  DepartmentModel({
    this.id,
    this.idCompany,
    this.name,
  });

  DepartmentModel copyWith({
    String? id,
    String? idCompany,
    String? name,
  }) {
    return DepartmentModel(
        id: id ?? this.id,
        idCompany: idCompany ?? this.idCompany,
        name: name ?? this.name);
  }

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCompany = json['id_company'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'name': name,
    };
  }
}
