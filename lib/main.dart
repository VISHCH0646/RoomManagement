
import 'package:flutter_app_pg/ui/home.dart';
import 'package:flutter_app_pg/ui/owner_dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pg/ui/Loginscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
final version='0.1.1';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  String type;
  String user;
    SharedPreferences preferences=await SharedPreferences.getInstance();
    if(preferences.getString("login_user")!=null&&preferences.getString("login_user").isNotEmpty  ){
     type="user";
     user=preferences.getString("login_user");
    }
    else if(preferences.getString("Owner_session")!=null&&preferences.getString("Owner_session").isNotEmpty){
      type='owner';
    }
    else
      {
        type=null;
        user=null;
      }
  Hello() {
    if (type == "owner") {
      return OwnerDashboard();
    }
    else if (type == "user") {
      return Home(useremail: user,);
    }
    else {
      return LoginScreen();
    }
  }

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title:"Pg Finder",
    home:SplashScreen(
        seconds: 3,
        navigateAfterSeconds:Hello(),//yes==false?LoginScreen():Home(useremail: user),
        title: Text("Rentals",style: GoogleFonts.aldrich(fontSize: 20,color: Colors.white)),
        image:  Image.asset('icon/logo.png',height: 180,width: 180,color: Colors.white,),
        backgroundColor: Colors.black,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        loaderColor: Colors.white
    ),
  ));




}




//class SplashScree extends StatefulWidget {
//  SharedPreferences pref;
//
//
//  @override
//  _SplashScreeState createState() => _SplashScreeState();
//}
//
//class _SplashScreeState extends State<SplashScree> {
//
//
//  void initState() {
//    //SharedPreferences pref=await SharedPreferences.getInstance();
//   // var email=pref.getString("login_user");
//    super.initState();
//    Timer(
//        Duration(seconds: 3),
//            () =>
//            Navigator.of(context).pushReplacement(MaterialPageRoute(
//                builder: (BuildContext context) =>email!=null&&email.isNotEmpty?Home(useremail: email):LoginScreen())));
//  }
//  @override
//  Widget build(BuildContext context) {
//
//  }
//
//  WhichPage() {
//    //SharedPreferences preferences= SharedPreferences.getInstance() as SharedPreferences;
////  if(preferences.getString("login_user").isNotEmpty && preferences.getString("login_user")!=null)
////    {
////          return Home(useremail: preferences.getString("login_user"),);
////    }
// // else
//    return LoginScreen();
//
//
//  }
//
//  SharedPreferences ispref() {
//    SharedPreferences preferences=SharedPreferences.getInstance() as SharedPreferences;
//    return preferences;
//  }


//}
