import 'package:flutter/material.dart';

class  EditProfile extends StatefulWidget {
  EditProfile({ Key? key }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  var userName = "Vishal Gupta";
  var userBio = "Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here! Bio Here!."; //max 100 limit on bio
  var assetImage = "assets/images/u1.png";
  var userImageUrl = "https://vishal-zx.github.io/assets/img/profile.jpg";

  @override
  Widget build(BuildContext context) {
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
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.62,
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
                            Container(
                              margin: EdgeInsets.only(top: 45),
                              width: MediaQuery.of(context).size.height*0.16,
                              height: MediaQuery.of(context).size.height*0.16,
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
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.005,
                        ),
                        Container(
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
                                ),
                              ),
                            ],
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
                                onTap: () => (){},
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
    );
  }
}