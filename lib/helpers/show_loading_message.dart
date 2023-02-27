import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showLoadingMessage(BuildContext context) {
  Platform.isAndroid
      ? showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: const Text('Espere porfavor'),
                content: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: const [
                      Text('Calculando ruta'),
                      SizedBox(height: 15),
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ))
      : showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const CupertinoAlertDialog(
                title: Text('Espere porfavor'),
                content: CupertinoActivityIndicator(),
              ));
  return;
}
