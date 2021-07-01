import 'package:electa/widgets/drawer.dart';
import 'package:flutter/material.dart';

class  MyAccount extends StatelessWidget {
  const MyAccount({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electa"),
        elevation: 10,
      ),
      body: Center(
        child: Container(
          child: Text("This will be the My Account area by default!",
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}