// ignore_for_file: must_be_immutable

import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'global_text_component.dart';

class FormGlobal extends StatelessWidget {
  FormGlobal(
      {super.key,
      this.title,
      this.onChanged,
      this.validator,
      this.keyboardType});
  String? title;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == null
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextGlobal(message: title!),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
        BlocBuilder<ThemeCubit, bool>(
          builder: (context, stateTheme) {
            return TextFormField(
                autofocus: true,
                style: TextStyle(
                    fontFamily: 'quicksand',
                    fontSize: 12,
                    color: stateTheme ? Colors.white : Colors.black),
                onChanged: onChanged,
                validator: validator,
                keyboardType: keyboardType,
                inputFormatters: keyboardType == TextInputType.number
                    ? <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ]
                    : null,
                decoration: InputDecoration(
                    errorStyle:
                        const TextStyle(fontFamily: 'quicksand', fontSize: 12),
                    labelStyle:
                        const TextStyle(fontFamily: 'quicksand', fontSize: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.red.withOpacity(0.3),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.red,
                      ),
                    )));
          },
        ),
      ],
    );
  }
}
