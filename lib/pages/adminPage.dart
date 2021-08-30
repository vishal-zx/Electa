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
  bool isUpdating = false;

  bool isTimeOkay = false;
  var datTim;

  void checkTime()async{
    await FirebaseFirestore.instance
    .collection('tools')
    .doc('resultTime')
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        datTim = DateTime.fromMillisecondsSinceEpoch(data['dateTime'].seconds * 1000);
        print(datTim);
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
      Container(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Result Date-Time",
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
                print(finalDateTime);
                
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
                  FirebaseFirestore.instance.collection('tools').doc('resultTime').update({
                    'dateTime' : finalDateTime
                  }).then((value){
                    setState(() {
                      isUpdating = false;
                    });
                    print("Date Updated");
                  });
                }, 
                child: Text("Update Date-Time"),
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
            )
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}