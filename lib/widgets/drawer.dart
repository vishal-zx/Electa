import 'dart:ui';

import 'package:electa/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void doRoute(BuildContext context, String nextRoute)
{
  if(ModalRoute.of(context)!.settings.name != nextRoute) 
    Navigator.pushNamed(context, nextRoute);
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userName = "Vishal Gupta";
    final userEmail = "19ucs053@lnmiit.ac.in";
    final userImageUrl = "https://vishal-zx.github.io/assets/img/profile.jpg";

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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(userImageUrl),
                            fit: BoxFit.fill
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
                  print(ModalRoute.of(context)!.settings.name);
                  Navigator.pop(context);
                  doRoute(context, MyRoutes.myAccountRoute);
                },
              ),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage( 
              image: AssetImage("assets/images/de.jpg"), 
              fit: BoxFit.cover,
            )
          ),
        ),
      ),
    );
  }
}