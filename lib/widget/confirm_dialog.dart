import 'package:flutter/material.dart';

confirmDialog({
  required String confirmation,
  context,
  List<Widget>? children,
  String? title,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title!),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              confirmation,
              style: const TextStyle(fontSize: 14,),
            ),
            const SizedBox(height: 30),
            Row(
              children: children!,
            )
          ],
        ),
      );
    },
  );
}