import 'package:dynasty/app/landing_page.dart';
import 'package:dynasty/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: 'Dynasty',
        theme: ThemeData(
          primaryColor: Colors.green[500],
        ),
        home: LandingPage()
      ),
    );
  }
}

