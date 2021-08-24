// ignore: import_of_legacy_library_into_null_safe
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electa/pages/userProfile.dart';
import 'package:electa/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class Post{
  var userImg;
  var userRoll;
  var userName;
  var postImg;
  var caption;
  var time;

  Post(this.userImg, this.userName, this.userRoll, this.postImg, this.caption, this.time);
}


class _HomeState extends State<Home> {

  Container buildPost(Post p){
    var datTim = DateTime.fromMillisecondsSinceEpoch(p.time.seconds * 1000);
    return Container(
      height: MediaQuery.of(context).size.height * 0.63,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15)
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.height*0.045,
                    height: MediaQuery.of(context).size.height*0.045,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: p.userImg,
                        progressIndicatorBuilder: (context, url, downloadProgress) => 
                                CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/u1.png")),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.01,
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) 
                        {
                          return userPro(context, p.userRoll);
                        },
                      );
                    },
                    child: Text(
                      p.userName,
                      style:TextStyle(
                        fontSize:18,
                      )
                    )
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "at ${datTim.hour.toString().padLeft(2,'0')}:${datTim.minute.toString().padLeft(2,'0')}, ${datTim.day.toString().padLeft(2,'0')}/${datTim.month.toString().padLeft(2,'0')}/${datTim.year.toString()}",
                    // p.time.toString(),
                    style:TextStyle(
                      fontSize:12,
                      color:Colors.black,
                    )
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.02,
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.width * 0.9,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: p.postImg,
                progressIndicatorBuilder: (context, url, downloadProgress) => 
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          ),
                        ),
                errorWidget: (context, url, error) => Image(image: AssetImage("assets/images/imgbg.png")),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Wrap(
              children: [
                Text(
                  p.caption,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FlutterReactionButtonCheck(
                onReactionChanged: (reaction, index, isChecked) {
                },
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
              )
            ],
          )
        ],
      ),
    );
  }

  List<Post> postArray = [];

  Future<bool> _exitApp() async {
    SystemNavigator.pop();
    return true;
  }

  Future<void> getPosts() async{
    QuerySnapshot qs = await FirebaseFirestore.instance.collection('posts').orderBy('time', descending: true).get();
    var posts = qs.docs;
    for(var post in posts){
      Map<String, dynamic> data = post.data() as Map<String, dynamic>;
      QuerySnapshot userqs = await FirebaseFirestore.instance.collection('users').where('Roll', isEqualTo: data['user'].toUpperCase()).get();
      var user = userqs.docs[0];
       Map<String, dynamic> userInfo = user.data() as Map<String, dynamic>;
      Post p = new Post(userInfo['imageUrl'], userInfo['Name'], userInfo['Roll'].toUpperCase(),  data['img_url'], data['comment'], data['time']);
      postArray.add(p);
    }
  }
  bool allRight = false;

  @override
  void initState() {
    if(postArray.length == 0){
      getPosts().then((val){
        setState((){
          allRight = true;
        });
      });
    }
    else{
      allRight = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Electa"),
          elevation: 10,
        ),
        body: WillPopScope(
          onWillPop: _exitApp,
          child: SingleChildScrollView(
            child: 
            (allRight == false)?
            Center(
              heightFactor: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitRotatingPlain(
                    color: Colors.grey,
                    size: 50.0,
                    duration: Duration(seconds: 2),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.01,
                  ),
                  Text(
                    "Loading Data ...",
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white
                    )
                  ),
                ],
              ),
            ):
            Column(
              children: [
                for(int i=0;i<postArray.length;i++)
                  buildPost(postArray[i]),
              ],
            ),
          )
        ),
        drawer: MyDrawer(),
      )
    );
  }
}
