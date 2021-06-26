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

Widget _buildPopupDialog(BuildContext context,
// , String candidate, String position
) {
  return BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: new AlertDialog(
        title: const Text('Confirm Your Vote!',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),),
        content: Container(
          height: 120,
          width: 170,
          child: new Column(
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Do you confirm your vote according to your choice as:",
                textAlign: TextAlign.center,
              ),
              Container(
                width: 240,
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Column(
                  children: [
                    Text(
                      "Position : President\n\nCandidate : Vishal Gupta",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        scrollable: true,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.blueGrey[100],
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            // color: Theme.of(context).primaryColor,
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
            // color: Theme.of(context).primaryColor,
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
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Center(
                  child: Text("Every responsible student must vote for their better future !!",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    ),
                ),
              ),
              Center(
                child: SizedBox(
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
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                    height: 20,
                                  ),
                                  Center(
                                    child: Text(
                                      positions[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.white,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.45,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        // SizedBox(
                                        //   height: MediaQuery.of(context).size.height*0.03,
                                        // ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
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
                                            width: MediaQuery.of(context).size.width*0.39,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Vishal Gupta",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text("19UCS053",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),                                                
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                  ),                                                
                                                ),
                                                
                                              ],
                                            ),
                                              ),
                                            
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                // Icons.chevron_right_rounded,
                                                // Icons.double_arrow_rounded,
                                                // Icons.recommend_outlined,
                                                // Icons.star_outline_rounded,
                                                // Icons.stars_sharp,
                                                // Icons.task_alt_rounded,
                                                // Icons.thumb_up_off_alt,
                                                size: 35,
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
                                        ),
                                        SizedBox(
                                          // height: MediaQuery.of(context).size.height*0.04,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
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
                                            width: MediaQuery.of(context).size.width*0.39,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Vishal Gupta",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text("19UCS053",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                  ),                                                
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                  ),                                                
                                                ),
                                              ],
                                            ),
                                              ),
                                            
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                // Icons.chevron_right_rounded,
                                                // Icons.double_arrow_rounded,
                                                // Icons.recommend_outlined,
                                                // Icons.star_outline_rounded,
                                                // Icons.stars_sharp,
                                                // Icons.task_alt_rounded,
                                                // Icons.thumb_up_off_alt,
                                                size: 35,
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
                                        ),
                                        SizedBox(
                                          // height: MediaQuery.of(context).size.height*0.04,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
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
                                            width: MediaQuery.of(context).size.width*0.39,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Vishal Gupta",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text("19UCS053",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    ),                                                
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.white,
                                                    ),                                                
                                                  ),
                                                ],
                                              ),
                                            ),
                                            
                                            IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios,
                                                // Icons.chevron_right_rounded,
                                                // Icons.double_arrow_rounded,
                                                // Icons.recommend_outlined,
                                                // Icons.star_outline_rounded,
                                                // Icons.stars_sharp,
                                                // Icons.task_alt_rounded,
                                                // Icons.thumb_up_off_alt,
                                                size: 35,
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
                                        ),
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
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.095,
                      child: Text("How to vote :\nTap on the arrow against the name of candidate of your choice. Then to confirm your vote, click Confirm.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
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
      ),
      drawer: MyDrawer(),
    );
  }
}