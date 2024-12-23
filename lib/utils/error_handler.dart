import 'package:flutter/material.dart';

void showErrorDialog(
    BuildContext context, String message, VoidCallback onRetry) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Icon(Icons.error, color: Colors.red),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("OK"),
        ),
        TextButton(
          onPressed: () {
            onRetry();
            Navigator.of(context).pop();
          },
          child: Text("Retry"),
        ),
      ],
    ),
  );
}
