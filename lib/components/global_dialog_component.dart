import 'package:attend_smart_admin/bloc/theme/theme_cubit.dart';
import 'package:attend_smart_admin/components/global_color_components.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

dialogQuestion(BuildContext context,
    {required Function() onTapYes,
    required String message,
    Function()? onTapNo,
    Icon? icon,
    String? title,
    bool? visibleBtnNo = true}) {
  showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<ThemeCubit, bool>(
          builder: (context, state) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: state ? blueDefaultDark : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          color: state ? blueDefaultDark : Colors.white,
                          child: Column(
                            children: [
                              icon ?? Container(),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontFamily: 'quicksand', fontSize: 14),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  visibleBtnNo == true
                                      ? InkWell(
                                          onTap: onTapNo ??
                                              () {
                                                // Get.back();
                                                Navigator.of(context).pop();
                                              },
                                          child: Container(
                                            width: 100,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: TextGlobal(
                                              message: "Tidak",
                                              colorText: Colors.white,
                                            )),
                                          ),
                                        )
                                      : Container(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: onTapYes,
                                    child: Container(
                                      width: 100,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Center(
                                          child: TextGlobal(
                                        message: "Ya",
                                        colorText: Colors.white,
                                      )),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
}
