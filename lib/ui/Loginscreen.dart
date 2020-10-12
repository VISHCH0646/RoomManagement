import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pg/ui/home.dart';
import 'package:flutter_app_pg/ui/owner_login.dart';
import 'package:flutter_app_pg/ui/signin_email.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final GoogleSignIn _googleSignIn=new GoogleSignIn();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    //for Orientation modify this code

    Widget content;
   // var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;
    if(orientation==Orientation.portrait){
      content=ifPortrait();
    }
    else{
      content=Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: Icon(Icons.warning,size: 70,color: Colors.red.shade700,),
          ),
          Text("We do not Support LandScape mode as of now!!!",style: TextStyle(fontSize: 20),),
          Text("Please Switch to Portrait Mode",style: TextStyle(fontSize: 20),)
        ],
      ));
      if (Vibration.hasVibrator() != null) {
        Vibration.vibrate();
      }
    }


    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,//Color.fromRGBO(225, 245, 254, 40),//Color.fromRGBO(255, 235, 238, 40),
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.black,
      ),
      body: content
    );


  }
  Widget ifPortrait(){
    return ListView(
      children:[
        Padding(
          padding: const EdgeInsets.only(top:12.0,bottom: 28.0),
          child: Container(
            child:Image.asset("images/logologin.png",height: 230,width: 230,)
          ),
        )
        ,Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:18.0,right: 25,left: 25),
              child: FlatButton(


                //google signin Code>>>>>


                onPressed: (){_gSignIn();},
                autofocus: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6,left: 6,top: 21,bottom: 21),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 24.0),
                        child:Image.asset("images/google.png",width: 40,height: 40,),
                      ),
                      Text("Sign in Using Google",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            color: Colors.black54

                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black)
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:18.0,right: 25,left: 25),
              child: FlatButton(


                //Sign in using email code>>>


                onPressed: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
                    return new SigninEmail();
                  }));
                },
                autofocus: true,
                child: Padding(
                  padding: const EdgeInsets.only(right: 6,left: 6,top: 21,bottom: 21),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 24.0),
                        child:Icon(Icons.email,size: 34,),
                      ),
                      Text("Sign in Using Email",
                        style: TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontStyle: FontStyle.normal,
                            color: Colors.black54
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.black)
                ),

              ),
            ),
//            Padding(
//              padding: const EdgeInsets.only(top: 24),
//              child: InkWell(
//                child: Text("New User?  Create Account",
//                style: TextStyle(
//                  fontStyle: FontStyle.italic,
//                  fontFamily: String.fromCharCode(8),
//                  fontSize: 17
//                ),),
//
//
//                //create Account>>>>>
//
//
//                onTap: ()=>launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html'),
//              ),
//            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Text("OR"),
                ),
                InkWell(
                  child: Text("Continue as Guest->",
                    style: TextStyle(
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      fontFamily: String.fromCharCode(10),
                    ),
                  ),

                  //continue as guest event Code

                  onTap: (){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home(useremail: null,guest: true)),
                          (Route<dynamic> route) => false,
                    );
                  },
                )
              ],
            )
          ],
        ),
      ),
        Padding(
          padding: const EdgeInsets.only(right:8.0,left: 8.0,top: 70.0),
          child: Container(
            color: Colors.black,
           // ,margin: const EdgeInsets.symmetric(vertical: 14.0),
            width: 0,
            height: 1.0,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(
                "Have Property to List?",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:3.0),
              child: InkWell(
                child: Text(
                  "Login/Sign Up Here",
                  style: TextStyle(
                    fontSize: 15
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
                    return new OwnerLogin();
                  }));

                },//owner Login>>>>>>>>
              ),
            )
          ],
        )
    ]
    );
  }

  _gSignIn() async{
    try {
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final FirebaseUser user = (await _firebaseAuth.signInWithCredential(
          credential)).user;
      print("Email:  ${user.email}\nName:${user.displayName}  ${user
          .isEmailVerified}\n");
      SharedPreferences preferences=await SharedPreferences.getInstance();
      preferences.setString("login_user", user.email);
      var UserData={
        "name":user.displayName,
        "contact":user.phoneNumber,
        "email":user.email,
        "provider":"google"
      };
      FirebaseDatabase database=FirebaseDatabase.instance;
      database.reference().child('users').child(user.uid).set(UserData);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home(useremail: user.email,guest: null)),
            (Route<dynamic> route) => false,
      );
    }
    catch(e){
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text(
              "Something Not Right!! Please try Later")));

    }
  }
}
