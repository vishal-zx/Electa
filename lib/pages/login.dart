import 'dart:async';
import 'dart:core';
import 'package:electa/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";

  String _name = "";
  bool _check1 = false;
  bool _check = false;
  final formKey = GlobalKey<FormState>();
  bool _showPass = true;
  String _validRoll = "false";

  RegExp regExp = new RegExp(r"^\d{2}[a-z]{3}\d{3}$",
    caseSensitive: false,
  );

  // ignore: non_constant_identifier_names
  check(BuildContext) async{
    if(formKey.currentState!.validate()){
      setState(() {
        _check1 = true;
      });
    }
  }

  
  // ignore: non_constant_identifier_names
  moveHome(BuildContext, String a) async{
    if(a == "" && _check1 == true){
      if(formKey.currentState!.validate()){
        setState(() {
          _check = true;
        });

        await Future.delayed(Duration(seconds: 1));
        await Navigator.pushNamed(context, MyRoutes.homeRoute);
        setState(() {
          _check = false;
        });
      }
    }
  }

  SnackBar makeBar(String text){
    final snackBar = SnackBar(
      duration: Duration(milliseconds: (text=="Loading...")?700:3000),
      content: Text('$text', textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 15),
      ),
      backgroundColor: Colors.black87.withOpacity(0.89),
      elevation: 3,
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    );
    return snackBar;
  }

  void _togglePass(){
    setState(() {
      _showPass = !_showPass;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // color: Colors.white,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Image.asset(
                  "assets/images/hey.png",
                  fit: BoxFit.fitHeight, 
                  // height: 400,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Welcome$_name",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Enter your Roll No. (eg. 19UCS053)",
                          labelText: "Roll Number"
                        ),
                        validator: (value){
                          value = value!.replaceAll(' ', '');
                          _validRoll = regExp.hasMatch(value).toString();
                          if(value.isEmpty){
                            return "Roll Number can't be Empty!";
                          }
                          else if(_validRoll == "false"){
                            return "Invalid Roll Number";
                          }
                          return null;
                        },
                        onChanged: (value){
                          value = value.replaceAll(' ', '');
                          _name = ', ' + value;
                          email = value + "@lnmiit.ac.in";
                          setState(() {
                            
                          });
                          if(value == "") _name = "";
                        },
                      ),
                      TextFormField(
                        obscureText: _showPass,
                        decoration: InputDecoration(
                          hintText: "Enter your Password",
                          labelText: "Password",
                          suffix: InkWell(
                            onTap: _togglePass,
                            child: Icon(this._showPass?Icons.visibility:Icons.visibility_off),
                          )
                        ),
                        validator: (value){
                          if(value!.isEmpty){return "Password can't be Empty!";}
                          else if(value.length < 6){return "Password lenght should be greater than 6!";}
                          else  return null;
                        },
                        onChanged: (value){
                          password = value;
                          setState(() {
                            
                          });
                        },
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      Material(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(_check?50:8),
                        child: InkWell(
                          onTap: () async{
                            check(context);
                            FirebaseAuthException er = FirebaseAuthException(code: "");
                            String msg = "";
                            final snackBar;
                            try {
                              await _auth.signInWithEmailAndPassword(email: email, password: password);
                            } 
                            on FirebaseAuthException catch (e){
                              er = e; 
                            } 
                            if(er.code == 'user-not-found'){
                              msg = 'No Such User found!';
                            }else if(er.code == 'wrong-password'){
                              msg = 'Incorrect Password !';
                            }else if(er.code == ""){
                              moveHome(context, er.code);
                              msg = 'Loading...';
                            }
                            snackBar = makeBar(msg);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: _check?50: 120,
                            height: 50,
                            alignment: Alignment.center,
                            child: _check?
                            Icon(
                              Icons.done, color: Colors.white,
                            ) :
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: Text(
                                "Don't have an account?\nCreate One!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Material(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap:(){ Navigator.pushNamed(context, MyRoutes.registerRoute);},
                                child: AnimatedContainer(
                                  duration: Duration(seconds: 1),
                                  width: 
                                  90,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.white, 
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}