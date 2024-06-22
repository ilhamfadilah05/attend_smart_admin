// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class DropdownGlobal extends StatelessWidget {
  DropdownGlobal(
      {super.key,
      required this.listItems,
      required this.value,
      required this.onChanged,
      this.title,
      this.colorTextTitle,
      this.fontSizeTitle,
      this.theme,
      this.isDisabled,
      this.hint});
  var listItems;
  var value;
  Function(Object?) onChanged;
  Color? colorTextTitle;
  double? fontSizeTitle;
  String? title;
  String? hint;
  String? theme;
  bool? isDisabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == null
            ? Container()
            : Column(
                children: [
                  TextGlobal(
                    message: title!,
                    colorText: colorTextTitle ?? Colors.black,
                    fontSize: fontSizeTitle ?? 12,
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: theme == null
                  ? Border.all(color: Colors.grey.withOpacity(0.2))
                  : theme == 'theme1'
                      ? const Border(bottom: BorderSide(color: Colors.grey))
                      : Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: theme != null ? null : BorderRadius.circular(5)),
          child: Column(
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton(
                    focusColor: Colors.transparent,
                    dropdownColor: Colors.white,
                    hint: hint == null
                        ? null
                        : TextGlobal(
                            message: hint!,
                            colorText: Colors.grey,
                          ),
                    value: value,
                    icon: const Icon(Iconsax.arrow_square_down_outline,
                        color: Colors.grey),
                    isExpanded: true,
                    items:
                        listItems.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: TextGlobal(
                          message: value,
                          colorText: value.contains('Pilih')
                              ? Colors.grey
                              : Colors.black,
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
