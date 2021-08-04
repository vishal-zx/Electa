import 'package:electa/pages/changePassword.dart';
import 'package:electa/pages/editProfile.dart';
import 'package:electa/pages/hns.dart';
import 'package:electa/pages/login.dart';
import 'package:electa/pages/myAccount.dart';
import 'package:electa/pages/register.dart';
import 'package:electa/pages/results.dart';
import 'package:electa/pages/userProfile.dart';
import 'package:electa/pages/vote.dart';
import 'package:electa/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

String route = MyRoutes.loginRoute;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  route = (email==null)? MyRoutes.loginRoute : MyRoutes.homeRoute;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    if(_error) {
      return Container();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Container();
    }
    
    return MaterialApp(
      // home: Home(),
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        fontFamily: GoogleFonts.lato().fontFamily,
        // primaryTextTheme: GoogleFonts.latoTextTheme()
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: route,
      routes: {
        MyRoutes.loginRoute : (context) => LoginPage(),
        MyRoutes.registerRoute : (context) => Register(),
        MyRoutes.homeRoute : (context) => Home(),
        MyRoutes.voteRoute : (context) => Vote(),
        MyRoutes.resultRoute : (context) => Result(),
        MyRoutes.myAccountRoute : (context) => MyAccount(),
        MyRoutes.changePswdRoute : (context) => ChangePswd(),
        MyRoutes.hNSRoute : (context) => HelpNSupport(),
        MyRoutes.editProfileRoute : (context) => EditProfile(),
      },
    );
  }
}