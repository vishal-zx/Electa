import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:slimy_card/slimy_card.dart';
// ignore: unused_import
import 'package:pie_chart/pie_chart.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';


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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: Drawer(),
      appBar: AppBar(
        title: Text("Results"),
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
                            topCardWidget: topCardWidget(),
                            bottomCardWidget: bottomCardWidget(),
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



          ]

        )
      ),
    );
  }

  topCardWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(image: AssetImage('assets/images/cc.jpg')),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Text(
          'President \nSaumitra Vyas',
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Center(
          child: Text(
            "Congratulations, Saumitra Vyas! for winning this year's presidential election."
                "All the best for your new position.",
            style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 10),
      ],
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
