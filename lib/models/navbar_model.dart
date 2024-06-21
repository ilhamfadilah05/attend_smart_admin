import 'package:flutter/material.dart';

class NavbarModel {
  NavbarModel(
      {required this.name,
      required this.label,
      required this.href,
      required this.icon});

  String name;
  String label;
  String href;
  IconData icon;

  factory NavbarModel.fromJson(Map<String, dynamic> json) => NavbarModel(
      name: json["name"],
      label: json["label"],
      href: json["href"],
      icon: json["icon"]);
}
