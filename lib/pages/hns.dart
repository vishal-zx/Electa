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
                        errorWidget: (context, url, error) => Icon(Icons.error),
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
        "https://imgshare.io/images/2021/06/30/manya.png",
        "19ucc066@lnmiit.ac.in",
        Socials("https://www.linkedin.com/in/manya-sharma-b449671b8/",
            "https://www.instagram.com/_manya.sharma/")),
    Member(
        "Poojan Gadhiya",
        "https://imgshare.io/images/2021/06/30/poojan.png",
        "19ucs245@lnmiit.ac.in",
        Socials("https://www.linkedin.com/in/poojan-gadhiya/",
            "https://www.instagram.com/enjoying___alwayss/")),
    Member(
        "Saumitra Vyas",
        "https://imgshare.io/images/2021/06/30/saumitra.png",
        "19ucs252@lnmiit.ac.in",
        Socials("https://www.linkedin.com/in/saumitra-vyas-631b701a6/",
            "https://www.instagram.com/saumitra_vyas/")),
    Member(
        "Vishal Gupta",
        "https://imgshare.io/images/2021/06/30/vishal1.png",
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    margin: EdgeInsets.fromLTRB(20, 24, 20, 10),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(255, 0, 0, 0), width: 2),
                      borderRadius: BorderRadius.circular(10),
                      shape: BoxShape.rectangle,
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 12, 0, 0),
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
                                  Text(
                                    " : www.electa-xyz.com",
                                    style: TextStyle(fontSize: 20),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.008,
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
