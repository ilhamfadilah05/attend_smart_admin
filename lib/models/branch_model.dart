class BranchModel {
  String? id;
  String? idCompany;
  String? name;
  String? address;
  String? timeInAttendance;
  String? timeOutAttendance;
  String? latLong;
  int? radius;
  bool? isCentralBranch;

  BranchModel({
    this.id,
    this.idCompany,
    this.name,
    this.address,
    this.timeInAttendance,
    this.timeOutAttendance,
    this.latLong,
    this.radius,
    this.isCentralBranch = false,
  });

  BranchModel copyWith(
      {String? id,
      String? idCompany,
      String? name,
      String? address,
      String? timeInAttendance,
      String? timeOutAttendance,
      String? latLong,
      int? radius,
      bool? isCentralBranch}) {
    return BranchModel(
      id: id ?? this.id,
      idCompany: idCompany ?? this.idCompany,
      name: name ?? this.name,
      address: address ?? this.address,
      timeInAttendance: timeInAttendance ?? this.timeInAttendance,
      timeOutAttendance: timeOutAttendance ?? this.timeOutAttendance,
      latLong: latLong ?? this.latLong,
      radius: radius ?? this.radius,
      isCentralBranch: isCentralBranch ?? this.isCentralBranch,
    );
  }

  BranchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCompany = json['id_company'];
    name = json['name'];
    address = json['address'];
    timeInAttendance = json['time_in_attendance'];
    timeOutAttendance = json['time_out_attendance'];
    latLong = json['lat_long'];
    radius = json['radius'];
    isCentralBranch = json['is_central_branch'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'name': name,
      'address': address,
      'time_in_attendance': timeInAttendance,
      'time_out_attendance': timeOutAttendance,
      'lat_long': latLong,
      'radius': radius,
      'is_central_branch': isCentralBranch,
    };
  }
}
