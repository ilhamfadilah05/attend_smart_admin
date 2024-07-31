class SubmissionModel {
  String? id;
  String? idCompany;
  String? idEmployee;
  String? idBranch;
  String? nameEmployee;
  String? reason;
  String? dateStart;
  String? dateEnd;
  String? createdAt;
  String? status;
  String? type;
  String? reasonImage;

  SubmissionModel(
      {this.id,
      this.idCompany,
      this.idEmployee,
      this.idBranch,
      this.nameEmployee,
      this.reason,
      this.dateStart,
      this.dateEnd,
      this.createdAt,
      this.status,
      this.type,
      this.reasonImage});

  SubmissionModel copyWith({
    String? id,
    String? idCompany,
    String? idEmployee,
    String? idBranch,
    String? nameEmployee,
    String? reason,
    String? dateStart,
    String? dateEnd,
    String? createdAt,
    String? status,
    String? type,
    String? reasonImage,
  }) {
    return SubmissionModel(
      id: id ?? this.id,
      idCompany: idCompany ?? this.idCompany,
      idEmployee: idEmployee ?? this.idEmployee,
      idBranch: idBranch ?? this.idBranch,
      nameEmployee: nameEmployee ?? this.nameEmployee,
      reason: reason ?? this.reason,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      type: type ?? this.type,
      reasonImage: reasonImage ?? this.reasonImage,
    );
  }

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
        id: json['id'],
        idCompany: json['id_company'],
        idEmployee: json['id_employee'],
        idBranch: json['id_branch'],
        nameEmployee: json['name_employee'],
        reason: json['reason'],
        dateStart: json['date_start'],
        dateEnd: json['date_end'],
        createdAt: json['created_at'],
        status: json['status'],
        type: json['type'],
        reasonImage: json['reason_image']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'id_employee': idEmployee,
      'id_branch': idBranch,
      'name_employee': nameEmployee,
      'reason': reason,
      'date_start': dateStart,
      'date_end': dateEnd,
      'created_at': createdAt,
      'status': status,
      'type': type,
      'reason_image': reasonImage
    };
  }
}
