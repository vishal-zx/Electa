import 'package:electa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class  ChangePswd extends StatefulWidget {
  ChangePswd({ Key? key }) : super(key: key);

  @override
  _ChangePswdState createState() => _ChangePswdState();
}

class _ChangePswdState extends State<ChangePswd> {
  bool _showPass1 = true;
  bool _showPass2 = true;
  bool _showPass3 = true;
  String current = "";
  String new1 = "";
  String new2 = "";

  void _togglePass1(){
    setState(() {
      _showPass1 = !_showPass1;
    });
  }
  void _togglePass2(){
    setState(() {
      _showPass2 = !_showPass2;
    });
  }
  void _togglePass3(){
    setState(() {
      _showPass3 = !_showPass3;
    });
  }

  SnackBar makeBar(String text){
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 2000),
      content: Text('$text', textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 15),
      ),
      backgroundColor: Colors.black87.withOpacity(1),
      elevation: 3,
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    );
    return snackBar;
  }
  
  bool check1 = false;
  
  final formKey = GlobalKey<FormState>();
  check(BuildContext context) async{
    if(formKey.currentState!.validate()){
      setState(() {
        check1 = true;
      });
    }
  }

  bool loading = true;

  void _changePass(String current, String new1, String new2) async {
    if(new1!=new2)
    {
      SnackBar snackBar = makeBar("Passwords doesn't match in new fields!");
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          loading = true;
        });

      });
    }
    else{
      String userEmail =  FirebaseAuth.instance.currentUser!.email!;
      AuthCredential credential = EmailAuthProvider.credential(email: userEmail, password: current);
      try {
        await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential).then((value)async{
          await FirebaseAuth.instance.currentUser!.updatePassword(new1).then((value)async{
            SnackBar snackBar;
            snackBar = makeBar("Password Updated Successfully!");
            setState(() {
              loading = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.of(context).pop();
          });
        });
      } on FirebaseAuthException catch (e) {
        SnackBar snackBar;
        if(e.code == "invalid-credential" || e.code == "wrong-password"){
          snackBar = makeBar("Invalid Current Password !");
        }
        else if(e.code == "too-many-requests"){
          snackBar = makeBar("Too Many Requests. Please try \nagain after some time.");
        }
        else{
          snackBar = makeBar("Something Went Wrong !");
        }
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
         Future.delayed(const Duration(milliseconds: 2100), () {
          setState(() {
            loading = true;
          });
        });
      } finally{

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          title: Text("Electa"),
          elevation: 10,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.47,
                    margin: EdgeInsets.fromLTRB(mq.width*0.05, mq.height*0.032, mq.width*0.05, mq.height*0.015),
                    padding: EdgeInsets.only(bottom: mq.height*0.014),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0), width: 2),
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(mq.width*0.07, mq.height*0.01, mq.width*0.07, 0),
                            child: TextFormField(
                              obscureText: _showPass1,
                              decoration: InputDecoration(
                                hintText: "Enter your current password",
                                labelText: "Curent Password",
                                suffix: InkWell(
                                  onTap: _togglePass1,
                                  child: Icon(this._showPass1?Icons.visibility:Icons.visibility_off),
                                )
                              ),
                              validator: (value){
                                if(value!.isEmpty){return "Password can't be Empty!";}
                                else if(value.length < 6){return "Password lenght should be greater than 6!";}
                                else  return null;
                              },
                              onChanged: (value){
                                current = value;
                              }
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(mq.width*0.07, 0, mq.width*0.07, 0),
                            child: TextFormField(
                              obscureText: _showPass2,
                              decoration: InputDecoration(
                                hintText: "Enter your new password",
                                labelText: "New Password",
                                suffix: InkWell(
                                  onTap: _togglePass2,
                                  child: Icon(this._showPass2?Icons.visibility:Icons.visibility_off),
                                )
                              ),
                              validator: (value){
                                if(value!.isEmpty){return "Password can't be Empty!";}
                                else if(value.length < 6){return "Password lenght should be greater than 6!";}
                                else  return null;
                              },
                              onChanged: (value){
                                new1 = value;
                              }
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(mq.width*0.07, 0, mq.width*0.07, mq.height*0.02),
                            child: TextFormField(
                              obscureText: _showPass3,
                              decoration: InputDecoration(
                                hintText: "Re-enter your new password",
                                labelText: "Confirm New Password",
                                suffix: InkWell(
                                  onTap: _togglePass3,
                                  child: Icon(this._showPass3?Icons.visibility:Icons.visibility_off),
                                )
                              ),
                              validator: (value){
                                if(value!.isEmpty){return "Password can't be Empty!";}
                                else if(value.length < 6){return "Password lenght should be greater than 6!";}
                                else  return null;
                              },
                              onChanged: (value){
                                new2 = value;
                              }
                            ),
                          ),
                          Material(
                            color: (loading == false)? Colors.grey: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                            child: InkWell(
                              onTap: () {
                                if(loading == true){
                                  check(context);
                                  if(check1==true)
                                  {
                                    loading = false;
                                    _changePass(current, new1, new2);
                                  }
                                }
                              },
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                width: 200,
                                height: 50,
                                alignment: Alignment.center,
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width*0.1,
                    top: MediaQuery.of(context).size.height*0.015,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      color: Colors.blueGrey[100],
                      child: Text(
                        'Change Password',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    )
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: TextButton(
                  child: Text(
                    "Having Problem?  Contact Us",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15
                    ),
                  ),
                  style: ButtonStyle(
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, MyRoutes.hNSRoute);
                  },
                )
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                margin: EdgeInsets.all(0),
                child: TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.sendPasswordResetEmail(email: FirebaseAuth.instance.currentUser!.email!);
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
                                Text("Password reset link sent successfully !"),
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
                  },
                  child: Text(
                    "Reset Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    )
                  ),
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}