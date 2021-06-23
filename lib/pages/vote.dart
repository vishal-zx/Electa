import 'dart:ui';

import 'package:electa/widgets/drawer.dart';
import 'package:flutter/material.dart';

class Vote extends StatefulWidget {
  const Vote({ Key? key }) : super(key: key);

  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electa"),
        elevation: 10,
      ),
      body: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.14,
                child: Center(
                  child: Text("Every responsible student must vote for their better future !!",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 700,
                  child: Container(
                    child: PageView.builder(
                      itemCount: 10,
                      controller: PageController(viewportFraction: 0.85),
                      onPageChanged: (int index) => setState(() => _index = index),
                      itemBuilder: (_, i) {
                        return Transform.scale(
                          scale: i == _index ? 1 : 0.9,
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              margin: EdgeInsets.zero,
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
                                    height: 25,
                                  ),
                                  Center(
                                    child: Text(
                                      "President",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 35,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: Text("Hello"),
                                        padding: EdgeInsets.all(25),  
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // elevation: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      drawer: MyDrawer(),
    );
  }
}