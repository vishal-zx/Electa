import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:core';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime selectedDate = DateTime.now();

  bool loading = false;
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

  int otpFlag = -1;
  int userOTP = 0;
  int sentOTP = 0;
  bool _checkRoll = true;
  bool _checkPass = true;

  check(BuildContext context) async{
    if(formKey.currentState!.validate()){
      setState(() {
        _checkRoll = true;
        _checkPass = true;
      });
    }
    else{
      setState(() {
        _checkRoll = false;
        _checkPass = false;
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
  List<dynamic> isVoted = List.filled(8, false);
  String _validRoll = "false";

  bool _showPass = true;
  bool _rollPresent = false;
  bool emailVerified = false;
  
  final formKey = GlobalKey<FormState>();

  bool isInitialized = false;
  bool? value = false;
  bool? value2 = false;

  void _togglePass(){
    setState(() {
      _showPass = !_showPass;
    });
  }

  SnackBar makeBar(String text){
    final snackBar = SnackBar(
      duration: Duration(milliseconds: (text=="Loading...")?700:3500),
      content: Text('$text', textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 14),
      ),
      backgroundColor: Colors.black87.withOpacity(1),
      elevation: 3,
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    );
    return snackBar;
  }

  SnackBar error = SnackBar(content: Text(""));

  File pickedImage = new File("");
  bool isUploading = false;

  _loadPicker() async{
    if(_rollPresent == true){  
      await Permission.photos.request();
      var permissionStatus = await Permission.photos.status;
      if (permissionStatus.isGranted){
        XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
        if(picked!=null){
          _cropImage(picked);
        }else {
          error = makeBar('No Image Selected');
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

  _cropImage(XFile picked) async{
    File? cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.black,
        toolbarColor: Colors.black,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
          CropAspectRatioPreset.square
        ],
        maxWidth: 800,
    );
    if(cropped !=null){
      setState(() {
        pickedImage = cropped;
      });
    }
  }

  Future<void> upload(File pickedImg) async{
    if(pickedImg.path!=""){
      final _firebaseStorage = FirebaseStorage.instance;
      isUploading = true;
      UploadTask uploadTask = _firebaseStorage.ref().child('userImages/$roll.png').putFile(pickedImg);
      var downloadUrl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
        isUploading = false;
      });
    }
    else{
      error = makeBar('First select an image!');
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  bool registerd = false;
  Future<void> doRegister(String email, String password) async {
    if(_checkRoll == true){
      try{
        QuerySnapshot qs = await FirebaseFirestore.instance.collection('users').where('Roll',isEqualTo: email.substring(0,8).toUpperCase()).get();
        var cans = qs.docs;
        var fl = 0;
        for(var can in cans){
          Map<String, dynamic> data = can.data() as Map<String, dynamic>;
          if(email.substring(0,8).toUpperCase() == data['Roll'])
          {
            error = makeBar('The account already exists for that roll number.');
            fl=1;
            setState((){
              loading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(error);
          }
        }
        if(fl==0){
          try{
            await upload(pickedImage).then((val)async{
              FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value)async{
                await FirebaseFirestore.instance.collection('users').doc(roll.toUpperCase()).
                set({'Name' : name, 'Roll' : roll.toUpperCase(), 'Bio' : bio, 'imageUrl' : imageUrl, 'isVoted' : isVoted}).then((value){
                  setState((){
                    registerd = true;
                  });
                });
              });
            });
          }on FirebaseAuthException catch(e)
          {
            if (e.code == 'weak-password') {
              error = makeBar('The password provided is too weak.');
              ScaffoldMessenger.of(context).showSnackBar(error);
            } else if (e.code == 'email-already-in-use') {
              setState((){
                loading = false;
              });
              error = makeBar('The account already exists for that roll number.');
              ScaffoldMessenger.of(context).showSnackBar(error);
            }
          }
        }
      } on FirebaseAuthException catch(e)
      {
        error = makeBar('Something went wrong. Please try after some time.\nError Code : ${e.code}');
        ScaffoldMessenger.of(context).showSnackBar(error);
      }
    }
  }

  Widget finalPopup(String role){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.blueGrey[100],
        title: Container(
          height: MediaQuery.of(context).size.height*0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, size:50),
              SizedBox(height: 10),
              Text("You are successfully registerd as a $role.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19
              )),
            ]
          ),
        ),
        actions:<Widget>[
          new TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Timer(Duration(seconds: 1), (){
                Navigator.pushNamedAndRemoveUntil(context, MyRoutes.loginRoute, (route) => false);
              });
            },
            child: const Text('Login',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ),
        ]
      ),
    );
  }

  Widget prefBox(){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference cans = firestore.collection('candidates');

    return FutureBuilder<DocumentSnapshot>(
      future: cans.doc(roll.toUpperCase()).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.hasError) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: new AlertDialog(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.blueGrey[100],
              content: Container(
                height: MediaQuery.of(context).size.height*0.10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Something went wrong. Please try again.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19
                    )),
                  ]
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return finalPopup("Voter");
        }
        
        if (snapshot.connectionState == ConnectionState.done){
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: new AlertDialog(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.blueGrey[100],
              title: Text("Select the role you want to continue as:", textAlign: TextAlign.center,),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context){
                            return finalPopup("Candidate");
                          }
                        );
                      },
                      child: const Text('Candidate',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.black,
                    ),
                    TextButton(
                      onPressed: () {
                        CollectionReference u = FirebaseFirestore.instance.collection('candidates');
                        u.doc(roll.toUpperCase()).delete().then((value){                          
                          Navigator.of(context).pop();
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context){
                              return finalPopup("Voter");
                            }
                          );
                        });
                      },
                      child: const Text('Voter',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21,
                        ),
                      ),
                    ),
                  ]
                ),
              ]
            ),
          );
        }

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: new AlertDialog(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.blueGrey[100],
            content: Container(
              height: MediaQuery.of(context).size.height*0.10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCircle(
                    color: Colors.black,
                    size: 50.0,
                    duration: Duration(seconds: 5), 
                  ),
                ]
              ),
            ),
          ),
        );
      }
    );
    
  }

  final auth = FirebaseAuth.instance;
  late User us;
  late Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified()async{
    User us = FirebaseAuth.instance.currentUser!;
    print(us);
    await us.reload();
    if(us.emailVerified){
      timer.cancel();
      Navigator.of(context).pop();
      showDialog(
        barrierDismissible: false,
        context: context, 
        builder: (BuildContext context){
          return prefBox();
        }
      );
    }
  }

  Widget verifyEmailPopup(User u){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: new AlertDialog(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.blueGrey[100],
        content: Container(
          height: MediaQuery.of(context).size.height*0.15,
          child: Column(
            children: [
              Text("An Email has been sent to ${u.email}. \nPlease first verify email to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17
              )),
              SizedBox(height:15),
              SpinKitCircle(
                color: Colors.black,
                size: 40.0,
                duration: Duration(seconds: 5), 
              ),
            ]
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
          elevation: 5,
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
                        setState((){
                          if(_validRoll == "false"){
                            _checkRoll = false;
                          }
                          else{
                            _checkRoll = true;
                          }
                        });
                        return null;
                      },
                      onChanged: (value){
                        roll = value.replaceAll(' ', '');
                        email = roll.toLowerCase() + "@lnmiit.ac.in";
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
                        if(value == "") password = "";
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 0, 25, 0),
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
                    height: MediaQuery.of(context).size.height*0.13,
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
                        maxLines: 3,
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
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15, bottom: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.portrait_outlined
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      "User Image",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "       *This can't be edited later.",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic, 
                                        color: Colors.red[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 15),
                                    width: MediaQuery.of(context).size.width*0.5,
                                    height: MediaQuery.of(context).size.height*0.15,
                                    margin: EdgeInsets.only(left:30),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: (pickedImage.path!="")?Image.file(pickedImage):
                                    Image.asset('assets/images/imgbg.png', fit: BoxFit.contain,)
                                  ),
                                  Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: (){
                                          _loadPicker();
                                        }, 
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(2, 12, 2, 12),
                                          child: Text("Select Image",
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
                                    ],
                                  ), 
                                ],
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      child: InkWell(
                        onTap: () async {
                          if(loading == false){
                            setState((){
                              loading = true;
                            });
                            check(context);
                            if(roll!="" && name!=""){
                              if(_validRoll == "true"){
                                if(_checkPass == true){
                                  if(bio != "")
                                  {
                                    await doRegister(email, password).then((val)async{
                                      Future.delayed(const Duration(milliseconds: 3000), () async {
                                        if(registerd == true)
                                        {
                                          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) async {
                                            User? user = FirebaseAuth.instance.currentUser;
                                            if(user!=null && !user.emailVerified)
                                            {
                                              await user.sendEmailVerification();
                                              ScaffoldMessenger.of(context).showSnackBar(makeBar("Registered Successfully!! 🎉"));
                                              setState((){
                                                loading = false;
                                              });
                                              Timer(Duration(milliseconds: 1200), (){
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: context, 
                                                  builder: (BuildContext context){
                                                    timer = Timer.periodic(Duration(seconds: 4), (timer) {
                                                      checkEmailVerified();
                                                    });
                                                    return verifyEmailPopup(user);
                                                  }
                                                );
                                              });
                                            }
                                          });
                                        }
                                        else{
                                          setState((){
                                            loading = false;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(makeBar("Something went wrong. Please try again later!"));
                                        }
                                      });
                                    }); 
                                  }
                                  else{
                                    setState((){
                                      loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(makeBar("Add something to your bio ! "));
                                  }
                                }
                                else{
                                  setState((){
                                    loading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(makeBar("Please enter a valid password !"));
                                }
                              }
                              else{
                                setState((){
                                  loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(makeBar("Invalid Roll Number !!\nEnter in right format ! (e.g, 19UCS053)"));
                              }
                            }
                            else{
                              setState((){
                                loading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(makeBar("Name/Roll number missing !!"));
                            }
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: 170,
                          height: 50,
                          color: (loading == true)?Colors.grey:Colors.black,
                          alignment: Alignment.center,
                          child: Text(
                            "Verify & Register",
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
