import 'dart:typed_data';

class BroadcastModel {
  String? id;
  String? idCompany;
  String? title;
  String? subTitle;
  String? imageUrl;
  String? imagePath;
  Uint8List? imageBytes;

  BroadcastModel(
      {this.id,
      this.idCompany,
      this.title,
      this.subTitle,
      this.imageUrl,
      this.imagePath,
      this.imageBytes});

  BroadcastModel copyWith(
      {String? id,
      String? idCompany,
      String? title,
      String? subTitle,
      String? imageUrl,
      String? imagePath,
      Uint8List? imageBytes}) {
    return BroadcastModel(
        id: id ?? this.id,
        idCompany: idCompany ?? this.idCompany,
        title: title ?? this.title,
        subTitle: subTitle ?? this.subTitle,
        imageUrl: imageUrl ?? this.imageUrl,
        imagePath: imagePath ?? this.imagePath,
        imageBytes: imageBytes ?? this.imageBytes);
  }

  BroadcastModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idCompany = json['id_company'];
    title = json['title'];
    subTitle = json['subtitle'];
    imageUrl = json['image_url'];
    imagePath = json['image_path'];
    imageBytes = json['image_bytes'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_company': idCompany,
      'title': title,
      'subtitle': subTitle,
      'image_path': imagePath,
      'image_url': imageUrl
    };
  }
}

class BroadcastSendModel {
  String? id;
  String? idBroadcast;
  String? idEmployee;
  String? nameEmployee;
  String? title;
  String? body;
  String? image;
  String? tokenNotif;
  bool? isRead;

  BroadcastSendModel({
    this.id,
    this.idBroadcast,
    this.idEmployee,
    this.nameEmployee,
    this.title,
    this.body,
    this.image,
    this.tokenNotif,
    this.isRead,
  });

  BroadcastSendModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idBroadcast = json['id_broadcast'];
    idEmployee = json['id_employee'];
    nameEmployee = json['name_employee'];
    title = json['title'];
    body = json['body'];
    image = json['image'];
    tokenNotif = json['token_notif'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJsonSendNotif() {
    return {
      'id': id,
      'id_broadcast': idBroadcast,
      'id_employee': idEmployee,
      'name_employee': nameEmployee,
      'title': title,
      'body': body,
      'image': image,
      'token_notif': tokenNotif,
      'is_read': isRead
    };
  }
}
