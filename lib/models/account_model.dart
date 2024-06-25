class AccountModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? idCompany;
  String? nameCompany;
  String? createdAt;
  String? role;

  AccountModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.idCompany,
      this.nameCompany,
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
        createdAt: json['created_at'],
        role: json['role']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'id_company': idCompany,
      'name_company': nameCompany,
      'created_at': createdAt,
      'role': role
    };
  }
}
