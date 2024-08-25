import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2), // How long the snackbar will be shown
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Add action to perform when 'Undo' is pressed, if needed
      },
    ),
  );

  // Show the snackbar
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
