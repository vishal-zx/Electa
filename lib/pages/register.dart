import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';

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
  @override
  void initState() {
    FlutterMobileVision.start().then((value) {
      isInitialized = true;
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    var elevatedbutton = ElevatedButton(
        onPressed: () => _selectDate(context),
        child: Icon(Icons.date_range_outlined));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ELECTA",
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
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 40, 0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person_pin,
                  color: Colors.red,
                ),
                hintText: "Enter Your Roll Number",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 8, 40, 0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(
                  Icons.person_outline_sharp,
                  color: Colors.red,
                ),
                hintText: "Enter Your Name",
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16.0, left: 15.0),
                child: Text("DOB : ",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 20.0)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Text(selectedDate.day.toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Text("/"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Text(selectedDate.month.toString()),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Text("/"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 17.0),
                child: Text(selectedDate.year.toString()),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.0, left: 10.0),
                child: SizedBox(child: elevatedbutton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
