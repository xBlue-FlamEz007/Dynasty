import 'package:dynasty/app/sign_in/email_sign_in_form.dart';
import 'package:dynasty/common_widgets/custom_text_form_field.dart';
import 'package:dynasty/common_widgets/form_submit_button.dart';
import 'package:dynasty/common_widgets/platform_alert_dialog.dart';
import 'package:dynasty/services/auth.dart';
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

  String _nameValidator(value) {
    if (value.isEmpty ||
        !RegExp(r"^^[a-zA-Z]+").hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

  CustomTextFormField _buildFirstNameTextField() {
    return CustomTextFormField(
      controller: _firstNameController,
      labelText: 'First Name',
      obscureText: true,
      validator: _nameValidator,
    );
  }

  CustomTextFormField _buildLastNameTextField() {
    return CustomTextFormField(
      controller: _lastNameController,
      labelText: 'Last Name',
      obscureText: true,
      validator: _nameValidator,
    );
  }

  List<Widget> _buildChildren() {
    return [
     // _profilePicField(),
      SizedBox(height: 8.0,),
      _buildFirstNameTextField(),
      SizedBox(height: 8.0,),
      _buildLastNameTextField(),
      SizedBox(height: 16.0,),
      FormSubmitButton(
        text: 'Update',
        onPressed: () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
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
}
