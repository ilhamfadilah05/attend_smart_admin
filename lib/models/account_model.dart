class AccountModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? idCompany;
  String? nameCompany;
  String? idBranch;
  String? nameBranch;
  String? idEmployee;
  String? createdAt;
  String? role;

  AccountModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.idCompany,
      this.nameCompany,
      this.idBranch,
      this.nameBranch,
      this.idEmployee,
      this.createdAt,
      this.role});

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        idCompany: json['id_company'],
        nameCompany: json['name_company'],
        idBranch: json['id_branch'],
        nameBranch: json['name_branch'],
        idEmployee: json['id_employee'],
        createdAt: json['created_at'],
        role: json['role']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'id_employee': idEmployee,
      'id_company': idCompany,
      'name_company': nameCompany,
      'id_branch': idBranch,
      'name_branch': nameBranch,
      'created_at': createdAt,
      'role': role
    };
  }
}
