import 'dart:io';
import 'package:dynasty/common_widgets/custom_text_form_field.dart';
import 'package:dynasty/common_widgets/form_submit_button.dart';
import 'package:dynasty/common_widgets/loading.dart';
import 'package:dynasty/common_widgets/platform_alert_dialog.dart';
import 'package:dynasty/common_widgets/select_pics.dart';
import 'package:dynasty/modals/user.dart';
import 'package:dynasty/services/auth.dart';
import 'package:dynasty/services/database.dart';
import 'package:dynasty/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String get _firstName => _firstNameController.text;
  String get _lastName => _lastNameController.text;
  File _imageFile;
  SelectPics _imageHandler = SelectPics();
  Validator _validator = Validator();

  void _submit() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      String uid = auth.currentUserID();
      _imageFile = _imageHandler.imageFile;
      await DatabaseService(uid: uid).updateUserData(_firstName, _lastName, _imageFile);
      Navigator.of(context).pop();
    }  catch (e) {
      PlatformAlertDialog(
        title: 'Profile Update Failed',
        content: e.message,
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  CustomTextFormField _buildFirstNameTextField() {
    return CustomTextFormField(
      controller: _firstNameController,
      labelText: 'First Name',
      validator: _validator.nameValidator,
    );
  }

  CustomTextFormField _buildLastNameTextField() {
    return CustomTextFormField(
      controller: _lastNameController,
      labelText: 'Last Name',
      validator: _validator.nameValidator,
    );
  }

  List<Widget> _buildChildren() {
    return [
      _imageHandler,
      SizedBox(height: 8.0,),
      _buildFirstNameTextField(),
      SizedBox(height: 8.0,),
      _buildLastNameTextField(),
      SizedBox(height: 16.0,),
      FormSubmitButton(
        text: 'Update',
        onPressed: _submit,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthBase>(context, listen: false);
    String uid = auth.currentUserID();

    return StreamBuilder(
      stream: DatabaseService(uid: uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          _firstNameController.text = userData.firstName;
          _lastNameController.text = userData.lastName;
          String _imageName = userData.profilePic;
          _imageHandler.url = _imageName;

          return Scaffold(
            appBar: AppBar(
              title: Text('Profile'),
              centerTitle: true,
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => _confirmSignOut(context),
                )
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
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
            ),
          );
        }
        else {
          return Loading();
        }
      },
    );
  }
}
