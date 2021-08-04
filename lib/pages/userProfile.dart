import 'dart:ui';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class  UserProfile extends StatelessWidget {
  UserProfile({ Key? key }) : super(key: key);

  String userName = "Poojan Gadhiya";
  String userEmail = "some.email@example.com";
  final userBio = "Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here!.";
  String userImageUrl = "https://firebasestorage.googleapis.com/v0/b/electa-e343d.appspot.com/o/userImages%2F19ucs245.png?alt=media&token=12f17277-c8f3-4011-a92a-44ed968dec7d";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text("Electa"),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.365, right: 100),
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
                    height: MediaQuery.of(context).size.height*0.32,
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width*0.12,MediaQuery.of(context).size.height*0.031,0,0),
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
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*(((userName.length)/16).ceil()*0.038),
                                    width: MediaQuery.of(context).size.height*0.275,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
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
                              fontStyle: FontStyle.italic,
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
      ),
    );
  }
}