import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class  EditProfile extends StatefulWidget {
  EditProfile({ Key? key }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

Widget _discardPopup(BuildContext context) { 
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    child: AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.blueGrey[100],
      title: const Text('Discard the changes?',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height*0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black
                ),
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            Container(
              width: 1,
              height: 45,
              color: Colors.black,
            ),
            TextButton(
              child: Text(
                "Discard",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    )
  );
}

Widget errorProfile(String error){
  return Scaffold(
    backgroundColor: Colors.blueGrey[100],
    appBar: AppBar(
      title: Text("Electa"),
      elevation: 10,
    ),
    body: Container(
      alignment: Alignment.center,
      child: Text(
        "$error",
        style: TextStyle(
          fontSize: 20,
          color: Colors.black,
        ),
      ),
    ),
  );
}


class _EditProfileState extends State<EditProfile> {

  var userName = "";
  var userBio = ""; //max 100 limit on bio
  var userImageUrl = "";
  String newUserName = "";
  String newUserBio = "";
  final formKey = GlobalKey<FormState>();
  
  var roll = FirebaseAuth.instance.currentUser!.email!.substring(0,8);

  @override
  Widget build(BuildContext context) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(roll).get(GetOptions(source: Source.cache)),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){

        if (snapshot.hasError) {
          return errorProfile("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return errorProfile("User does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          userName = data['Name'];
          userBio = data['Bio'];
          userImageUrl = data['imageUrl'];
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: Colors.blueGrey[100],
              appBar: AppBar(
                title: Text("Electa"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if(newUserName == "" && newUserBio == "")
                      Navigator.of(context).pop();
                    else{
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) => _discardPopup(context),
                      );
                    }
                  },
                ),
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
                            height: MediaQuery.of(context).size.height*0.65,
                            margin: EdgeInsets.fromLTRB(20, 24, 20, 10),
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color.fromARGB(255, 0, 0, 0), width: 2),
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(top: 45, bottom: 10),
                                          width: MediaQuery.of(context).size.height*0.165,
                                          height: MediaQuery.of(context).size.height*0.165,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(100),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: userImageUrl,
                                              progressIndicatorBuilder: (context, url, downloadProgress) => 
                                                      CircularProgressIndicator(value: downloadProgress.progress),
                                              errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/u1.png")),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Form(
                                  onWillPop: () async {
                                    if(newUserName == "" && newUserBio == "")
                                      Navigator.of(context).pop();
                                    else{
                                      showDialog(
                                        context: context, 
                                        builder: (BuildContext context) => _discardPopup(context),
                                      );
                                    }
                                    return Future.value(true);
                                  },
                                  key: formKey,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 32.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Enter Your Name",
                                            labelText: "Full Name"
                                          ),
                                          initialValue: userName,
                                          validator: (value){
                                            if(value!.isEmpty){
                                              return "Name can't be Empty!";
                                            }
                                          },
                                          onChanged: (value){
                                            newUserName = value;
                                            if(value == "") newUserName = "";
                                          },
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context).size.height*0.02,
                                        ),
                                        Container(
                                          height: MediaQuery.of(context).size.height*0.15,
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                              hintText: "Enter Your Bio",
                                              labelText: "About You"
                                            ),
                                            initialValue: userBio,
                                            keyboardType: TextInputType. multiline,
                                            maxLines: null,
                                            maxLength: 100,
                                            onChanged: (value)
                                            {
                                              newUserBio = value;
                                              if(value == "") newUserBio = "";
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height*0.01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(15),
                                      child: InkWell(
                                        onTap: () {
                                          newUserName = (newUserName=="")?userName:newUserName;
                                          newUserBio = (newUserBio=="")?userBio:newUserBio;
                                          users.doc(roll).update({'Name' : newUserName, 'Bio' : newUserBio});
                                          userBio = newUserBio;
                                          userName = newUserName;
                                          newUserBio = "";
                                          newUserName = "";
                                          // Future.delayed(const Duration(milliseconds: 2000), () {
                                          //   setState(() {

                                          //   });
                                          // });
                                          SpinKitCircle(
                                            color: Colors.black,
                                            size: 50.0,
                                            duration: Duration(seconds: 50), 
                                          );
                                          Navigator.of(context).pop();
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(seconds: 1),
                                          width: 150,
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Update Profile",
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
                              ],
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width*0.1,
                            top: 12,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                              color: Colors.blueGrey[100],
                              child: Text(
                                'Edit Profile',
                                style: TextStyle(color: Colors.black, fontSize: 22),
                              ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.blueGrey[100],
          appBar: AppBar(
            title: Text("Electa"),
            elevation: 10,
          ),
          body: SpinKitCircle(
            color: Colors.black,
            size: 50.0,
            duration: Duration(seconds: 5), 
          ),
        );
      }
    );
  }
}