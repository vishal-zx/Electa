import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


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


// ignore: must_be_immutable
class  UserProfile extends StatelessWidget {
  final String roll;
  UserProfile({ Key? key, required this.roll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    
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
          String userName = data['Name'];
          String userEmail = roll+"@lnmiit.ac.in";
          final userBio = data['Bio'];
          String userImageUrl = data['imageUrl'];

          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              title: Text("Electa"),
              elevation: 10,
            ),
            body: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.375, right: 100),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/mypbg.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height*0.48,
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Column(
                    children: [
                      Text("")
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.54,
                        margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.18,MediaQuery.of(context).size.height*0.031,0,0),
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
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
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
                              padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.065, 0, MediaQuery.of(context).size.height*0.035),
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.height*0.18,
                                    height: MediaQuery.of(context).size.height*0.18,
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
                                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.025),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height*(((userName.length)/16).ceil()*0.050),
                                        width: MediaQuery.of(context).size.height*0.275,
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Text(
                                            "$userName",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height*0.015,
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
                              padding: EdgeInsets.fromLTRB(15, 5, 15, 0),
                              child: Text(
                                "$userBio",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  // fontStyle: FontStyle.italic,
                                  height: 1.4 
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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