import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';

alertNotification({
  required BuildContext context,
  required String type,
  String? title,
  required String message,
}) {
  ElegantNotification(
      width: 300,
      notificationMargin: 10,
      description: TextGlobal(
        message: message,
        colorText: Colors.white,
      ),
      title: TextGlobal(
        message: title ?? (type == 'error' ? 'Error' : 'Berhasil'),
        colorText: Colors.white,
        fontSize: 14,
      ),
      background: type == 'error' ? Colors.red : Colors.green,
      progressIndicatorColor: type == 'error'
          ? Colors.red.withOpacity(0.5)
          : Colors.green.withOpacity(0.5),
      icon: Icon(
        type == 'error' ? Icons.close : Icons.done_all,
        color: Colors.white,
      )).show(context);
}
