import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  AddPostState createState() => AddPostState();
}

class AddPostState extends State<AddPost> {

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
  bool _rollPresent = false;
  String imageUrl="";

  _loadPicker() async{
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted){
      XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(picked!=null){
        _cropImage(picked);
      }else {
        error = makeBar('No Image Selected');
        ScaffoldMessenger.of(context).showSnackBar(error);
      }
    }else {
      error = makeBar('Permission not granted. Try Again with permission access');
      ScaffoldMessenger.of(context).showSnackBar(error);
    }
  }

  _cropImage(XFile picked) async{
    File? cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.black,
        toolbarColor: Colors.black,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [
          CropAspectRatioPreset.square
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
      final _firebaseStorage = FirebaseStorage.instance;
      isUploading = true;
      UploadTask uploadTask = _firebaseStorage.ref().child('userImages/a.png').putFile(pickedImg);
      var downloadUrl = await (await uploadTask.whenComplete(() => null)).ref.getDownloadURL();

      setState(() {
        imageUrl = downloadUrl;
        isUploading = false;
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
      body: Container(
        height: mq.height*0.7,
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
            Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: MediaQuery.of(context).size.height*0.25,
              child: (imageUrl != "")?Image.network(imageUrl):
              Image.asset('assets/images/imgbg.png', fit: BoxFit.contain,)
            ),
            SizedBox(
              height: mq.height*0.02,
            ),
            // TextField(
            //   maxLines: null,
            //   keyboardType: TextInputType.multiline,
            // ),
            ElevatedButton(
              onPressed: (){
                _loadPicker();
              }, 
              child: Padding(
                padding: EdgeInsets.fromLTRB(2, 12, 2, 12),
                child: Text("1.   Select Image",
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.black87)
                  )
                )
              ),
            ),
            ElevatedButton(
              onPressed: (){
                upload(pickedImage);
              }, 
              child: Padding(
                padding: EdgeInsets.fromLTRB(2, 12, 2, 12),
                child: Text("2.   Upload Image",
                  style: TextStyle(
                    fontSize: 12
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  (isUploading==true)?Colors.grey:Colors.black),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.black)
                  )
                )
              ),
            ),
            ElevatedButton(
              onPressed: (){

              }, 
              child: Text("Post")
            ),
          ],
        ),
      ),
    );
  }
}
