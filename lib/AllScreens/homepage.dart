import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:help_me/AllScreens/mainscreen.dart';
import 'package:help_me/AllScreens/signupscreen.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/back1.png'), fit: BoxFit.fill)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height * .11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 35,
                  ),
                  Text(
                    'Bem-Vindo!',
                    style: TextStyle(
                        fontSize: 45,
                        fontFamily: "Brand-Bold",
                        color: Color(0xFFFE7550)),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 35,
                  ),
                  Text(
                    'É um prazer ter você denovo aqui!',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 35,
                  ),
                  AnimatedButton(
                    enabled: true,
                    height: 50,
                    width: 130,
                    color: Color(0xFFFE7550),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * .6,
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
}
