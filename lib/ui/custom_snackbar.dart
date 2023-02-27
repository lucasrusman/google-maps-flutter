// Flutter imports:
import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar {
  CustomSnackBar(
      {super.key,
      required String message,
      String btnLabel = 'OK',
      Duration duration = const Duration(seconds: 2),
      VoidCallback? onOK})
      : super(
            content: Text(message),
            duration: duration,
            action: SnackBarAction(
              label: btnLabel,
              onPressed: () {
                if (onOK != null) {
                  onOK();
                }
              },
            ));
}
