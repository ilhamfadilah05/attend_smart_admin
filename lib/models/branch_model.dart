class BranchModel {
  String? id;
  String? idCompany;
  String? name;
  String? address;
  String? timeInAttendance;
  String? timeOutAttendance;

  BranchModel({
    this.id,
    this.idCompany,
    this.name,
    this.address,
    this.timeInAttendance,
    this.timeOutAttendance,
  });

  BranchModel copyWith({
    String? id,
    String? idCompany,
    String? name,
    String? address,
    String? timeInAttendance,
    String? timeOutAttendance,
  }) {
    return BranchModel(
      id: id ?? this.id,
      idCompany: idCompany ?? this.idCompany,
      name: name ?? this.name,
      address: address ?? this.address,
      timeInAttendance: timeInAttendance ?? this.timeInAttendance,
      timeOutAttendance: timeOutAttendance ?? this.timeOutAttendance,
    );
  }

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCompany = json['id_company'];
    name = json['name'];
    address = json['address'];
    timeInAttendance = json['time_in_attendance'];
    timeOutAttendance = json['time_out_attendance'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'name': name,
      'address': address,
      'time_in_attendance': timeInAttendance,
      'time_out_attendance': timeOutAttendance,
    };
  }
}
