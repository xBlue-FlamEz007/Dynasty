import 'package:dynasty/app/navigation_bar.dart';
import 'package:dynasty/modals/user.dart';
import 'package:dynasty/services/auth.dart';
import 'package:dynasty/app/sign_in/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<USER>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          USER user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return NavigationBar();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      }
    );
  }
}
