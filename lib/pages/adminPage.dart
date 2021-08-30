import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({ Key? key }) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  DateTime finalDateTime = DateTime.now();
  DateTime finalDateTime2 = DateTime.now();
  DateTime finalDateTime3 = DateTime.now();
  bool isUpdating3 = false;
  bool isUpdating2 = false;
  bool isUpdating = false;

  bool isTimeOkay = false;
  var datTim;
  var datTim2;
  var datTim3;

  void checkTime()async{
    await FirebaseFirestore.instance
    .collection('tools')
    .doc('time')
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        datTim = DateTime.fromMillisecondsSinceEpoch(data['result'].seconds * 1000);
        datTim2 = DateTime.fromMillisecondsSinceEpoch(data['votingClose'].seconds * 1000);
        datTim3 = DateTime.fromMillisecondsSinceEpoch(data['votingStart'].seconds * 1000);
        setState(() {
          isTimeOkay = true;
        });
      }
    });
  }

  @override
  initState(){
    checkTime();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text("Admin Page"),
        elevation: 10,
      ),
      body:
      (isTimeOkay==false)?
      Center(
        heightFactor: 9.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitChasingDots(
              color: Colors.grey[800],
              size: 50.0,
              duration: Duration(seconds: 2),
            ),
          ],
        ),
      ):
      SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Result Show Date-Time",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'dd MMM, yyyy',
                initialValue: datTim.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event, color: Colors.black),
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  return true;
                },
                onChanged: (val) {
                  finalDateTime = DateTime.parse(val);
                },
                validator: (val) {
                  return null;
                },
                onSaved: (val) {
                  return null;
                },
              ),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      isUpdating = true;
                    });
                    FirebaseFirestore.instance.collection('tools').doc('time').update({
                      'result' : finalDateTime
                    }).then((value){
                      setState(() {
                        isUpdating = false;
                      });
                    });
                  }, 
                  child: Text("Update Result Date-Time"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all((isUpdating)?Colors.black45:Colors.black),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Select Voting Start Date-Time",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'dd MMM, yyyy',
                initialValue: datTim3.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event, color: Colors.black),
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  return true;
                },
                onChanged: (val) {
                  finalDateTime3 = DateTime.parse(val);
                },
                validator: (val) {
                  return null;
                },
                onSaved: (val) {
                  return null;
                },
              ),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      isUpdating3 = true;
                    });
                    FirebaseFirestore.instance.collection('tools').doc('time').update({
                      'votingStart' : finalDateTime3
                    }).then((value){
                      setState(() {
                        isUpdating3 = false;
                      });
                    });
                  }, 
                  child: Text("Update Voting Start Date-Time"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all((isUpdating3)?Colors.black45:Colors.black),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Select Voting Close Date-Time",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'dd MMM, yyyy',
                initialValue: datTim2.toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event, color: Colors.black),
                selectableDayPredicate: (date) {
                  // Disable weekend days to select from the calendar
                  return true;
                },
                onChanged: (val) {
                  finalDateTime2 = DateTime.parse(val);
                },
                validator: (val) {
                  return null;
                },
                onSaved: (val) {
                  return null;
                },
              ),
              SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    setState(() {
                      isUpdating2 = true;
                    });
                    FirebaseFirestore.instance.collection('tools').doc('time').update({
                      'votingClose' : finalDateTime2
                    }).then((value){
                      setState(() {
                        isUpdating2 = false;
                      });
                    });
                  }, 
                  child: Text("Update Voting Close Date-Time"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all((isUpdating2)?Colors.black45:Colors.black),
                    padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}