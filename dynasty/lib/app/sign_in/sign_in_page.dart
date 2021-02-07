import 'package:dynasty/app/sign_in/email_sign_in_page.dart';
import 'package:dynasty/app/sign_in/sign_in_button.dart';
import 'package:dynasty/app/sign_in/social_sign_in_button.dart';
import 'package:dynasty/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EmailSignInPage(),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
      backgroundColor: Colors.green[500],
    );
  }

  Container _buildContent(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Image.asset(
            'assets/images/applogo.png',
            height: 300.0,
          ),
          SizedBox(height: 30.0,),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.green[900],
            onPressed: () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0,),
          Text(
            'or',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0,),
          SocialSignInButton(
            assetName: 'assets/images/google.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: () => _signInWithGoogle(context),
          ),
        ],
      ),
    );
  }
}




