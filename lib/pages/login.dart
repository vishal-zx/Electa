import 'dart:async';
import 'dart:core';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _auth = FirebaseAuth.instance;
  String email = "";
  String emailReset = "";
  String password = "";

  String _name = "";
  bool _check1 = false;
  bool _check3 = false;
  bool _check = false;
  final formKey = GlobalKey<FormState>(); 
  final formKeyReset = GlobalKey<FormState>(); 
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

  checkReset(BuildContext context) async{
    if(formKeyReset.currentState!.validate()){
      setState(() {
        _check3 = true;
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
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('candidates').where('Roll', isEqualTo: email.substring(0,8).toUpperCase()).get();
          var cans = querySnapshot.docs;
          if(cans.length == 0) {
            await Future.delayed(Duration(seconds: 1));
            await Navigator.pushNamed(context, MyRoutes.homeRoute);
          }
          else{
            await Future.delayed(Duration(seconds: 1));
            await Navigator.pushNamed(context, MyRoutes.candHomeRoute);
          }
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/hey.png",
                    fit: BoxFit.fitHeight, 
                    // height: 400,
                  ),
                  SizedBox(
                    height: 25.0,
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
                          color: (_check1 == true)?Colors.grey:Colors.black,
                          borderRadius: BorderRadius.circular(_check?50:8),
                          child: InkWell(
                            onTap: () async{
                              check(context);
                              if(_check1 == true){
                                var fl = -1;
                                var ch=-1;
                                FirebaseAuthException er = FirebaseAuthException(code: "");
                                String msg = "";
                                final snackBar;
                                try{
                                  await _auth.signInWithEmailAndPassword(email: email, password: password).then((value){
                                    User? user = FirebaseAuth.instance.currentUser;
                                    if(user!=null && !user.emailVerified)
                                    {
                                      ScaffoldMessenger.of(context).showSnackBar(makeBar("Please verify your email first !"));
                                      FirebaseAuth.instance.signOut();
                                      setState(() {
                                        _check1 = false;
                                      });
                                    }
                                    else{
                                      fl =1;
                                    }
                                  });
                                } on FirebaseAuthException catch (e){
                                  er = e; 
                                  ch=1;
                                }
                                if(er.code == 'user-not-found'){
                                    msg = 'No Such User found!';
                                  }else if(er.code == 'wrong-password'){
                                    msg = 'Incorrect Password !';
                                  }else if(er.code == ""){
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('email', email);
                                    moveHome(context, er.code);
                                    msg = 'Loading...';
                                  }
                                  snackBar = makeBar(msg);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    _check1 = false;
                                  }
                                );
                                if(fl==1)
                                {
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
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('email', email);
                                    moveHome(context, er.code);
                                    msg = 'Loading...';
                                  }
                                  snackBar = makeBar(msg);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  setState(() {
                                    _check1 = false;
                                  });
                                }
                                else if(ch!=1)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(makeBar("Please verify your email first !"));
                                }
                              }
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
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          margin: EdgeInsets.all(0),
                          child: TextButton(
                            onPressed: () {
                              _check3 = false;
                              showDialog(
                                context: context,
                                builder:  (BuildContext context)
                                {
                                  return AlertDialog(
                                    title: const Text('Reset Password'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Enter your Roll Number to reset the password.'),
                                          SizedBox(
                                            height:15,
                                          ),
                                          Form(
                                            key: formKeyReset,
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: "Roll Number",
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
                                                emailReset = value + "@lnmiit.ac.in";
                                                setState(() {
                                                  
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Send Reset Password Link', style: TextStyle(color:Colors.black)),
                                        onPressed: () {
                                          checkReset(context);
                                          if(_check3==true)
                                          {
                                            FirebaseAuth.instance.sendPasswordResetEmail(email: emailReset);
                                            Future.delayed(const Duration(seconds: 2), () {
                                              Navigator.of(context).pop();
                                              showDialog(
                                                context: context,
                                                builder:  (BuildContext context)
                                                {
                                                  return AlertDialog(
                                                    title: const Text('Email Sent'),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    content: SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text('If entered Roll Number matches an existing account, Password reset mail sent to associated email address.'),
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: const Text('Close', style: TextStyle(color:Colors.black)),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            });
                                          }
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Cancel', style: TextStyle(color:Colors.black)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                                    color: Colors.black,
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
          ),
        )
      ),
    );
  }
}