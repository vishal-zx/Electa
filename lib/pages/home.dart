import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electa"),
        elevation: 10,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(8),
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [for (var i = 0; i < 6; i++) _getPost()],
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }

  Container _getPost() {
    return Container(
      height: 310,
      width: 400,
      decoration: BoxDecoration(
          color: Colors.transparent,
          // image: DecorationImage(
          //   image: NetworkImage(
          //     "https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg"),
          // fit: BoxFit.contain),
          //border: Border.all(
          // color: Colors.black26,
          // width: 5,
          //),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircularProfileAvatar(
                      'https://imgshare.io/images/2021/06/30/poojan.png',
                      radius: 15,
                      backgroundColor: Colors.transparent,
                      onTap: () => print("You Clicked his Profile Image")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => print("You Are on the Profile"),
                      child: Text("Poojan Gadhiya")),
                  //FlatButton.icon(
                  //  onPressed: () => print("You Opened Edit"),
                  //icon: Icon(Icons.brightness_5_outlined),
                  //label: Text("."))
                ],
              ),
            ],
          ),
          Container(
            height: 200,
            width: 400,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage("https://source.unsplash.com/random"),
                    fit: BoxFit.fitWidth)),
          ),
          //FlatButton.icon(
          //  onPressed: () => print("You Liked"),
          //  icon: Icon(Icons.favorite),
          // label: Text("React"))
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () => print("Liked"),
                  icon: Icon(Icons.thumb_up_off_alt_outlined)),
              IconButton(
                  onPressed: () => print("Disliked"),
                  icon: Icon(Icons.thumb_down_off_alt_outlined))
            ],
          )
        ],
      ),
    );
  }
}
