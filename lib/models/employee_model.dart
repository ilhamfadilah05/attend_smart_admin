class EmployeeModel {
  String? id;
  String? idCompany;
  String? name;
  String? nameCompany;
  String? idBranch;
  String? idAccount;
  String? nameBranch;
  String? gender;
  String? nohp;
  String? nik;
  String? address;
  String? remainingCuti;
  String? totalCuti;
  String? department;
  String? workingStatus;
  String? image;
  String? tokenNotif;
  String? email;

  EmployeeModel(
      {this.id,
      this.idCompany,
      this.name,
      this.nameCompany,
      this.idBranch,
      this.idAccount,
      this.nameBranch,
      this.gender,
      this.nohp,
      this.nik,
      this.address,
      this.remainingCuti,
      this.totalCuti,
      this.department,
      this.workingStatus,
      this.image,
      this.tokenNotif,
      this.email});

  EmployeeModel copyWith(
      {String? id,
      String? idCompany,
      String? idAccount,
      String? name,
      String? nameCompany,
      String? idBranch,
      String? nameBranch,
      String? gender,
      String? nohp,
      String? nik,
      String? address,
      String? remainingCuti,
      String? totalCuti,
      String? department,
      String? workingStatus,
      String? image,
      String? tokenNotif,
      String? email}) {
    return EmployeeModel(
        id: id ?? this.id,
        idCompany: idCompany ?? this.idCompany,
        name: name ?? this.name,
        idAccount: idAccount ?? this.idAccount,
        nameCompany: nameCompany ?? this.nameCompany,
        idBranch: idBranch ?? this.idBranch,
        nameBranch: nameBranch ?? this.nameBranch,
        gender: gender ?? this.gender,
        nohp: nohp ?? this.nohp,
        nik: nik ?? this.nik,
        address: address ?? this.address,
        remainingCuti: remainingCuti ?? this.remainingCuti,
        totalCuti: totalCuti ?? this.totalCuti,
        department: department ?? this.department,
        workingStatus: workingStatus ?? this.workingStatus,
        image: image ?? this.image,
        tokenNotif: tokenNotif ?? this.tokenNotif,
        email: email ?? this.email);
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      idCompany: json['id_company'],
      idAccount: json['id_account'],
      name: json['name'],
      nameCompany: json['name_company'],
      idBranch: json['id_branch'],
      nameBranch: json['name_branch'],
      gender: json['gender'],
      nohp: json['nohp'],
      nik: json['nik'],
      address: json['address'],
      remainingCuti: json['remaining_cuti'],
      totalCuti: json['total_cuti'],
      department: json['department'],
      workingStatus: json['working_status'],
      image: json['image'],
      tokenNotif: json['token_notif'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'id_account': idAccount,
      'name': name,
      'id_branch': idBranch,
      'name_branch': nameBranch,
      'name_company': nameCompany,
      'gender': gender,
      'nohp': nohp,
      'nik': nik,
      'address': address,
      'remaining_cuti': remainingCuti,
      'total_cuti': totalCuti,
      'department': department,
      'working_status': workingStatus,
      'image': image,
      'token_notif': tokenNotif,
      'email': email
    };
  }
}
