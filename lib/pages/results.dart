import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:electa/widgets/All_Confetti_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:slimy_card/slimy_card.dart';
import 'package:pie_chart/pie_chart.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';

class Result extends StatefulWidget {
  const Result({key}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class UserCandidate {
  var name;
  var rollNo;
  var imageUrl;
  var bio;
  var counter;
  var title;

  UserCandidate(this.name, this.rollNo, this.imageUrl, this.bio, this.counter, this.title);
}

class _ResultState extends State<Result> {
  int _index = 0, cpos = 0;
  var positions = [
    "President",
    "Vice-President",
    "G-Sec Science",
    "G-Sec Cultural",
    "G-Sec Sports",
    "AG-Sec Science",
    "AG-Sec Cultural",
    "AG-Sec Sports",
  ];

  get key => null;

  final List<List<UserCandidate>> allCans = [];

  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('candidates');

  Future<void> getData() async {
    for (int i = 0; i < positions.length; i++) {
      QuerySnapshot querySnapshot = 
          await _collectionRef.where('title', isEqualTo: positions[i]).get();
      var cans = querySnapshot.docs;
      List<UserCandidate> temp = [];
      for (var can in cans) {
        Map<String, dynamic> data = can.data() as Map<String, dynamic>;
        UserCandidate c = new UserCandidate(data['Name'], data['Roll'],
            data['imageUrl'], data['Bio'], data['counter'], data['title']);
        temp.add(c);
      }
      allCans.add(temp);
    }
  }

  UserCandidate findWinner(List<UserCandidate> cans) {
    int mx = 0, j = -1;
    for (int i = 0; i < cans.length; i++) {
      if (cans[i].counter != "0" && cans[i].counter >= mx) {
        mx = cans[i].counter;
        j = i;
      }
    }
    for (int i = 0; i < cans.length; i++) {
      if (cans[i].counter == mx) {
        // tie condition
      }
    }
    return cans[j];
  }

  bool isTimeOkay = false;
  var datTim;

  void checkTime()async{
    await FirebaseFirestore.instance
    .collection('tools')
    .doc('time')
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        datTim = DateTime.fromMillisecondsSinceEpoch(data['result'].seconds * 1000);
        if(datTim.compareTo(DateTime.now()) < 0){        
          setState(() {
            isTimeOkay = true;
          });
        }
      }
    });
  }

  bool allRight = false;
  @override
  void initState() {
    if (allCans.length == 0) {
      getData().then((val) {
        setState(() {
          allRight = true;
        });
      });
    } else {
      allRight = true;
    }
    checkTime();
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
        child: (allRight == false)?
        Center(
          heightFactor: 8.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitCubeGrid(
                color: Colors.grey,
                size: 50.0,
                duration: Duration(seconds: 3),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "Loading Data ...",
                style: TextStyle(fontSize: 19, color: Colors.black)
              ),
            ],
          ),
        )
        :(isTimeOkay==false)?
        Center(
          heightFactor: 9.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Adding Suspense !! 🪄",
                style: TextStyle(fontSize: 19, color: Colors.black)
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Text(
                "You can see the result only after \n${datTim.day.toString().padLeft(2,'0')}/${datTim.month.toString().padLeft(2,'0')}/${datTim.year.toString()} - ${datTim.hour.toString().padLeft(2,'0')}:${datTim.minute.toString().padLeft(2,'0')}",
                style: TextStyle(fontSize: 17, color: Colors.black), textAlign: TextAlign.center,
              ),
            ],
          ),
        ):
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.10,
              child: Center(
                child: Text(
                  "Congratulations! to all the winners. \nAll the best for your upcoming responsibilities.",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            AllConfettiWidget(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
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
                            builder: ((BuildContext context, AsyncSnapshot snapshot) {
                              int j=0;
                              return ListView(
                                padding: EdgeInsets.zero,
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  SlimyCard(
                                    color: Colors.blueGrey,
                                    topCardWidget: topCardWidget(i),
                                    bottomCardWidget: bottomCardWidget(i,j),
                                    bottomCardHeight: MediaQuery.of(context).size.height*0.25,
                                  ),
                                ],
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ),
            )
          ]
        )
      ),
    );
  }

  topCardWidget(int i) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff63717e),
            Color(0xff4d6277),
            Color(0xff2d5173),
            Color(0xff003f6b),
            Color(0xff003b6d)
          ]
        ),
      ),
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
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
          Column(
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.height * 0.15,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: findWinner(allCans[i]).imageUrl,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                        value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                        Image(image: AssetImage("assets/images/u1.png")
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
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
        ],
      ),
    );
  }

  bottomCardWidget(int i, int j) {
    return Container(
      padding: EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width*0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff63717e),
            Color(0xff4d6277),
            Color(0xff2d5173),
            Color(0xff003f6b),
            Color(0xff003b6d)
          ]
        ),
      ),
      child: Column(
        children: [
          Text(
            allCans[i][j].name + " v/s " + allCans[i][j+1].name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          (allCans[i].length == 3)?
          Text(
            " v/s " + allCans[i][j+2].name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ):Text(
            "",
          ),

          Expanded(
            child: PieChart(
              dataMap: 
              (allCans[i].length == 3)?data3(allCans[i][j], allCans[i][j+1], allCans[i][j+2]):
              data2(allCans[i][j], allCans[i][j+1]),

              animationDuration: Duration(milliseconds: 800),
              chartType: ChartType.ring,
              chartValuesOptions: ChartValuesOptions(
                decimalPlaces: 0,
                showChartValues: true,
              ),
              legendOptions: LegendOptions(
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, double> data3(UserCandidate u1, UserCandidate u2, UserCandidate u3){
  Map<String, double> dataMap = {
    u1.name:(u1.counter=="0")?0.0:u1.counter.toDouble(),
    u2.name:(u2.counter=="0")?0.0:u2.counter.toDouble(), 
    u3.name:(u3.counter=="0")?0.0:u3.counter.toDouble(), 
  };
  return dataMap;
}

Map<String, double> data2(UserCandidate u1, UserCandidate u2){
  Map<String, double> dataMap = {
    u1.name:(u1.counter=="0")?0.0:u1.counter.toDouble(),
    u2.name:(u2.counter=="0")?0.0:u2.counter.toDouble(), 
  };
  return dataMap;
}