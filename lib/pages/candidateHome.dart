// ignore: import_of_legacy_library_into_null_safe
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:electa/pages/userProfile.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateFeed extends StatefulWidget {
  const CandidateFeed({Key? key}) : super(key: key);

  @override
  _CandidateFeedState createState() => _CandidateFeedState();
}

class _CandidateFeedState extends State<CandidateFeed> {
  @override
  Widget build(BuildContext context) {
    var total_posts = 10;
    return Scaffold(
      appBar: AppBar(
        title: Text("Electa"),
        actions: [
          IconButton(
              onPressed: add_post(), icon: Icon(Icons.add_a_photo_outlined))
        ],
        elevation: 10,
      ),
      body: WillPopScope(
        onWillPop: _exitApp,
        child: ListView.builder(
            itemCount: total_posts,
            itemBuilder: (BuildContext context, int index) {
              var postImage = "https://picsum.photos/200";
              var userName = "Poojan Gadhiya";
              var postComment =
                  "If You Want To Save Water, Then Start from your house. Irrlevent";
              var userImage =
                  "https://firebasestorage.googleapis.com/v0/b/electa-e343d.appspot.com/o/userImages%2F19ucs245.png?alt=media&token=12f17277-c8f3-4011-a92a-44ed968dec7d";
              return Container(
                height: MediaQuery.of(context).size.height * 0.63,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircularProfileAvatar('$userImage',
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                onTap: () =>
                                    print("You Clicked sd his  Image")),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      print("You Are on the Profile");
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            userPro(context, "19ucs053"),
                                      );
                                    },
                                    child: Text("$userName")),
                                //FlatButton.icon(
                                //  onPressed: () => print("You Opened Edit"),
                                //icon: Icon(Icons.brightness_5_outlined),
                                //label: Text("."))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.45,
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.transparent, width: 15),
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage("$postImage"),
                            fit: BoxFit.fill,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: Wrap(
                        children: [
                          Text(
                            "$postComment",
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    //FlatButton.icon(
                    //  onPressed: () => print("You Liked"),
                    //  icon: Icon(Icons.favorite),
                    // label: Text("React"))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        FlutterReactionButtonCheck(
                          onReactionChanged: (reaction, index, isChecked) {
                            print('reaction selected index: $index');
                          },
                          //boxColor: Colors.transparent,
                          boxPosition: Position.BOTTOM,
                          boxItemsSpacing: 20,
                          boxAlignment: Alignment.topLeft,
                          boxRadius: 40,
                          reactions: <Reaction>[
                            Reaction(
                              previewIcon: Icon(
                                CupertinoIcons.hand_thumbsup,
                                color: Colors.black,
                                size: 30,
                              ),
                              icon: Icon(
                                CupertinoIcons.hand_thumbsup_fill,
                                color: Colors.red.shade500,
                                size: 30,
                              ),
                            ),
                            Reaction(
                              previewIcon: Icon(
                                CupertinoIcons.smiley,
                                color: Colors.black,
                                size: 30,
                              ),
                              icon: Icon(CupertinoIcons.smiley,
                                  color: Colors.red.shade900, size: 30),
                            ),
                            Reaction(
                                previewIcon: Icon(
                                  CupertinoIcons.hand_thumbsdown,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                icon: Icon(
                                  CupertinoIcons.hand_thumbsdown_fill,
                                  color: Colors.red.shade500,
                                  size: 30,
                                )),
                          ],
                          initialReaction: Reaction(
                            icon: Icon(
                              Icons.favorite_outline,
                              size: 30,
                            ),
                          ),
                          selectedReaction: Reaction(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ) // IconButton(
                        //  onPressed: () => print("Liked"),
                        // icon: Icon(Icons.thumb_up_off_alt_outlined)),
                        //IconButton(
                        //  onPressed: () => print("Disliked"),
                        //  icon: Icon(Icons.thumb_down_off_alt_outlined))
                      ],
                    )
                  ],
                ),
              );
            }),
      ),
      drawer: MyDrawer(),
    );
  }

  Future<bool> _exitApp() async {
    SystemNavigator.pop();
    return true;
  }

  add_post() {}
}
