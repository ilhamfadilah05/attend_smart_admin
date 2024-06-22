class EmployeeModel {
  String? id;
  String? idCompany;
  String? name;
  String? nameCompany;
  String? idBranch;
  String? nameBranch;
  String? gender;
  String? nohp;
  String? nik;
  String? address;
  String? remainingCuti;
  String? totalCuti;
  String? workingPosition;
  String? workingStatus;
  String? image;

  EmployeeModel({
    this.id,
    this.idCompany,
    this.name,
    this.nameCompany,
    this.idBranch,
    this.nameBranch,
    this.gender,
    this.nohp,
    this.nik,
    this.address,
    this.remainingCuti,
    this.totalCuti,
    this.workingPosition,
    this.workingStatus,
    this.image,
  });

  EmployeeModel copyWith({
    String? id,
    String? idCompany,
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
    String? workingPosition,
    String? workingStatus,
    String? image,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      idCompany: idCompany ?? this.idCompany,
      name: name ?? this.name,
      nameCompany: nameCompany ?? this.nameCompany,
      idBranch: idBranch ?? this.idBranch,
      nameBranch: nameBranch ?? this.nameBranch,
      gender: gender ?? this.gender,
      nohp: nohp ?? this.nohp,
      nik: nik ?? this.nik,
      address: address ?? this.address,
      remainingCuti: remainingCuti ?? this.remainingCuti,
      totalCuti: totalCuti ?? this.totalCuti,
      workingPosition: workingPosition ?? this.workingPosition,
      workingStatus: workingStatus ?? this.workingStatus,
      image: image ?? this.image,
    );
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      idCompany: json['id_company'],
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
      workingPosition: json['working_position'],
      workingStatus: json['working_status'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
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
      'working_position': workingPosition,
      'working_status': workingStatus,
      'image': image,
    };
  }
}
