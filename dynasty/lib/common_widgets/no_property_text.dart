import 'package:flutter/material.dart';

class NoPropertyText extends StatefulWidget {
  @override
  _NoPropertyTextState createState() => _NoPropertyTextState();
}

class _NoPropertyTextState extends State<NoPropertyText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(50.0, 200.0, 30.0, 0.0),
      child : Text(
        'No properties available',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.0
        ),
      ),
    );
  }
}
