import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  String _textValue = "sample";
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1995),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  RegExp regExp = new RegExp(r"^\d{2}[a-z]{3}\d{3}$",
    caseSensitive: false,
  );

  String roll="";
  String name="";
  String email="";
  String password="";
  String _validRoll = "false";

  bool _showPass = true;
  
  final formKey = GlobalKey<FormState>();

  bool isInitialized = false;
  bool? value = false;
  bool? value2 = false;

  Widget buildcheckbox() => Checkbox(
      value: value,
      onChanged: (value) {
        setState(() {
          this.value = value;
        });
      });

  Widget buildcheckbox2() => Checkbox(
      value: value2,
      onChanged: (value2) {
        setState(() {
          this.value2 = value2;
        });
      });

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _cameraOcr,
        waitTap: true,
      );

      setState(() {
        _textValue = texts[0].value;
        texts.add(new OcrText('Failed to recognize text.'));
      });
    } on Exception {
      texts.add(new OcrText('Failed to recognise text.'));
    }
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Register",
            textDirection: TextDirection.ltr,
          ),
          elevation: 0,
          leading: IconButton(
              onPressed: () => {
                    Navigator.pop(context),
                  },
              icon: Icon(Icons.arrow_back_rounded)),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/images/sign up.png",
                    fit: BoxFit.fitHeight,
                    // height: 400,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 8),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.assignment_ind_outlined,
                          color: Colors.black,
                        ),
                        labelText: "Roll Number",
                        hintText: "Enter Your Roll Number",
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
                        roll = value.replaceAll(' ', '');
                        email = roll + "@lnmiit.ac.in";
                        setState(() {
                          
                        });
                        if(value == "") roll = "";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 8),
                    child: TextField(
                      // enabled: false,
                      readOnly: true,
                      controller: TextEditingController()..text = (roll == "")?"":'$email',
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                        ),
                        labelText: "Your Email",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 8),
                    child: TextField(
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person_outline_sharp,
                          color: Colors.black,
                        ),
                        labelText: "Your Name",
                        hintText: "Enter Your Name",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 8),
                    child: TextField(  
                      obscureText: _showPass,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.black,
                        ),
                        labelText: "New Password",
                        hintText: "Enter New Password",
                        suffix: InkWell(
                          onTap: _togglePass,
                          child: Icon(this._showPass?Icons.visibility:Icons.visibility_off),
                        )
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.005,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 18.0),
                        child: Text("DOB : ",
                            textDirection: TextDirection.ltr,
                            style:
                                TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Text(
                              selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16
                              ),
                            ),
                          ],
                        ), 
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12.0, left: 10.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Icon(Icons.date_range_outlined)
                          )
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 5, 8, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _read,
                          child: Text(
                            'Scan Your College Id Card',
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                        new Text(_textValue),
                        buildcheckbox(),
                      ]
                    ),
                  ),
                
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 5, 8, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: _read,
                          child: Text(
                            'Face Authentication',
                            style: TextStyle(
                              color: Colors.black, 
                              fontWeight: FontWeight.bold
                            ),
                          )
                        ),
                        buildcheckbox2(),
                      ]
                    ),
                  ),
                
                  Center(
                      child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('You Want To Register Yourself As:',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                  )),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // ignore: deprecated_member_use
                          RaisedButton(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.black, width: 2.0)),
                            color: Colors.blue[200],
                            onPressed: () {},
                            child: Text(
                              'VOTER',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.black, width: 2.0)),
                            color: Colors.pink[100],
                            onPressed: () {},
                            child: Text('CANDIDATE',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ),
                        ]
                      ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () {
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: 130,
                          height: 50,
                          alignment: Alignment.center,
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
