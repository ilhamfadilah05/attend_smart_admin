import 'package:flutter/material.dart';

class NavbarModel {
  NavbarModel(
      {required this.key,
      required this.title,
      required this.href,
      required this.icon});

  String key;
  String title;
  String href;
  IconData icon;

  factory NavbarModel.fromJson(Map<String, dynamic> json) => NavbarModel(
      key: json["key"],
      title: json["title"],
      href: json["href"],
      icon: json["icon"]);
}
