import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    String massage, BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();

  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(massage)));
}
