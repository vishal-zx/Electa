import 'dart:async';

import 'package:electa/utils/routes.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _name = "";
  bool _check = false;
  final formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  moveHome(BuildContext) async{
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30.0,
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
                        hintText: "Enter your Username",
                        labelText: "Username"
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Username can't be Empty!";
                        }
                        return null;
                      },
                      onChanged: (value){
                        _name = ', ' + value;
                        setState(() {
                          
                        });
                        if(value == "") _name = "";
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter your Password",
                        labelText: "Password"
                      ),
                      validator: (value){
                        if(value!.isEmpty){return "Password can't be Empty!";}
                        else if(value.length < 6){return "Password lenght should be greater than 6!";}
                        else  return null;
                      },
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(_check?50:8),
                      child: InkWell(
                        onTap: () => moveHome(context),
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
                              // onTap: () => moveHome(context),
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
    );
  }
}