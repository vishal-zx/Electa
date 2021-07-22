import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electa/utils/routes.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget _logoutPopup(BuildContext context) { 
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    child: AlertDialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.blueGrey[100],
      title: const Text('Are you sure you want to logout?',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height*0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              child: Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, MyRoutes.loginRoute, (route) => false);
              },
            ),
            // VerticalDivider(
            //   color: Colors.black,
            // ),
            Container(
              width: 1,
              height: 40,
              color: Colors.black,
            ),
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
              onPressed: () {
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
    drawer: MyDrawer(),
  );
}

// ignore: must_be_immutable
class  MyAccount extends StatelessWidget {
  MyAccount({ Key? key }) : super(key: key);

  static String userName = "";
  static String userRoll = "";
  static String userEmail = "";
  static String userBio = "";
  static String userImageUrl = "";

  var roll = FirebaseAuth.instance.currentUser!.email!.substring(0,8);

  @override
  Widget build(BuildContext context) {
    
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = firestore.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(roll).get(),
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
          userEmail = roll + "@lnmiit.ac.in";
          userBio = data['Bio'];
          userImageUrl = data['imageUrl'];

          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              title: Text("Electa"),
              elevation: 10,
            ),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.32,
                      margin: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height*0.031,MediaQuery.of(context).size.width*0.1,0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0xff546e7a),
                            Colors.blueGrey,
                            Color(0xff616161),
                            Color(0xff757575),
                          ],
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(  
                            color: Colors.black26,
                            blurRadius: 15.0,
                            offset: Offset(0.0, 15.0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.height*0.025, MediaQuery.of(context).size.height*0.035, 0, MediaQuery.of(context).size.height*0.035),
                            child: Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.height*0.14,
                                  height: MediaQuery.of(context).size.height*0.14,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl: userImageUrl,
                                      progressIndicatorBuilder: (context, url, downloadProgress) => 
                                              CircularProgressIndicator(value: downloadProgress.progress),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width*0.00,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height*(((userName.length)/16).ceil()*0.038),
                                      width: MediaQuery.of(context).size.height*0.28,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Text(
                                            "$userName",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.005,
                                    ),
                                    Container(
                                      height: MediaQuery.of(context).size.height*0.022,
                                      child: FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          "$userEmail",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: Text(
                              "$userBio",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height*0.035,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.04,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.07),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/mypbg.png"),
                          fit: BoxFit.contain,
                          alignment: Alignment(MediaQuery.of(context).size.width*(-0.003), 0),
                          
                        )
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height*0.075,
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.59,MediaQuery.of(context).size.height*0.035,0,0),
                            decoration: BoxDecoration(
                              color: Color(0xFF121212),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(  
                                  color: Colors.black26,
                                  blurRadius: 15.0,
                                  offset: Offset(0.0, 15.0),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.04,MediaQuery.of(context).size.height*0.002,MediaQuery.of(context).size.width*0.05,MediaQuery.of(context).size.height*0.002),
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.03,
                                      ),
                                      Text(
                                        "Edit Profile",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, MyRoutes.editProfileRoute);
                              },
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.075,
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.45,MediaQuery.of(context).size.height*0.035,0,0),
                            decoration: BoxDecoration(
                              color: Color(0xFF121212),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(  
                                  color: Colors.black26,
                                  blurRadius: 15.0,
                                  offset: Offset(0.0, 15.0),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.04,MediaQuery.of(context).size.height*0.002,MediaQuery.of(context).size.width*0.05,MediaQuery.of(context).size.height*0.002),
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.03,
                                      ),
                                      Text(
                                        "Change Password",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, MyRoutes.changePswdRoute);
                              },
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.075,
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.5,MediaQuery.of(context).size.height*0.035,0,0),
                            decoration: BoxDecoration(
                              color: Color(0xFF121212),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(  
                                  color: Colors.black26,
                                  blurRadius: 15.0,
                                  offset: Offset(0.0, 15.0),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.04,MediaQuery.of(context).size.height*0.002,MediaQuery.of(context).size.width*0.05,MediaQuery.of(context).size.height*0.002),
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.support,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.03,
                                      ),
                                      Text(
                                        "Help & Support",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, MyRoutes.hNSRoute);
                              },
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height*0.075,
                            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.66,MediaQuery.of(context).size.height*0.035,0,0),
                            decoration: BoxDecoration(
                              color: Color(0xFF121212),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                              boxShadow: <BoxShadow>[
                                BoxShadow(  
                                  color: Colors.black26,
                                  blurRadius: 15.0,
                                  offset: Offset(0.0, 15.0),
                                ),
                              ],
                            ),
                            child: GestureDetector(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.04,MediaQuery.of(context).size.height*0.002,MediaQuery.of(context).size.width*0.05,MediaQuery.of(context).size.height*0.002),
                                child: FittedBox(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.logout,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width*0.03,
                                      ),
                                      Text(
                                        "Logout",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 19
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) => _logoutPopup(context),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            drawer: MyDrawer(),
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
          drawer: MyDrawer(),
        );
      },
    );
  }
}