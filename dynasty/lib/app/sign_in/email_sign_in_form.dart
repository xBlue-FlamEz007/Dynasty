import 'dart:io';
import 'package:dynasty/common_widgets/custom_text_form_field.dart';
import 'package:dynasty/common_widgets/form_submit_button.dart';
import 'package:dynasty/common_widgets/loading.dart';
import 'package:dynasty/common_widgets/platform_alert_dialog.dart';
import 'package:dynasty/common_widgets/select_pics.dart';
import 'package:dynasty/services/auth.dart';
import 'package:dynasty/services/validation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File _imageFile;
  SelectPics _imageHandler = SelectPics();
  Validator _validator = Validator();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String get _firstName => _firstNameController.text;
  String get _lastName => _lastNameController.text;
  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _confirmPassword => _confirmPasswordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _submit() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();

    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      setState(() => _isLoading = true);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        _imageFile = _imageHandler.imageFile;
        await auth.createUserWithEmailAndPassword(_firstName, _lastName, _email, _password, _imageFile);
      }
      Navigator.of(context).pop();
    }  catch (e) {
      setState(() => _isLoading = false);
      PlatformAlertDialog(
        title: 'Sign in failed',
        content: e.message,
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn ?
          EmailSignInFormType.register : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn ?
        'Sign in' : 'Register';
    final secondaryText = _formType == EmailSignInFormType.signIn ?
        'New User ? Register here' : 'Already a user? Sign in here';
    return [
      _profilePicField(),
      SizedBox(height: 8.0,),
      _buildFirstNameTextField(),
      SizedBox(height: 8.0,),
      _buildLastNameTextField(),
      SizedBox(height: 8.0,),
      _buildEmailTextField(),
      SizedBox(height: 8.0,),
      _buildPasswordTextField(),
      SizedBox(height: 8.0,),
      _buildConfirmPasswordTextField(),
      SizedBox(height: 16.0,),
      FormSubmitButton(
        text: primaryText,
        onPressed: _submit,
      ),
      SizedBox(height: 8.0,),
      FlatButton(
        child: Text(secondaryText),
        onPressed: _toggleFormType,
      ),
    ];
  }

  String _confirmPasswordValidator(value) {
    if (value.isEmpty || value != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  Widget _profilePicField() {
    if (_formType == EmailSignInFormType.register) {
      return _imageHandler;
    } else {
      return Container();
    }
  }

  Widget _buildPasswordTextField() {
    return CustomTextFormField(
      controller: _passwordController,
      labelText: 'Password',
      obscureText: true,
      validator: _validator.passwordValidator,
    );
  }

  Widget _buildConfirmPasswordTextField() {
    if (_formType == EmailSignInFormType.register) {
      return CustomTextFormField(
        controller: _confirmPasswordController,
        labelText: 'Confirm Password',
        obscureText: true,
        validator: _confirmPasswordValidator,
      );
    } else {
      return Container();
    }
  }

  Widget _buildEmailTextField() {
    return CustomTextFormField(
      controller: _emailController,
      labelText: 'Email',
      validator: _validator.emailValidator,
    );
  }

  Widget _buildFirstNameTextField() {
    if (_formType == EmailSignInFormType.register) {
      return CustomTextFormField(
        controller: _firstNameController,
        labelText: 'First Name',
        validator: _validator.nameValidator,
      );
    } else {
      return Container();
    }
  }

  Widget _buildLastNameTextField() {
    if (_formType == EmailSignInFormType.register) {
      return CustomTextFormField(
        controller: _lastNameController,
        labelText: 'Last Name',
        validator: _validator.nameValidator,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loading() : Padding(
      padding: EdgeInsets.all(16.0),
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
    );
  }
}



