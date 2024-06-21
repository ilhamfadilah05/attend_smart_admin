// ignore_for_file: must_be_immutable

import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonGlobal extends StatelessWidget {
  ButtonGlobal(
      {super.key,
      required this.message,
      this.padding,
      required this.onPressed,
      this.colorBtn,
      this.colorText});

  String message;
  EdgeInsets? padding;
  Function() onPressed;
  Color? colorBtn;
  Color? colorText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, state) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: colorBtn ?? blueDefaultLight,
                padding: padding ??
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            onPressed: onPressed,
            child: TextGlobal(
              message: message,
              colorText: state ? Colors.black : Colors.white,
            ));
      },
    );
  }
}
