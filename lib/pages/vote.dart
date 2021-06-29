// import 'dart:ffi';
import 'dart:ui';

// import 'package:electa/utils/routes.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  const Vote({ Key? key }) : super(key: key);

  @override
  _VoteState createState() => _VoteState();
}

Widget _buildCandidateRow(BuildContext context)
{
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        width: MediaQuery.of(context).size.height*0.09,
        height: MediaQuery.of(context).size.height*0.09,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage("https://www.mantruckandbus.com/fileadmin/media/bilder/02_19/219_05_busbusiness_interviewHeader_1485x1254.jpg"),
            fit: BoxFit.fill
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width*0.35,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("Vishal Gupta",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(
              height: 5,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("19UCS053",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ), 
          ],
        ),
      ),
      IconButton(
        icon: Icon(
          Icons.arrow_forward_ios,
          size: 25,
          color: Colors.white,
        ),
        onPressed: (){
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialog(context),
          );
        },
      ),
    ],
  );
}

Widget _buildPopupDialog(BuildContext context) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: new AlertDialog(
        // scrollable: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.blueGrey[100],
        title: const Text('Confirm Your Vote!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height*0.28,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/images/gi.gif",
                height: 80,
                width: 80,
              ),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Text("Position : President"),
              ),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Text("Candidate : Vishal Gupta"),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Confirm',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
  );
}

class _VoteState extends State<Vote> {
  int _index = 0;
  var positions = ["President", "Vice-President", "G-Sec Science", "G-Sec Cultural", "G-Sec Sports", "AG-Sec Science", "AG-Sec Cultural", "AG-Sec Sports",];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electa"),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth, 
                  child: Text("Every responsible student must vote \nfor their better future !!",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Container(
                child: PageView.builder(
                  itemCount: positions.length,
                  controller: PageController(viewportFraction: 0.85),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.9,
                      child: Card(
                        margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height*0.03, 0, MediaQuery.of(context).size.height*0.055),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/v4.jpg"),
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *0.02,
                              ),
                              Center(
                                heightFactor: 0.9,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Text(
                                    positions[i],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: MediaQuery.of(context).size.width*0.08,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *0.005,
                              ),
                              Divider(
                                color: Colors.white,
                                thickness: 1,
                                indent: 25,
                                endIndent: 25,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.006,
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildCandidateRow(context),
                                    _buildCandidateRow(context),
                                    _buildCandidateRow(context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        elevation: 5,
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.02,
                  ),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.black,
                    size: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text("How to vote :\nTap on the arrow against the name of candidate of your \nchoice. Then to confirm your vote, click Confirm.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}