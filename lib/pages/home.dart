// ignore: import_of_legacy_library_into_null_safe
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:electa/utils/routes.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<bool> _exitApp() async{
    SystemNavigator.pop();
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Electa"),
        elevation: 10,
      ),
      body: WillPopScope(
        onWillPop: _exitApp,
        child: ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              var postImage = "https://picsum.photos/200";
              var userName = "Poojan Gadhiya";
              var postComment =
                  "If You Want To Save Water, Take a bath with your neighbour's daughter. But She Dosent likes me: if she ignores you, her mother is you should pursue.";
              var userImage = "https://imgshare.io/images/2021/06/30/poojan.png";
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.98,
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
                                    print("You Clicked his Profile Image")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  print("You Are on the Profile");
                                  Navigator.pushNamed(
                                      context, MyRoutes.userProfileRoute);
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage("$postImage"),
                              fit: BoxFit.fill)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                      child: Wrap(
                        children: [
                          Flexible(
                            child: Text(
                              "$postComment",
                              maxLines: 3,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
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
                          boxItemsSpacing: 50,
                          boxAlignment: Alignment.topLeft,
                          boxRadius: 50,
                          reactions: <Reaction>[
                            Reaction(
                              previewIcon: Icon(
                                CupertinoIcons.hand_thumbsup,
                                color: Colors.black,
                                size: 30,
                              ),
                              icon: Icon(
                                CupertinoIcons.hand_thumbsup_fill,
                                color: Colors.red.shade200,
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
                                  color: Colors.red.shade200,
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

  // Container _getPost() {
  //   final postComment =
  //       "Vote Me , I am You , And You Are Me. Every Concern Will be respected";
  //   //var username = "poojan_gadhiya";
  //   final userImage = 'https://imgshare.io/images/2021/06/30/poojan.png';
  //   final postImage = 'https://source.unsplash.com/random';
  //   var userName = "Poojan Gadhiya";
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.6,
  //     width: MediaQuery.of(context).size.width * 0.98,
  //     decoration: BoxDecoration(
  //         color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
  //     child: Column(
  //       children: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 CircularProfileAvatar('$userImage',
  //                     radius: 15,
  //                     backgroundColor: Colors.transparent,
  //                     onTap: () => print("You Clicked his Profile Image")),
  //               ],
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 TextButton(
  //                     onPressed: () {
  //                       print("You Are on the Profile");
  //                       Navigator.pushNamed(context, MyRoutes.userProfileRoute);
  //                     },
  //                     child: Text("$userName")),
  //                 //FlatButton.icon(
  //                 //  onPressed: () => print("You Opened Edit"),
  //                 //icon: Icon(Icons.brightness_5_outlined),
  //                 //label: Text("."))
  //               ],
  //             ),
  //           ],
  //         ),
  //         Container(
  //           height: MediaQuery.of(context).size.height * 0.4,
  //           width: MediaQuery.of(context).size.width,
  //           decoration: BoxDecoration(
  //               image: DecorationImage(
  //                   image: NetworkImage("$postImage"), fit: BoxFit.fill)),
  //         ),
  //         Container(
  //           padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
  //           child: Wrap(
  //             children: [
  //               Text(
  //                 "$postComment",
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                   fontStyle: FontStyle.normal,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         ),
  //         //FlatButton.icon(
  //         //  onPressed: () => print("You Liked"),
  //         //  icon: Icon(Icons.favorite),
  //         // label: Text("React"))
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: <Widget>[
  //             FlutterReactionButtonCheck(
  //               onReactionChanged: (reaction, index, isChecked) {
  //                 print('reaction selected index: $index');
  //               },
  //               //boxColor: Colors.transparent,
  //               boxPosition: Position.BOTTOM,
  //               boxItemsSpacing: 50,
  //               boxAlignment: Alignment.topLeft,
  //               boxRadius: 50,
  //               reactions: <Reaction>[
  //                 Reaction(
  //                   previewIcon: Icon(
  //                     CupertinoIcons.hand_thumbsup,
  //                     color: Colors.black,
  //                     size: 30,
  //                   ),
  //                   icon: Icon(
  //                     CupertinoIcons.hand_thumbsup_fill,
  //                     color: Colors.red.shade200,
  //                     size: 30,
  //                   ),
  //                 ),
  //                 Reaction(
  //                   previewIcon: Icon(
  //                     CupertinoIcons.smiley,
  //                     color: Colors.black,
  //                     size: 30,
  //                   ),
  //                   icon: Icon(CupertinoIcons.smiley,
  //                       color: Colors.red.shade900, size: 30),
  //                 ),
  //                 Reaction(
  //                     previewIcon: Icon(
  //                       CupertinoIcons.hand_thumbsdown,
  //                       color: Colors.black,
  //                       size: 30,
  //                     ),
  //                     icon: Icon(
  //                       CupertinoIcons.hand_thumbsdown_fill,
  //                       color: Colors.red.shade200,
  //                       size: 30,
  //                     )),
  //               ],
  //               initialReaction: Reaction(
  //                 icon: Icon(
  //                   Icons.favorite_outline,
  //                   size: 30,
  //                 ),
  //               ),
  //               selectedReaction: Reaction(
  //                 icon: Icon(
  //                   Icons.favorite,
  //                   color: Colors.red,
  //                   size: 30,
  //                 ),
  //               ),
  //             ) // IconButton(
  //             //  onPressed: () => print("Liked"),
  //             // icon: Icon(Icons.thumb_up_off_alt_outlined)),
  //             //IconButton(
  //             //  onPressed: () => print("Disliked"),
  //             //  icon: Icon(Icons.thumb_down_off_alt_outlined))
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  buildWidget({required String icon}) {}

  buildWidgetPreview({required String icon}) {}
}
