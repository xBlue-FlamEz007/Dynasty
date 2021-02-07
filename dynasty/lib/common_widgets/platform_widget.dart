import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {

  Widget buildMaterialWidget(BuildContext context);
  @override
  Widget build(BuildContext context) {
    return buildMaterialWidget(context);
  }
}
