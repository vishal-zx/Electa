import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
bool isCandidate = false;

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

Widget electaDrawer(BuildContext context, String userName, String userEmail, String userImageUrl, String page){
  var roll = userEmail.substring(0,8).toUpperCase();
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
                          errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/u1.png")),
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
              leading: Icon(CupertinoIcons.today, color: (page == '/home' || page == '/candidateHome')?Colors.blue:Colors.white,),
              title: Text("Feed", 
              textScaleFactor: 1.3,
              style: TextStyle(
                color: (page == '/home' || page == '/candidateHome')?Colors.blue:Colors.white,
              ),),
              onTap: (){
                Navigator.pop(context);
                if(isCandidate == true) doRoute(context, MyRoutes.candHomeRoute);
                else doRoute(context, MyRoutes.homeRoute);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.chart_bar, color: (page == '/vote')?Colors.blue:Colors.white,),
              title: Text("Vote", 
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: (page == '/vote')?Colors.blue:Colors.white,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                doRoute(context, MyRoutes.voteRoute);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.star_circle, color: (page == '/result')?Colors.blue:Colors.white,),
              title: Text("Results", 
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: (page == '/result')?Colors.blue:Colors.white,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                doRoute(context, MyRoutes.resultRoute);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.profile_circled, color: (page == '/MyAccount')?Colors.blue:Colors.white,),
              title: Text("My Account", 
                textScaleFactor: 1.3,
                style: TextStyle(
                  color: (page == '/MyAccount')?Colors.blue:Colors.white,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                doRoute(context, MyRoutes.myAccountRoute);
              },
            ),
            if(roll == '19UCS053' || roll == '19UCC066' || roll == '19UCS252' || roll == '19UCS245')
              ListTile(
                leading: Icon(Icons.admin_panel_settings_outlined, color: (page == '/adminPage')?Colors.blue:Colors.white,),
                title: Text("Admin Page", 
                  textScaleFactor: 1.3,
                  style: TextStyle(
                    color: (page == '/adminPage')?Colors.blue:Colors.white,
                  ),
                ),
                onTap: (){
                  Navigator.pop(context);
                  doRoute(context, MyRoutes.adminPageRoute);
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

class MyDrawer extends StatefulWidget {
  MyDrawer({ Key? key }) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  
  static String userName = "";
  static String userEmail = "";
  static String userImageUrl = "";
  static String page = "";

  final roll = FirebaseAuth.instance.currentUser!.email!.substring(0,8);

  Future<void> checkCandidate(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('candidates').where('Roll', isEqualTo: email.substring(0,8).toUpperCase()).get();
    var cans = querySnapshot.docs;
    if(cans.length != 0) {
      isCandidate = true;
    }
  }

  @override
  void initState() {
    checkCandidate(roll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(roll.toUpperCase()).get(GetOptions(source: Source.serverAndCache)),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
        if (snapshot.hasError) {
          return errorProfile("Something went wrong!");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return errorProfile("User does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          userName = data['Name'];
          userEmail = roll+'@lnmiit.ac.in';
          userImageUrl = data['imageUrl'];
          page = ModalRoute.of(context)!.settings.name!;
          return electaDrawer(context, userName, userEmail, userImageUrl, page);
        }
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          child: SpinKitCircle(
            color: Colors.grey,
            size: 55.0,
          ),
        );
      }
    );
  }
}