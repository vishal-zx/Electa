import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'package:animated_text_kit/animated_text_kit.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

// import 'package:scanbot_sdk/scanbot_sdk.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1995),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  bool isInitialized = false;

  bool? value = false;

  bool? value2 = false;

  Widget buildcheckbox() => Checkbox(
      value: value,
      onChanged: (value) {
        setState(() {
          this.value = value;
        });
      });

  Widget buildcheckbox2() => Checkbox(
      value: value2,
      onChanged: (value2) {
        setState(() {
          this.value2 = value2;
        });
      });
  @override
  void initState() {
    FlutterMobileVision.start().then((value) {
      isInitialized = true;
    });
    super.initState();
  }

  _startScan() async {
    List<OcrText> list = [];
    try {
      list = await FlutterMobileVision.read(waitTap: true, fps: 5.0);
      for (OcrText text in list) {
        print('value is ${text.value}');
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var elevatedbutton = ElevatedButton(
        onPressed: () => _selectDate(context),
        child: Icon(Icons.date_range_outlined));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register",
          textDirection: TextDirection.ltr,
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () => {
                  Navigator.pop(context),
                },
            icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20.0,
          ),
          Image.asset(
            "assets/images/sign up.png",
            fit: BoxFit.fitHeight,
            // height: 400,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 4, 40, 0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.lightBlue,
                ),
                hintText: "Enter Your Roll Number",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 3, 40, 0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person_outline_sharp,
                  color: Colors.lightBlue,
                ),
                hintText: "Enter Your Name",
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8.0, left: 15.0),
                child: Text("DOB : ",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 15.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(selectedDate.day.toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text("/"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(selectedDate.month.toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text("/"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(selectedDate.year.toString()),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.0, left: 10.0),
                child: SizedBox(child: elevatedbutton),
              ),
            ],
          ),
          Row(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: ElevatedButton(
                  onPressed: _startScan,
                  child: Text('scan your college id card')),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 140.0),
              child: buildcheckbox(),
            ),
          ]),

          // Padding(
          //   padding: const EdgeInsets.only(left: 25.0),
          //   child: buildcheckbox(),
          // ),
          Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 7.0),
              child: ElevatedButton(
                  onPressed: () => {}, child: Text('Face Authentication')),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 165),
              child: buildcheckbox2(),
            ),
          ]),

          Center(child: Text('You want to register yourself as:'))

          // Padding(
          //   padding: const EdgeInsets.only(left: 28.0),
          //   child: buildCheckbox(),
          // ),

          // Center(
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 10.0),
          //     child: Text(
          //       'you want to register yourself as:',
          //       style: TextStyle(
          //         fontSize: 22.0,
          //         foreground: Paint()
          //           ..style = PaintingStyle.stroke
          //           ..strokeWidth = 1
          //           ..color = Colors.black87,
          //       ),
          //     ),
          //   ),
          // ),
          // Row(
          //   children: <Widget>[
          //     Padding(
          //       padding: const EdgeInsets.only(left: 80.0, top: 20.0),
          //       child:
          //           ElevatedButton(onPressed: () => {}, child: Text('VOTER')),
          //     ),
          //     Padding(
          //       padding: EdgeInsets.only(left: 30.0, top: 20.0),
          //       child: ElevatedButton(
          //           onPressed: () => {}, child: Text('CANDIDATE')),
          //     ),
          //   ],
          // ),
          // // ignore: deprecated_member_use
          // Padding(
          //   padding: const EdgeInsets.only(top: 20.0),
          //   child: ColorizeAnimatedTextKit(
          //     text: ['you have succesfully registered as VOTER/CANDIDATE'],
          //     colors: [
          //       Colors.black,
          //       Colors.brown,
          //       Colors.purple,
          //       Colors.red,
          //       Colors.yellow,
          //       Colors.orange,
          //       Colors.lightBlue
          //     ],
          //     textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          //     textAlign: TextAlign.center,
          //     isRepeatingAnimation: true,
          //     speed: Duration(milliseconds: 300),
          //     totalRepeatCount: 5,
          //   ),
          // )
        ],
      ),
    );
  }
}
