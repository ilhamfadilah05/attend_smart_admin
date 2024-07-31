class HistoryAttendModel {
  String? id;
  String? idCompany;
  String? idBranch;
  String? idEmployee;
  String? nameCompany;
  String? nameBranch;
  String? nameEmployee;
  String? dateAttend;
  String? timeAttend;
  String? delayedAttend;
  String? latLong;
  String? department;
  String? imageAttend;
  String? locationAttend;
  String? tipeAbsen;

  HistoryAttendModel({
    this.id,
    this.idCompany,
    this.idBranch,
    this.idEmployee,
    this.nameCompany,
    this.nameBranch,
    this.nameEmployee,
    this.dateAttend,
    this.timeAttend,
    this.delayedAttend,
    this.latLong,
    this.department,
    this.imageAttend,
    this.locationAttend,
    this.tipeAbsen,
  });

  HistoryAttendModel copyWith({
    String? id,
    String? idCompany,
    String? idBranch,
    String? idEmployee,
    String? nameCompany,
    String? nameBranch,
    String? nameEmployee,
    String? dateAttend,
    String? timeAttend,
    String? delayedAttend,
    String? latLong,
    String? department,
    String? imageAttend,
    String? locationAttend,
    String? tipeAbsen,
  }) {
    return HistoryAttendModel(
      id: id ?? this.id,
      idCompany: idCompany ?? this.idCompany,
      idBranch: idBranch ?? this.idBranch,
      idEmployee: idEmployee ?? this.idEmployee,
      nameCompany: nameCompany ?? this.nameCompany,
      nameBranch: nameBranch ?? this.nameBranch,
      nameEmployee: nameEmployee ?? this.nameEmployee,
      dateAttend: dateAttend ?? this.dateAttend,
      timeAttend: timeAttend ?? this.timeAttend,
      delayedAttend: delayedAttend ?? this.delayedAttend,
      latLong: latLong ?? this.latLong,
      department: department ?? this.department,
      imageAttend: imageAttend ?? this.imageAttend,
      locationAttend: locationAttend ?? this.locationAttend,
      tipeAbsen: tipeAbsen ?? this.tipeAbsen,
    );
  }

  factory HistoryAttendModel.fromJson(Map<String, dynamic> json) {
    return HistoryAttendModel(
      id: json['id'],
      idCompany: json['id_company'],
      idBranch: json['id_branch'],
      idEmployee: json['id_employee'],
      nameCompany: json['name_company'],
      nameBranch: json['name_branch'],
      nameEmployee: json['name_employee'],
      dateAttend: json['date_attend'],
      timeAttend: json['time_attend'],
      delayedAttend: json['delayed_attend'],
      latLong: json['lat_long'],
      department: json['department'],
      imageAttend: json['image_attend'],
      locationAttend: json['location_attend'],
      tipeAbsen: json['tipe_absen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'id_branch': idBranch,
      'id_employee': idEmployee,
      'name_company': nameCompany,
      'name_branch': nameBranch,
      'name_employee': nameEmployee,
      'date_attend': dateAttend,
      'time_attend': timeAttend,
      'delayed_attend': delayedAttend,
      'lat_long': latLong,
      'department': department,
      'image_attend': imageAttend,
      'location_attend': locationAttend,
      'tipe_absen': tipeAbsen,
    };
  }
}
