import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:flutter/material.dart';

loadingGlobal(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextGlobal(
                message: "Tunggu Sebentar...",
                colorText: Colors.white,
              )
            ],
          ),
        );
      },
      barrierDismissible: false);
}
