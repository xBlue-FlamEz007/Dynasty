import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectPics extends StatefulWidget {
  SelectPics({this.imageFile, this.url = "https://workhound.com/wp-content/uploads/2017/05/placeholder-profile-pic.png"});
  File imageFile;
  String url;

  @override
  _SelectPicsState createState() => _SelectPicsState();
}

class _SelectPicsState extends State<SelectPics> {
  final ImagePicker _picker = ImagePicker();
  PickedFile _imagePickedFile;
  bool _fileImage = false; 
  Widget profilePicField() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 45.0,
            backgroundImage: _fileImage == false ? NetworkImage(widget.url) : FileImage(widget.imageFile)
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
                    context: context, builder: ((builder) => _bottomSheet()));
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
          SizedBox(
            height: 20.0,
          ),
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
      _fileImage = true ; 
      _imagePickedFile = pickedFile;
      widget.imageFile = File(_imagePickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return profilePicField();
  }
}
