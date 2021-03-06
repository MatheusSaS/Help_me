import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:help_me/AllScreens/LoginScreen.dart';
import 'package:help_me/AllScreens/homepage.dart';
import 'package:help_me/AllScreens/mainscreen.dart';
import 'package:help_me/DataHandler/appData.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: 'Help.me',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? Loginscreen()
            : MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
