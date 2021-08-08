import 'dart:ui';

// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Vote extends StatefulWidget {
  const Vote({ Key? key }) : super(key: key);

  @override
  _VoteState createState() => _VoteState();
}

Widget _buildCandidateRow(BuildContext context, UserCandidate candidate){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Container(
        width: MediaQuery.of(context).size.height*0.09,
        height: MediaQuery.of(context).size.height*0.09,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: candidate.imageUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) => 
                    CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => Icon(Icons.error),
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
                child: Text("${candidate.name}",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            SizedBox(
              height: 5,
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("${candidate.rollNo}",
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
            builder: (BuildContext context) => _buildPopupDialog(context, candidate),
          );
        },
      ),
    ],
  );
}

SnackBar makeBar(String text){
    final snackBar = SnackBar(
      duration: Duration(milliseconds: 3000),
      content: Text('$text', textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 15),
      ),
      backgroundColor: Colors.black87.withOpacity(1),
      elevation: 3,
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    );
    return snackBar;
  }

Widget _buildPopupDialog(BuildContext context, UserCandidate cand) {
  
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,          
                children: [
                  Image.asset(
                    "assets/images/gi.gif",
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [  
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text("Position : ${cand.title}",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text("Candidate : ${cand.name}",
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () {
              cand.counter++;
              FirebaseFirestore.instance.collection('candidates').doc(cand.rollNo).update({'counter':cand.counter}).then((value) {
                String msg = "Your Vote Is Successfully Submitted !! 🔥";
                ScaffoldMessenger.of(context).showSnackBar(makeBar(msg));
                Future.delayed(const Duration(milliseconds: 700), () {
                  Navigator.of(context).pop();
                });
              });
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

class UserCandidate{
  var name;
  var rollNo;
  var imageUrl;
  var bio;
  var counter;
  var title;

  UserCandidate(this.name, this.rollNo, this.imageUrl, this.bio, this.counter, this.title);
}

class _VoteState extends State<Vote> {

  int _index = 0, cpos=0;
  var positions = ["President", "Vice-President", "G-Sec Science", "G-Sec Cultural", "G-Sec Sports", "AG-Sec Science", "AG-Sec Cultural", "AG-Sec Sports",];

  final List<List<UserCandidate>> allCans = [];
  bool allRight = false;
  @override 
  void initState(){
    if(allCans.length == 0){
      getData().then((val){
        setState((){
          allRight = true;
        });
      });
    }
    else{
      allRight = true;
    }
    super.initState();
  }

  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('candidates');

  Future<void> getData() async {
    for(int i=0;i<positions.length;i++) {
      QuerySnapshot querySnapshot = await _collectionRef.where('title', isEqualTo: positions[i]).get();
      var cans = querySnapshot.docs;
      List<UserCandidate> temp=[];
      for(var can in cans){
        Map<String, dynamic> data = can.data() as Map<String, dynamic>;
        UserCandidate c = new UserCandidate(data['Name'], data['Roll'], data['imageUrl'], data['Bio'], data['counter'], data['title']);
        temp.add(c);
      }
      allCans.add(temp);
    }
  }
  
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
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [Color(0xff63717e), Color(0xff4d6277), Color(0xff2d5173), Color(0xff003f6b), Color(0xff003b6d)]
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
                                child: 
                                (allRight==false)?
                                SpinKitCircle(
                                  color: Colors.black,
                                  size: 50.0,
                                  duration: Duration(seconds: 5), 
                                ):
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    for (var j = 0; j < allCans[i].length; j++)
                                      _buildCandidateRow(context, allCans[i][j]),
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.175,
              decoration: BoxDecoration(
                color: Colors.blueGrey[300],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(topRight: Radius.circular(60), topLeft: Radius.circular(60)),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.015,
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