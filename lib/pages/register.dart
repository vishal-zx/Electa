import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:image_picker/image_picker.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';
import 'package:permission_handler/permission_handler.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  String _textValue = "sample";
  DateTime selectedDate = DateTime.now();

  
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1995),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  // ignore: unused_field
  bool _checkRollPass = true;

  check(BuildContext context) async{
    if(formKey.currentState!.validate()){
      setState(() {
        _checkRollPass = true;
      });
    }
    else{
      setState(() {
        _checkRollPass = false;
      });
    }
  }

  String toDate(DateTime selectedDate){
    return selectedDate.day.toString() + "/" + selectedDate.month.toString() + "/" + selectedDate.year.toString();
  }

  RegExp regExp = new RegExp(r"^\d{2}[a-z]{3}\d{3}$",
    caseSensitive: false,
  );

  String roll="";
  String bio="";
  String name="";
  String email="";
  String password="";
  String imageUrl="";
  String _validRoll = "false";

  bool _showPass = true;
  bool _rollPresent = false;
  
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

SnackBar makeBar(String text){
  final snackBar = SnackBar(
    duration: Duration(milliseconds: (text=="Loading...")?700:3000),
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

SnackBar error = SnackBar(content: Text(""));
  
XFile? userImage;
var file;

void pickImage() async {
    if(_rollPresent == true){
      final _imagePicker = ImagePicker();
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted){
        userImage = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (userImage != null){
          file = File(userImage!.path);
        }else {
          error = makeBar('No Image Received');
          ScaffoldMessenger.of(context).showSnackBar(error);
        }
      }else {
        error = makeBar('Permission not granted. Try Again with permission access');
        ScaffoldMessenger.of(context).showSnackBar(error);
      }
    }else{
      error = makeBar("Please enter Roll Number first!");
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  void uploadToFB(var file) async{
    if(file!=null){
      final _firebaseStorage = FirebaseStorage.instance;
      var snapshot = await _firebaseStorage.ref().child('userImages/$roll.png').putFile(file).whenComplete(() => null);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    }
    else{
      error = makeBar('First select an image!');
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  
  void doRegister() async {
    if(_checkRollPass == true){
      print(roll);
      print(email);
      print(name);
      print(bio);
      print(password);
      users.doc(roll).set({'Name' : name, 'Roll' : roll, 'Bio' : bio, 'imageUrl' : imageUrl});
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      } 
      on FirebaseAuthException catch(e){
        if (e.code == 'weak-password') {
          error = makeBar('The password provided is too weak.');
          ScaffoldMessenger.of(context).showSnackBar(error);
        } else if (e.code == 'email-already-in-use') {
          error = makeBar('The account already exists for that roll number.');
          ScaffoldMessenger.of(context).showSnackBar(error);
        }
      } 
      catch (e){
        error = makeBar('Something went wrong! Please try again.');
        ScaffoldMessenger.of(context).showSnackBar(error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus(); 
        check(context);
      },
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
                        if(value == "") {roll = ""; _rollPresent = false;}
                        else if(value !="") _rollPresent = true;
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
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 2),
                    child: TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person_outline_sharp,
                          color: Colors.black,
                        ),
                        labelText: "Your Name",
                        hintText: "Enter Your Name",
                      ),
                      onChanged: (value){
                        name = value;
                        setState(() {
                          
                        });
                        if(value == "") name = "";
                      },
                      validator: (value){
                        if(value!.isEmpty){return "Name can't be Empty!";}
                        else  return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 2),
                    child: TextFormField(  
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
                      validator: (value){
                        if(value!.isEmpty){return "Password can't be Empty!";}
                        else if(value.length < 6){return "Password lenght should be greater than 6!";}
                        else  return null;
                      },
                      onChanged: (value){
                        password = value;
                        setState(() {
                          
                        });
                        if(value == "") password = "";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 8),
                    child: TextField( 
                      readOnly: true,
                      controller: TextEditingController()..text = toDate(selectedDate),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.cake_outlined,
                          color: Colors.black,
                        ),
                        labelText: "Date of Birth",
                        hintText: toDate(selectedDate),
                        suffix: InkWell(
                          onTap: () => _selectDate(context),
                          child: Icon(Icons.date_range_outlined)
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*0.15,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 25, 0),
                      child: TextField(
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.black,
                          ),
                          labelText: "Your Bio",
                          hintText: "Write Something About Yourself",
                        ),
                        keyboardType: TextInputType. multiline,
                        maxLines: null,
                        maxLength: 100,
                        onChanged: (value){
                        bio = value;
                        setState(() {
                          
                        });
                        if(value == "") password = "";
                      },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.portrait_outlined
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "User Image",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width*0.4,
                                height: MediaQuery.of(context).size.height*0.15,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: (imageUrl != "")?Image.network(imageUrl):
                                Image.network('https://i.imgur.com/sUFH1Aq.png', fit: BoxFit.contain,)
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: (){
                                      pickImage();
                                    }, 
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(2, 12, 2, 12),
                                      child: Text("1.   Select Image",
                                        style: TextStyle(
                                          fontSize: 12
                                        ),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          side: BorderSide(color: Colors.black87)
                                        )
                                      )
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){
                                      uploadToFB(file);
                                    }, 
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(2, 12, 2, 12),
                                      child: Text("2.   Upload Image",
                                        style: TextStyle(
                                          fontSize: 12
                                        ),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          side: BorderSide(color: Colors.black)
                                        )
                                      )
                                    ),
                                  ),
                                ],
                              ), 
                            ],
                          ),
                        ],
                      )
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
                        onTap: () async {
                          if(roll!="" && name!=""){
                            doRegister();
                            await FirebaseAuth.instance.signOut();
                            ScaffoldMessenger.of(context).showSnackBar(makeBar("Registered Successfully!! 🎉"));
                            Timer(Duration(seconds: 2), (){
                              Navigator.pushNamedAndRemoveUntil(context, MyRoutes.loginRoute, (route) => false);
                            });
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(makeBar("Name or Roll Number Missing !!"));
                          }
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
