import 'package:dynasty/app/sign_in/email_sign_in_form.dart';
import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor : Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.fromLTRB(100.0, 50.0, 0.0, 0.0),
              child: Row(
                children: <Widget> [
                  Text(
                    'Hello There',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '.',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[500],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: EmailSignInForm()
              ),
            ),
          ]
        ),
      ),
    );
  }
}

