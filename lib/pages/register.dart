import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_mobile_vision/flutter_mobile_vision.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  String _textValue = "sample";
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

  Future<Null> _read() async {
    List<OcrText> texts = [];
    try {
      texts = await FlutterMobileVision.read(
        camera: _cameraOcr,
        waitTap: true,
      );

      setState(() {
        _textValue = texts[0].value;
        texts.add(new OcrText('Failed to recognize text.'));
      });
    } on Exception {
      texts.add(new OcrText('Failed to recognise text.'));
    }
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
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
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
              padding: const EdgeInsets.only(top: 5.0, left: 7.0),
              child: ElevatedButton(
                  onPressed: _read,
                  child: Text(
                    'Scan Your College Id Card',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ),
            new Text(_textValue),
            Padding(
              padding: const EdgeInsets.only(left: 100.0),
              child: buildcheckbox(),
            ),
          ]),

          // Padding(
          //   padding: const EdgeInsets.only(left: 25.0),
          //   child: buildcheckbox(),
          // ),
          Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0, left: 7.0),
              child: ElevatedButton(
                  onPressed: () => {},
                  child: Text(
                    'Face Authentication',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 178),
              child: buildcheckbox2(),
            ),
          ]),

          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('You Want To Register Yourself AAs:',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          )),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  RaisedButton(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.black, width: 2.0)),
                    color: Colors.blue[200],
                    onPressed: () {},
                    child: Text(
                      'VOTER',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.black, width: 2.0)),
                    color: Colors.pink[100],
                    onPressed: () {},
                    child: Text('CANDIDATE',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Colors.black,
                        )),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
