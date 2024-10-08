// // ignore_for_file: must_be_immutable

// import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
// import 'package:attend_smart_admin/components/global_color_components.dart';
// import 'package:attend_smart_admin/components/global_text_component.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ButtonGlobal extends StatelessWidget {
//   ButtonGlobal(
//       {super.key,
//       required this.message,
//       this.padding,
//       required this.onPressed,
//       this.colorBtn,
//       this.colorText});

//   String message;
//   EdgeInsets? padding;
//   Function() onPressed;
//   Color? colorBtn;
//   Color? colorText;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, bool>(
//       builder: (context, state) {
//         return ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: colorBtn ?? blueDefaultLight,
//                 padding: padding ??
//                     const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5))),
//             onPressed: onPressed,
//             child: TextGlobal(
//               message: message,
//               colorText: state ? Colors.black : Colors.white,
//             ));
//       },
//     );
//   }
// }

import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonGlobal extends StatelessWidget {
  ButtonGlobal(
      {super.key,
      required this.message,
      required this.onPressed,
      this.fontSize,
      this.radius,
      this.colorBtn,
      this.hoverColor,
      this.variant,
      this.borderColor,
      this.width,
      this.colorText,
      this.widget});
  String message;
  void Function() onPressed;
  double? fontSize;
  double? radius;
  Color? colorBtn;
  Color? hoverColor;
  Color? colorText;
  String? variant;
  Color? borderColor;
  double? width;
  Widget? widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 5),
                side: variant == 'outline'
                    ? BorderSide(color: borderColor ?? Colors.black)
                    : BorderSide.none),
          ),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return hoverColor ?? Colors.black.withOpacity(0.8);
              }
              if (states.contains(WidgetState.focused) ||
                  states.contains(WidgetState.pressed)) {
                return colorBtn ?? Colors.black;
              }
              return colorBtn ??
                  (variant == 'outline'
                      ? Colors.white
                      : Colors.black); // Defer to the widget's default.
            },
          ),
        ),
        child: widget ??
            TextGlobal(
              message: message,
              colorText: colorText ??
                  (variant == 'outline' ? Colors.black : Colors.white),
              fontSize: fontSize ?? 12,
            ),
      ),
    );
  }
}
