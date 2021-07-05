import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  HelpNSupport extends StatefulWidget {
  HelpNSupport({ Key? key }) : super(key: key);

  @override
  _HelpNSupportState createState() => _HelpNSupportState();
}

class Socials{
  String linkedin;
  String insta;

  Socials(this.linkedin, this.insta);
}

class Member{
  String name;
  String image;
  String email;
  Socials sn;
  
  Member(this.name, this.image, this.email, this.sn);
}

Widget _buildTeamRow(BuildContext context, Member person)
{
  return Row(
    children: [
      Container(
        height: MediaQuery.of(context).size.height*0.04,
        width: MediaQuery.of(context).size.height*0.04,
        child: Image.asset(person.image),
      ),
    ],
  );
}

class _HelpNSupportState extends State<HelpNSupport> {

  List<Member> mem = [
    Member("Manya Sharma", "https://imgshare.io/images/2021/06/30/manya.png", "19ucc066@lnmiit.ac.in", Socials("https://www.linkedin.com/in/manya-sharma-b449671b8/", "")),

    Member("Poojan Gadhiya", "https://imgshare.io/images/2021/06/30/poojan.png", "19ucs245@lnmiit.ac.in", Socials("https://www.linkedin.com/in/poojan-gadhiya/", "https://www.instagram.com/enjoying___alwayss/")),

    Member("Saumitra Vyas", "https://imgshare.io/images/2021/06/30/saumitra.png", "19ucs252@lnmiit.ac.in", Socials("https://www.linkedin.com/in/saumitra-vyas-631b701a6/", "https://www.instagram.com/saumitra_vyas/")),

    Member("Vishal Gupta", "https://imgshare.io/images/2021/06/30/vishal1.png", "19ucs053@lnmiit.ac.in", Socials("https://www.linkedin.com/in/vishal-zx/", "https://www.instagram.com/vishalagrawal__/")),
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
                    height: MediaQuery.of(context).size.height*0.15,
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
                          padding: EdgeInsets.fromLTRB(50, 32, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.mail,
                                    size: 24,
                                  ),
                                  Text(
                                    " : info.electa@gmail.com",
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
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
                                    style: TextStyle(
                                      fontSize: 20
                                    ),
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
                    left: MediaQuery.of(context).size.width*0.11,
                    top: 14,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                      color: Colors.blueGrey[100],
                      child: Text(
                        'Contact Us',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    )
                  ),
                ],
              ),
              SizedBox(
                height:MediaQuery.of(context).size.height*0.04,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height*0.585,
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
                          padding: EdgeInsets.fromLTRB(50, 32, 0, 0),
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
                    left: MediaQuery.of(context).size.width*0.67,
                    top: 14,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                      color: Colors.blueGrey[100],
                      child: Text(
                        'Our Team',
                        style: TextStyle(color: Colors.black, fontSize: 18),
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