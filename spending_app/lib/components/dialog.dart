import 'package:flutter/material.dart';

Future<void> dialogBuilder(BuildContext context, String content) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Thông Báo'),
        content: Text('$content'),
        actions: <Widget>[
          TextButton(
            child: Text(
              'đóng',
              style: TextStyle(color: Colors.green),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
