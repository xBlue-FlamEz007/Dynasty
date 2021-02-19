import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    this.controller,
    this.labelText,
    this.obscureText: false,
    this.validator
});

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }
}
