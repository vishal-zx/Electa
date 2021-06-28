import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:core';

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

  @override
  Widget build(BuildContext context) {
    var iconButton = IconButton(
        onPressed: () => _selectDate(context),
        icon: Icon(Icons.date_range_rounded));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ELECTA",
          textDirection: TextDirection.ltr,
        ),
        elevation: 0,
        leading: IconButton(
            onPressed: () => {}, icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 50.0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.person_pin),
                hintText: "enter your Roll Number",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0, right: 50.0),
            child: TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.person_outline_sharp),
                hintText: "enter your name",
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 15.0),
                child: Text("DOB :",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 20.0)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.0),
                child: SizedBox(child: iconButton),
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
              )
            ],
          ),
          // ElevatedButton(onPressed: onPressed, child: child)
        ],
      ),
    );
  }
}
