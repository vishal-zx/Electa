import 'package:electa/pages/changePassword.dart';
import 'package:electa/pages/editProfile.dart';
import 'package:electa/pages/hns.dart';
import 'package:electa/pages/login.dart';
import 'package:electa/pages/myAccount.dart';
import 'package:electa/pages/register.dart';
import 'package:electa/pages/result.dart';
import 'package:electa/pages/vote.dart';
import 'package:electa/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/home.dart';
import 'package:flutter/services.dart';

void main(){
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      // home: Home(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: GoogleFonts.lato().fontFamily,
        // primaryTextTheme: GoogleFonts.latoTextTheme()
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.loginRoute,
      routes: {
        MyRoutes.loginRoute : (context) => LoginPage(),
        MyRoutes.registerRoute : (context) => Register(),
        MyRoutes.homeRoute : (context) => Home(),
        MyRoutes.voteRoute : (context) => Vote(),
        MyRoutes.resultRoute : (context) => ResultScreen(),
        MyRoutes.myAccountRoute : (context) => MyAccount(),
        MyRoutes.changePswdRoute : (context) => ChangePswd(),
        MyRoutes.hNSRoute : (context) => HelpNSupport(),
        MyRoutes.editProfileRoute : (context) => EditProfile(),
      },
    );
  }
}