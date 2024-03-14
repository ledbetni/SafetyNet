import 'package:flutter/material.dart';
import 'package:safetynet/lib.dart';

void showLoginAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text('Please Log in'),
          content: Text('You must be logged in to perform this action'),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text('Login'))
          ],
        );
      }));
}
