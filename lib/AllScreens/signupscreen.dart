import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help_me/AllScreens/LoginScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:help_me/AllScreens/mainscreen.dart';
import 'package:help_me/AllWidgets/progressDialog.dart';
import 'package:help_me/main.dart';

class Sigupscreen extends StatelessWidget {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/back3.png'), fit: BoxFit.fill),
            color: Colors.white),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: height * .06,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: width * .07,
                    ),
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: width * .07,
                  ),
                  Text(
                    'Criar Conta',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Brand-Bold",
                        fontSize: 30),
                  ),
                ],
              ),
              SizedBox(
                height: height * .2,
              ),
              customtextfield(
                hint: 'Nome',
                issecured: false,
                type: TextInputType.text,
                nameFeldController: nameTextEditingController,
              ),
              customtextfield(
                hint: 'Email',
                issecured: false,
                type: TextInputType.emailAddress,
                nameFeldController: emailTextEditingController,
              ),
              customtextfield(
                hint: 'Telefone',
                issecured: false,
                type: TextInputType.phone,
                nameFeldController: phoneTextEditingController,
              ),
              customtextfield(
                hint: 'Senha',
                issecured: true,
                type: TextInputType.text,
                nameFeldController: passwordTextEditingController,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ButtonTheme(
                  minWidth: width,
                  height: 55,
                  child: RaisedButton(
                    color: Color(0xFFFE7550),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPressed: () {
                      if (nameTextEditingController.text.length < 6) {
                        displayToastMessage("Nome muito pequeno!", context);
                      } else if (!emailTextEditingController.text
                          .contains("@")) {
                        displayToastMessage("Email incorreto!", context);
                      } else if (phoneTextEditingController.text.isEmpty) {
                        displayToastMessage("Telefone incorreto!", context);
                      } else if (passwordTextEditingController.text.length <
                          6) {
                        displayToastMessage("Senha muito pequena!", context);
                      } else {
                        registerNewUSer(context);
                      }
                    },
                    child: Text(
                      'Criar',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUSer(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Registrando...",
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayToastMessage("Erro: " + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      //user created
      //save user info to database
      Map userDataMap = {
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Conta criada!", context);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } else {
      //error
      Navigator.pop(context);
      displayToastMessage("Usuario não encontrado!", context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
