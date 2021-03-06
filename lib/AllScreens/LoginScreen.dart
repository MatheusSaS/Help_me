import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:help_me/AllScreens/mainscreen.dart';
import 'package:help_me/AllScreens/signupscreen.dart';
import 'package:help_me/AllWidgets/progressDialog.dart';
import 'package:help_me/main.dart';

class Loginscreen extends StatelessWidget {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Image(
                image: AssetImage('images/logo_transparent.png'),
                height: 270,
                width: 270,
                alignment: Alignment.center,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Olá!',
                        style: TextStyle(
                            color: Colors.black.withOpacity(.7),
                            fontSize: 40,
                            fontFamily: "Brand-Bold"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 8,
                        width: width * .5,
                        decoration: BoxDecoration(
                          color: Color(0xFFFE7550),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      )
                    ],
                  )
                ],
              ),
              customtextfield(
                hint: 'Email',
                issecured: false,
                type: TextInputType.emailAddress,
                nameFeldController: emailTextEditingController,
              ),
              customtextfield(
                hint: 'Senha',
                issecured: true,
                type: TextInputType.text,
                nameFeldController: passwordTextEditingController,
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  AnimatedButton(
                    enabled: true,
                    height: 50,
                    width: 130,
                    color: Color(0xFFFE7550),
                    onPressed: () {
                      if (!emailTextEditingController.text.contains("@")) {
                        displayToastMessage("Email incorreto!", context);
                      }
                      if (passwordTextEditingController.text.isEmpty) {
                        displayToastMessage("Senha invalida!", context);
                      } else {
                        loginAndAuthenticateUser(context);
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ),
                  Text(
                    'Precisa de ajuda?',
                    style: TextStyle(
                        color: Color(0xFFFE7550),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              SizedBox(
                height: height * .15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Não possui conta?",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => Sigupscreen()));
                    },
                    child: Text(
                      'Registrar',
                      style: TextStyle(
                          color: Color(0xFFFE7550),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Autenticando...",
          );
        });

    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Erro: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => MainScreen()));
          displayToastMessage("Login efetuado corretamente!", context);
        } else {
          Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Não foi possivel efetuar o login !", context);
        }
      });
    } else {
      //error
      Navigator.pop(context);
      displayToastMessage("Usuario não encontrado!", context);
    }
  }
}

class customtextfield extends StatelessWidget {
  bool issecured;
  String hint;
  TextInputType type;
  TextEditingController nameFeldController;

  customtextfield(
      {this.hint, this.issecured, this.type, this.nameFeldController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: nameFeldController,
        keyboardType: type,
        obscureText: issecured,
        decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.black12,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.transparent)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.transparent)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.transparent))),
        style: TextStyle(
            color: Colors.black.withOpacity(.6),
            fontWeight: FontWeight.w600,
            fontSize: 17),
      ),
    );
  }
}
