import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectPics extends StatefulWidget {
  SelectPics({
    this.imageFile,
    this.url
  });

  File imageFile;
  String url;

  @override
  _SelectPicsState createState() => _SelectPicsState();
}

class _SelectPicsState extends State<SelectPics> {

  final ImagePicker _picker = ImagePicker();
  PickedFile _imagePickedFile;

  Widget profilePicField() {

    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 45.0,
            backgroundImage: widget.url == null ?
            widget.imageFile == null ?
            AssetImage('assets/images/default_profilepic.png') : AssetImage(widget.imageFile.path)
            : Image(image: NetworkImage(widget.url)),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(75.0, 68.0, 0.0, 0.0),
            child: InkWell(
              child: Icon(
                Icons.camera_alt,
                color: Colors.green[700],
                size: 25.0,
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => _bottomSheet())
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Pic',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(
                  Icons.camera,
                  color: Colors.green[800],
                ),
                onPressed: () {
                  _takePic(ImageSource.camera);
                },
                label: Text('Camera'),
              ),
              FlatButton.icon(
                icon: Icon(
                  Icons.image,
                  color: Colors.green[800],
                ),
                onPressed: () {
                  _takePic(ImageSource.gallery);
                },
                label: Text('Gallery'),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _takePic(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imagePickedFile = pickedFile;
      widget.imageFile = File(_imagePickedFile.path);
      print("IMAGE:${_imagePickedFile.path}");
    });
  }


  @override
  Widget build(BuildContext context) {
    return profilePicField();
  }
}


