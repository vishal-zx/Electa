import 'package:electa/utils/routes.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/material.dart';

class  MyAccount extends StatelessWidget {
  const MyAccount({ Key? key }) : super(key: key);

  final userName = "Vishal Gupta";
  final userEmail = "19ucs053@lnmiit.ac.in";
  final userBio = "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestae quas vel sint ok."; //max 100 limit on bio
  final assetImage = "assets/images/u1.png";
  final userImageUrl = "https://vishal-zx.github.io/assets/img/profile.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text("Electa"),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.05,
                ),
                Container(
                  width: MediaQuery.of(context).size.height*0.2,
                  height: MediaQuery.of(context).size.height*0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: FadeInImage.assetNetwork(
                      placeholder: assetImage,
                      image: userImageUrl,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration(milliseconds: 1),
                      fadeOutDuration: Duration(milliseconds: 1),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.018,
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.045,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "$userName",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.022,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      "$userEmail",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.018,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Text(
                    "$userBio",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.018,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: (){}, 
                      child: Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: (){}, 
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap:(){ Navigator.pushNamed(context, MyRoutes.registerRoute);},
                        child: Container(
                          width: 170,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "Help & Support",
                            style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap:(){ Navigator.pushNamed(context, MyRoutes.registerRoute);},
                        child: Container(
                          width: 90,
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                              fontSize: 15
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}