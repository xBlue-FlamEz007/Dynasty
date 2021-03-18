import 'dart:io';
import 'package:dynasty/common_widgets/custom_text_form_field.dart';
import 'package:dynasty/common_widgets/form_submit_button.dart';
import 'package:dynasty/common_widgets/loading.dart';
import 'package:dynasty/common_widgets/platform_alert_dialog.dart';
import 'package:dynasty/common_widgets/radio_button.dart';
import 'package:dynasty/services/auth.dart';
import 'package:dynasty/services/database.dart';
import 'package:dynasty/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum AddPostFormType { sell, rent }

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Validator _validator = Validator();
  Radiobutton _radioButton = Radiobutton();
  final ImagePicker _picker = ImagePicker();
  PickedFile _imagePickedFile;
  File _imageFile;
  bool _isLoading = false;

  String get _description => _descriptionController.text;
  String get _address => _addressController.text;
  String get _price => _priceController.text;
  String get _radioValue => _radioButton.radioItem;
  AddPostFormType _formType = AddPostFormType.sell;

  void _submit() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final _userID = auth.currentUserID();
      final _propertyType = _radioButton.radioItem;
      final _dealType = _formType == AddPostFormType.sell ? 'Sell' : 'Rent';
      setState(() => _isLoading = true);
      await DatabaseService(uid: _userID).setPropertyData(_imageFile, _propertyType, _description,
          _address, _dealType, _price);
      PlatformAlertDialog(
        title: 'Property Uploaded',
        content: 'Your property has been uploaded',
        defaultActionText: 'OK',
      ).show(context);
      setState(() => _isLoading = false);
      //Navigator.of(context).pop();
    }  catch (e) {
      setState(() => _isLoading = false);
      PlatformAlertDialog(
        title: 'Sign in failed',
        content: e.message,
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  Widget _propertyPicField() {

    double paddingFromLeft = _imageFile == null ? 225 : 210;
    double paddingFromTop = _imageFile == null ? 120 : 130;

    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            height: 150.0,
            width: 300.0,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: _imageFile == null ?
              Image.asset('assets/images/property_icon.png') : Image.asset(_imageFile.path),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(paddingFromLeft, paddingFromTop, 0.0, 0.0),
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
            'Upload Property Image',
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
      _imageFile = File(_imagePickedFile.path);
    });
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == AddPostFormType.sell ?
      AddPostFormType.rent : AddPostFormType.sell;
      _priceController.clear();
    });
  }

  void _getCurrentLocation() async {
    var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);
    print(position.latitude);
    print(position.longitude);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    final first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    setState(() {
      _addressController.text = first.addressLine;
    });
    print(_addressController.text);
    print(_radioValue);
    print(_price);
  }

  CustomTextFormField _buildDescriptionTextField() {
    return CustomTextFormField(
      controller: _descriptionController,
      labelText: 'Description',
      validator: (val) =>_validator.checkEmpty(val, 'Description'),
    );
  }

  CustomTextFormField _buildAddressTextField() {
    return CustomTextFormField(
      controller: _addressController,
      labelText: 'Address',
      validator:  (val) =>_validator.checkEmpty(val, 'Address'),
    );
  }

  dynamic _buildLocation () {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(100.0, 6.0, 0.0, 0.0),
            child: Icon(
              Icons.location_on,
              size: 15.0,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(115.0, 5.0, 0.0, 0.0),
              child: Text(
                'Get Current Location',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              )
          ),
        ],
      ),
      onTap: _getCurrentLocation,
    );
  }

  TextFormField _buildPriceTextField(priceLabelText) {
    return TextFormField(
        controller: _priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: priceLabelText,
        ),
      validator: _validator.numberValidator,
    );
  }

  List<Widget> _buildChildren() {
    final sellTextWeight = _formType == AddPostFormType.sell ?
    FontWeight.w500 : FontWeight.w300;
    final rentTextWeight = _formType == AddPostFormType.rent ?
    FontWeight.w500 : FontWeight.w300;
    final priceLabelText = _formType == AddPostFormType.sell ?
    'Price' : 'Price(per month)';
    return [
      _propertyPicField(),
      SizedBox(height: 15.0,),
      Text(
        'Select Type',
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 15.0,
        ),
      ),
      _radioButton,
      _buildDescriptionTextField(),
      SizedBox(height: 10.0,),
      _buildAddressTextField(),
      SizedBox(height: 10,),
      Center(child: Text('or')),
      _buildLocation(),
      SizedBox(height: 15.0,),
      Row(
        children: <Widget>[
          GestureDetector(
            child: Text(
              'Sell',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: sellTextWeight
              ),
            ),
            onTap: _toggleFormType,
          ),
          SizedBox(width: 10.0,),
          GestureDetector(
            child: Text(
              'Rent',
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: rentTextWeight,
              ),
            ),
            onTap: _toggleFormType,
          ),
        ],
      ),
      _buildPriceTextField(priceLabelText),
      SizedBox(height: 30.0,),
      FormSubmitButton(
        text: 'Upload',
        onPressed: _submit,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return  _isLoading ? Loading() : Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 0.0),
        child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: _buildChildren(),
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}
