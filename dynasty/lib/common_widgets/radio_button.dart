import 'package:flutter/material.dart';

class Radiobutton extends StatefulWidget {
  Radiobutton({this.radioItem : 'Apartment'});

  String radioItem;

  @override
  RadioButtonWidget createState() => RadioButtonWidget();
}

class RadioButtonWidget extends State<Radiobutton> {

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        RadioListTile(
          groupValue: widget.radioItem,
          title: Text('Apartment'),
          value: 'Apartment',
          onChanged: (val) {
            setState(() {
              widget.radioItem = val;
            });
          },
        ),
        Padding(
          padding: EdgeInsets.only(top : 30.0),
          child: RadioListTile(
            groupValue: widget.radioItem,
            title: Text('Bungalow'),
            value: 'Bungalow',
            onChanged: (val) {
              setState(() {
                widget.radioItem = val;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top : 60.0),
          child: RadioListTile(
            groupValue: widget.radioItem,
            title: Text('Office'),
            value: 'Office',
            onChanged: (val) {
              setState(() {
                widget.radioItem = val;
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top : 90.0),
          child: RadioListTile(
            groupValue: widget.radioItem,
            title: Text('Warehouse'),
            value: 'Warehouse',
            onChanged: (val) {
              setState(() {
                widget.radioItem = val;
              });
            },
          ),
        ),
      ],
    );
  }
}