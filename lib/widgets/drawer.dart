import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void doRoute(BuildContext context, String nextRoute)
{
  if(ModalRoute.of(context)!.settings.name != nextRoute) 
    Navigator.pushNamed(context, nextRoute);
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

class MyDrawer extends StatelessWidget {
  MyDrawer({ Key? key }) : super(key: key);
  
  static String userName = "";
  static String userEmail = "";
  static String userImageUrl = "";

  final roll = FirebaseAuth.instance.currentUser!.email!.substring(0,8);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
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
          userEmail = roll+'@lnmiit.ac.in';
          userImageUrl = data['imageUrl'];

          return SafeArea(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Container(
                width: MediaQuery.of(context).size.width*0.58,
                // color: Color(0xFF6c446c),
                child: ListView(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.30,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.height*0.15,
                              height: MediaQuery.of(context).size.height*0.15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(70),
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
                              height: 10,
                            ),
                            Text(
                              userName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              userEmail,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.today, color: Colors.white,),
                      title: Text("Feed", 
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        color: Colors.white,
                      ),),
                      onTap: (){
                        Navigator.pop(context);
                        doRoute(context, MyRoutes.homeRoute);
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.chart_bar, color: Colors.white,),
                      title: Text("Vote", 
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                        doRoute(context, MyRoutes.voteRoute);
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.star_circle, color: Colors.white,),
                      title: Text("Results", 
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                        doRoute(context, MyRoutes.resultRoute);
                      },
                    ),
                    ListTile(
                      leading: Icon(CupertinoIcons.profile_circled, color: Colors.white,),
                      title: Text("My Account", 
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                        doRoute(context, MyRoutes.myAccountRoute);
                      },
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.2, 0.6, 0.8, 1],
                    colors: [Color(0xff2f4f4f), Color(0xff111d1d), Color(0xff0e1818), Color(0xff030505)]
                  )
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
          drawer: MyDrawer(),
        );
      }
    );
  }
}