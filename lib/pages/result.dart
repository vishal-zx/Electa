import 'package:flutter/material.dart';


class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

// ignore: camel_case_types
class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text("Results"),
      ),
        backgroundColor: Colors.blueGrey,
        body: new Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                    width: 190.0,
                    height: 190.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                "https://image.freepik.com/free-vector/candidate-election-campaign_74855-6281.jpg")
                        )
                    )
                ),
                new Text("John De",
                    textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold, height: 1.7),
                ),

              ],
            ),
        ),
    );


  }
}

