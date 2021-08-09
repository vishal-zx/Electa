import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:electa/widgets/All_Confetti_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:slimy_card/slimy_card.dart';
// ignore: unused_import
import 'package:pie_chart/pie_chart.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';



class Result extends StatefulWidget {
  const Result({ key }) : super(key: key);


  @override
  _ResultState createState() => _ResultState();
}

// ignore: unused_element
Widget _buildResultRow(BuildContext context, String winner, String roll, String image, String position){
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
        imageUrl: image,
        progressIndicatorBuilder: (context, url, downloadProgress) => 
                CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/u1.png")),
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
                child: Text("$winner",
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
        child: Text("$roll",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
       ),
     ],
   ),
  ),
  ]
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

class CandidateResult{
  final winner;
  final rollNo;
  final imageUrl;

  CandidateResult(this.winner, this.rollNo, this.imageUrl);
}

class _ResultState extends State<Result> {
  int _index = 0, cpos=0;
  var positions = ["President", "Vice-President", "G-Sec Science", "G-Sec Cultural", "G-Sec Sports", "AG-Sec Science", "AG-Sec Cultural", "AG-Sec Sports",];

  final List<List<CandidateResult>> cn = [
    [
      new CandidateResult("Saumitra Vyas", "19UCS252", "https://imgshare.io/images/2021/06/30/saumitra.png"),

    ],
    [
      new CandidateResult("Vishal Gupta", "19UCS053", "https://imgshare.io/images/2021/06/30/vishal1.png"),

    ],
    [
      new CandidateResult("Gunit Varshney", "19UCS188", "https://imgshare.io/images/2021/06/30/gunit.png"),

    ],
    [
      new CandidateResult("Ketan Jakhar", "19UCC020", "https://imgshare.io/images/2021/06/30/ketan.png"),

    ],
    [
      new CandidateResult("Abhinav Maheshwari", "19UCS169", "https://imgshare.io/images/2021/07/01/avhinav.jpg"),

    ],
    [
      new CandidateResult("Shubham Jain", "18UEC022", "https://imgshare.io/images/2021/06/30/shubham.png"),
    ],
    [
      new CandidateResult("Vishal Gupta", "19UCS053", "https://imgshare.io/images/2021/06/30/vishal1.png")
    ],
    [

      new CandidateResult("Karan Aditte Singh", "19UCC025", "https://imgshare.io/images/2021/06/30/karan.png")
    ],
  ];

  get key => null;

  final List<List<UserCandidate>> allCans = [];

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

  UserCandidate findWinner(List<UserCandidate> cans) {
    int mx=0, j=-1;
    for(int i=0;i<cans.length;i++){
      if(cans[i].counter >= mx){
        mx = cans[i].counter;
        j=i;
      }
    }
    for(int i=0;i<cans.length;i++){
      if(cans[i].counter == mx){
        // tie condition
      }
    }
    return cans[j];
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Results"),
        elevation: 10,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text("Congratulation! to all the selected candidates \nAll the best for your upcoming responsibilities.",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ),
              ),
            ),
            Container(
              child: (allRight==false)?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitCubeGrid(
                    color: Colors.grey,
                    size: 50.0,
                    duration: Duration(seconds: 3),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.01,
                  ),
                  Text(
                    "Loading Data ...",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white
                    )
                  ),
                ],
              ):SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Container(
                child: PageView.builder(
                  itemCount: positions.length,
                  controller: PageController(viewportFraction: 0.75),
                  onPageChanged: (int index) => setState(() => _index = index),
                  itemBuilder: (_, i) {
                    return Transform.scale(
                      scale: i == _index ? 1 : 0.8,
                      child: StreamBuilder(
                        initialData: false,
                        stream: slimyCard.stream,
                        builder: ((BuildContext context, AsyncSnapshot snapshot)
                        {
                          return ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              SizedBox(height: 70),
                              SlimyCard(
                                color: Colors.indigo[300],
                                topCardWidget: topCardWidget(i),
                                bottomCardWidget: bottomCardWidget(),
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                    );
                  },
                ),

              ),

            )
            )



          ]

        )
      ),
    );
  }

  topCardWidget(int i) {
    return Container(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.01),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            positions[i],
            style: TextStyle(color: Colors.white, fontSize: 27),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Divider(
            color: Colors.white,
            thickness: 1,
            indent: 25,
            endIndent: 25,
          ),
          SizedBox(height: 15),
          AllConfettiWidget(child: Center(
            child: Container(
          width: MediaQuery.of(context).size.height*0.13,
          height: MediaQuery.of(context).size.height*0.13,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: findWinner(allCans[i]).imageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) => 
                      CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/u1.png")),
            ),
          ),
        ),
          ), key: key),
          
        
          SizedBox(height: 15),
          Text(
            findWinner(allCans[i]).name,
            style: TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          Text(
            findWinner(allCans[i]).rollNo,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  bottomCardWidget() {
    return Column(
      children: [
        
        Text(
          'Saumitra Vyas V/S Manya Sharma',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Expanded(
          child: Text(
            'FlutterDevs specializes in creating cost-effective and efficient '
                'applications with our perfectly crafted,creative and leading-edge '
                'flutter app development solutions for customers all around the globe.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

      ],
    );
  }
}
