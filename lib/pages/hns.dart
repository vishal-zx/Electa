// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpNSupport extends StatefulWidget {
  HelpNSupport({Key? key}) : super(key: key);

  @override
  _HelpNSupportState createState() => _HelpNSupportState();
}

class Socials {
  String linkedin;
  String insta;

  Socials(this.linkedin, this.insta);
}

class Member {
  String name;
  String image;
  String email;
  Socials sn;

  Member(this.name, this.image, this.email, this.sn);
}

Widget _buildTeamRow(BuildContext context, Member person) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.025,
            left: 0,
            right: 0,
            top: 0),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.77,
              height: MediaQuery.of(context).size.height * 0.123,
              margin: EdgeInsets.fromLTRB(17, 0, 0, 0),
              decoration: BoxDecoration(
                color: Color(0xFF333366),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15.0,
                    offset: Offset(0.0, 15.0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height * 0.11, 10, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          person.name,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          person.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.005),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.linkedin,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          onPressed: () async {
                            var url = person.sn.linkedin;
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.instagram,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          onPressed: () async {
                            var url = person.sn.insta;
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.124,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height * 0.1,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: person.image,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                    value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/u1.png")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _HelpNSupportState extends State<HelpNSupport> {
  List<Member> mem = [
    Member(
        "Manya Sharma",
        "https://firebasestorage.googleapis.com/v0/b/electa-e343d.appspot.com/o/userImages%2F19ucc066.png?alt=media&token=89ac7e00-02c9-4152-b205-1e2c7d216ba4",
        "19ucc066@lnmiit.ac.in",
        Socials("https://www.linkedin.com/in/manya-sharma-b449671b8/",
            "https://www.instagram.com/_manya.sharma/")),
    Member(
        "Poojan Gadhiya",
        "https://firebasestorage.googleapis.com/v0/b/electa-e343d.appspot.com/o/userImages%2F19ucs245.png?alt=media&token=12f17277-c8f3-4011-a92a-44ed968dec7d",
        "19ucs245@lnmiit.ac.in",
        Socials("https://www.linkedin.com/in/poojan-gadhiya/",
            "https://www.instagram.com/enjoying___alwayss/")),
    Member(
        "Saumitra Vyas",
        "https://firebasestorage.googleapis.com/v0/b/electa-e343d.appspot.com/o/userImages%2F19ucs252.png?alt=media&token=f2a8a26f-6bf4-45dc-866f-f219c7042967",
        "19ucs252@lnmiit.ac.in",
        Socials("https://www.linkedin.com/in/saumitra-vyas-631b701a6/",
            "https://www.instagram.com/saumitra_vyas/")),
    Member(
        "Vishal Gupta",
        "https://vishal-zx.github.io/assets/img/profile.jpg",
        "19ucs053@lnmiit.ac.in",
        Socials("https://www.linkedin.com/in/vishal-zx/",
            "https://www.instagram.com/vishalagrawal__/")),
  ];

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
                    height: MediaQuery.of(context).size.height * 0.16,
                    margin: EdgeInsets.fromLTRB(20, 24, 20, 5),
                    padding: EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0), width: 2),
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(30, 12, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.mail,
                                    size: 24,
                                  ),
                                  TextButton(
                                    child: Text(
                                      " :  info.electa.lnm@gmail.com",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      var url = "mailto:info.electa.lnm@gmail.com";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    CupertinoIcons.globe,
                                    size: 24,
                                  ),
                                  TextButton(
                                    child: Text(
                                      " :  www.electa-xyz.com",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      var url = "mailto:info.electa.lnm@gmail.com";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width * 0.1,
                      top: 14,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                        color: Colors.blueGrey[100],
                        child: Text(
                          'Contact Us',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      )),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.645,
                    margin: EdgeInsets.fromLTRB(20, 24, 20, 20),
                    // padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0), width: 2),
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 30, 5, 0),
                          child: Column(
                            children: [
                              for (var i = 0; i < mem.length; i++)
                                _buildTeamRow(context, mem[i]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      left: MediaQuery.of(context).size.width * 0.1,
                      top: 14,
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                        color: Colors.blueGrey[100],
                        child: Text(
                          'Our Team',
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
