import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


Widget errorProfile(BuildContext context, String error){
  var mQ = MediaQuery.of(context).size;
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: mQ.height*0.4,
            width: mQ.height*0.54,
            margin: EdgeInsets.symmetric(horizontal: mQ.width*0.08, vertical: mQ.height*0.05),
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
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: <BoxShadow>[
                BoxShadow(  
                  color: Colors.black26,
                  blurRadius: 15.0,
                  offset: Offset(0.0, 15.0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    error,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    )
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    ),
  );
}

Widget userPro(BuildContext context, String roll) {
  var mQ = MediaQuery.of(context).size;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(roll).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.hasError) {
          return errorProfile(context, "Something went wrong !");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return errorProfile(context, "User does not exist !");
        }

        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          String userName = data['Name'];
          String userEmail = roll+"@lnmiit.ac.in";
          final userBio = data['Bio'];
          String userImageUrl = data['imageUrl'];

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: mQ.height*0.345,
                      width: mQ.height*0.54,
                      margin: EdgeInsets.symmetric(horizontal: mQ.width*0.08, vertical: mQ.height*0.05),
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
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(  
                            color: Colors.black26,
                            blurRadius: 15.0,
                            offset: Offset(0.0, 15.0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(mQ.width*0.04, mQ.height*0.03, mQ.width*0.04, mQ.height*0.01),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: mQ.height*0.15,
                                  height: mQ.height*0.15,
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
                                  width: mQ.width*0.01,
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: mQ.width*0.45,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          "$userName",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: mQ.height*0.01,
                                    ),
                                    Container(
                                      child: Text(
                                        "$userEmail",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: Text(
                              "$userBio",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
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
          );
      }
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          child: SpinKitCircle(
            color: Colors.black,
            size: 50.0,
            duration: Duration(seconds: 5), 
          ),
        ),
      );
    }
  );
}