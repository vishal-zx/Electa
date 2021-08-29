import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPost> {
  var roll = FirebaseAuth.instance.currentUser!.email!.substring(0,8).toUpperCase();

  SnackBar makeBar(String text){
    final snackBar = SnackBar(
      duration: Duration(milliseconds: (text=="Loading...")?700:3500),
      content: Text('$text', textAlign: TextAlign.center, 
        style: TextStyle(fontSize: 14),
      ),
      backgroundColor: Colors.black87.withOpacity(1),
      elevation: 3,
      padding: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
    );
    return snackBar;
  }

 SnackBar error = SnackBar(content: Text(""));

  File pickedImage = new File("");
  bool isUploading = false;
  bool isUploaded = false; 
  bool isPosting = false; 
  String comment = ""; 

  _loadPicker() async{
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted){
      XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(picked!=null){
        _cropImage(picked, context);
      }else {
        error = makeBar('No Image Selected');
        ScaffoldMessenger.of(context).showSnackBar(error);
      }
    }else {
      error = makeBar('Permission not granted. Try Again with permission access');
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  _cropImage(XFile picked, BuildContext context) async{
    File? cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.black,
        toolbarColor: Colors.black,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      compressQuality: 50,
      sourcePath: picked.path,
      aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        maxWidth: 1200,
    );
    if(cropped !=null){
      setState(() {
        pickedImage = cropped;
      });
    }
  }

  void upload(File pickedImg) async{
    if(pickedImg.path!=""){
      setState(() {
        isUploading = true;
        isUploaded = true;
      });
      final _firebaseStorage = FirebaseStorage.instance;
      var time = DateTime.now();
      var imgName = roll+"-"+time.toString().substring(0,20)+"000";
      isUploading = true;
      UploadTask uploadTask = _firebaseStorage.ref().child('postImages/$imgName.png').putFile(pickedImg);
      var downloadUrl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();
      setState(() {      
        FirebaseFirestore.instance.collection('posts').add({
          'img_url' : downloadUrl,
          'comment' : comment,
          'user' : roll,
          'time' : time,
          'reactions' : {},
          'likes' : 0,
        }).then((value){
          isUploading = false;
          isPosting = false;
        });
        Future.delayed(const Duration(milliseconds: 1000), (){
          ScaffoldMessenger.of(context).showSnackBar(makeBar("Posting ..."));
        });
      });
      Future.delayed(const Duration(milliseconds: 3000), (){
        ScaffoldMessenger.of(context).showSnackBar(makeBar("Post Added !! 🔥"));
        setState(() {
          isUploading = false;
          isPosting = false;
        });
        Future.delayed(const Duration(milliseconds: 4000), (){
          Navigator.of(context).pop();
        });
      });
    }
    else{
      error = makeBar('First select an image!');
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: mq.height,
          padding: EdgeInsets.symmetric(vertical: mq.height*0.03, horizontal: mq.width*0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Image",
                style: TextStyle(
                  fontSize: 20,
                )
              ),
              SizedBox(
                height: mq.height*0.02,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.width*((pickedImage.path!="")?0.9:0.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: (pickedImage.path!="")?Image.file(pickedImage).image:Image.asset('assets/images/imgbg.png').image,
                      )
                    ),
                  ),
                  if(pickedImage.path=="")
                    Positioned(
                      left: mq.width*0.318,
                      right: mq.width*0.288,
                      child: TextButton(
                        onPressed: (){
                          _loadPicker();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.8)),
                          padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(color: Colors.black87)
                            )
                          )
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              color: Colors.white,
                            ),
                            Text(
                              "  Add Photo",
                              style: TextStyle(
                                color: Colors.white,
                              )
                            )
                          ],
                        )
                      ),
                    ),
                  if(isUploading == true)
                    SpinKitCircle(
                      color: Colors.black,
                      size: 50.0,
                      duration: Duration(seconds: 5), 
                    ),
                ],
              ),
              if(pickedImage.path!="")
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      setState(() {
                        isUploading = false;
                        isUploaded = false;
                        pickedImage = new File("");
                      });
                    },
                    child: Text(
                      "Remove Image",
                      style: TextStyle(
                        color: Colors.red,
                      )
                    ),
                  ),
                ),
              if(pickedImage.path=="")
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.01,
                ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: mq.height*0.03,
              ),
              Text(
                "Add a caption",
                style: TextStyle(
                  fontSize: 20,
                )
              ),
              SizedBox(
                height: mq.height*0.02,
              ),
              TextField(
                maxLines: 3,
                maxLength: 100,
                decoration: InputDecoration.collapsed(hintText: "Something about your post ..."),
                onChanged: (value){
                  comment = value;
                  if(value == "") comment = "";
                },
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: mq.height*0.02,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: (){
                    if(isPosting == false) {
                      isPosting = true;
                      upload(pickedImage);}
                  }, 
                  child: Text("Post"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all((isPosting==true)?Colors.black54:Colors.black),
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
