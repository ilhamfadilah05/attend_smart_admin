import 'package:flutter/material.dart';

class SidebarModel {
  String? label;
  String? href;
  IconData? icon;
  List<SidebarModel>? childreen;
  int? index;

  SidebarModel({this.label, this.href, this.icon, this.childreen, this.index});
}
