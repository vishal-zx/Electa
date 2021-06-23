import 'package:electa/utils/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userImageUrl = "https://vishal-zx.github.io/assets/img/profile.jpg";

    return Drawer(
      child: Container(
        color: Colors.blueGrey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 30,
            ),
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.all(0),
                accountName: Text("Vishal Gupta"),
                accountEmail: Text("19ucs053@lnmiit.ac.in"),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(userImageUrl),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ListTile(
              leading: Icon(CupertinoIcons.today, color: Colors.white,),
              title: Text("Feed", 
              textScaleFactor: 1.3,
              style: TextStyle(
                color: Colors.white,
              ),),
              onTap: (){
                Navigator.pushNamed(context, MyRoutes.homeRoute);
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
                Navigator.pushNamed(context, MyRoutes.voteRoute);
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.star_circle, color: Colors.white,),
              title: Text("Results", 
              textScaleFactor: 1.3,
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
            ListTile(
              leading: Icon(CupertinoIcons.profile_circled, color: Colors.white,),
              title: Text("Profile", 
              textScaleFactor: 1.3,
              style: TextStyle(
                color: Colors.white,
              ),),
            ),
            
          ],
        ),
      ),
    );
  }
}