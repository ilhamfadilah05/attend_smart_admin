class EmployeeModel {
  String? id;
  String? idCompany;
  String? name;
  String? nameCompany;
  String? gender;
  String? nohp;
  String? nik;
  String? address;
  String? remainingCuti;
  String? totalCuti;
  String? workingPosition;
  String? workingStatus;
  String? image;

  EmployeeModel(
      {this.id,
      this.idCompany,
      this.name,
      this.nameCompany,
      this.gender,
      this.nohp,
      this.nik,
      this.address,
      this.remainingCuti,
      this.totalCuti,
      this.workingPosition,
      this.workingStatus,
      this.image});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      idCompany: json['id_company'],
      name: json['name'],
      nameCompany: json['name_company'],
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
      'name_company': nameCompany,
      'gender': gender,
      'nohp': nohp,
      'nik': nik,
      'address': address,
      'remaining_cuti': remainingCuti,
      'total_cuti': totalCuti,
      'working_position': workingPosition,
      'working_status': workingStatus,
      'image': image
    };
  }
}
