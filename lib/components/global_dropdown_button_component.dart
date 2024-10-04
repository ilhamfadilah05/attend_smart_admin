// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable, prefer_const_constructors

import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:flutter/material.dart';

class DropdownGlobal extends StatelessWidget {
  DropdownGlobal(
      {super.key,
      required this.listItems,
      required this.value,
      required this.onChanged,
      this.title,
      this.titleWidget,
      this.errorForm,
      this.errorFormMessage,
      this.theme,
      this.hint,
      this.isDisabled});
  var listItems;
  var value;
  Function(Object?) onChanged;
  String? title;
  Widget? titleWidget;
  String? hint;
  String? theme;
  bool? errorForm;
  String? errorFormMessage;
  bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == null
            ? titleWidget == null
                ? Container()
                : Column(
                    children: [
                      titleWidget!,
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  )
            : Column(
                children: [
                  TextGlobal(message: title!),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color:
                      isDisabled == true ? Colors.grey.withOpacity(0.1) : null,
                  border: theme == null
                      ? Border.all(
                          color: errorForm == null
                              ? Colors.grey.withOpacity(0.3)
                              : errorForm == true
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.3))
                      : theme == 'theme1'
                          ? const Border(bottom: BorderSide(color: Colors.grey))
                          : Border.all(color: Colors.grey.withOpacity(0.2)),
                  borderRadius:
                      theme != null ? null : BorderRadius.circular(5)),
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: theme == 'theme1' ? 0 : 10),
                child: Column(
                  children: [
                    isDisabled == true
                        ? Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextGlobal(
                                  message: value ?? '',
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          )
                        : DropdownButtonHideUnderline(
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
                                // value:
                                //     value == null || value == '' ? listItems.first : value,
                                isExpanded: true,
                                items: listItems.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: TextGlobal(
                                      message: value,
                                      fontSize: 12,
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
            ),
            errorForm == null ||
                    errorFormMessage == null ||
                    errorForm == false ||
                    errorFormMessage == ''
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: TextGlobal(
                            message: errorFormMessage!,
                            colorText: Colors.red,
                            fontSize: 12,
                          ))
                        ],
                      )
                    ],
                  )
          ],
        ),
      ],
    );
  }
}
