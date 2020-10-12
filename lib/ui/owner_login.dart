import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pg/ui/owner_dashboard.dart';
import 'package:flutter_app_pg/ui/owner_registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;


class OwnerLogin extends StatefulWidget {
  @override
  _OwnerLoginState createState() => _OwnerLoginState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


class _OwnerLoginState extends State<OwnerLogin> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
  var _uname,_passw;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _uname=TextEditingController(text: "");
    _passw=TextEditingController(text: "");
  }
  @override
  Widget build(BuildContext context) {

    Widget content;

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
          title: Text("Owner Login"),
          backgroundColor: Colors.black,
        ),
        body: content
    );
  }

  Widget ifPortrait() {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:20.0),
              child: Text(
                "Login As Owner",
                style: TextStyle(
                  fontSize: 40
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:26.0),
              child: Container(
                height: 60,
                width: 320,
                child: TextField(
                  controller: _uname,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: "Enter Username",labelText: "UserName",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 3.3),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
              child: Container(
                height: 60,
                width: 320,
                child: TextField(
                    controller: _passw,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Enter Password",labelText: "Password",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                    )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:25.0),
              child: FlatButton(
                textColor: Colors.white,
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(left: 70,right: 70,top:15,bottom: 15),
                  child: Text("Login  ->",style: TextStyle(fontSize: 15),),
                ),
                splashColor: Colors.black,
                shape: OutlineInputBorder(borderRadius: BorderRadius.circular(9),),
                onPressed: ()
                {
                 ref=database.reference().child("owners");
                 try {
                   ref.reference().child(_uname.text.toString()).once().then((
                       DataSnapshot snapshot) {
                     Map<dynamic, dynamic> data = snapshot.value;
                     try {
                       String passw = data['password'];
                       if (passw == _passw.text.toString()) {
                         _saveowner(_uname.text);
                         Navigator.pushAndRemoveUntil(
                           context,
                           MaterialPageRoute(
                               builder: (context) => OwnerDashboard()),
                               (Route<dynamic> route) => false,
                         );
                       }
                       else {
                         _scaffoldKey.currentState.showSnackBar(
                             new SnackBar(content: Text(
                                 "Incorrect Password!!!")));
                       }
                     }
                     catch (e) {
                       _scaffoldKey.currentState.showSnackBar(
                           new SnackBar(content: Text(
                               "Not a Registered Mobile Number!!!")));
                     }
                   });
                 }catch(e){
                   _scaffoldKey.currentState.showSnackBar(
                       new SnackBar(content: Text(
                           "Please check the credentials!!!")));

                 }

                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 21.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("New Owner?",
                    style: TextStyle(
                        fontSize: 16
                    ),
                  ),
                  InkWell(
                    child: Text(" Register Here",
                    style: TextStyle(
                      fontSize: 16
                    ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(builder: (BuildContext context) {
                            return new OwnerRegistration();
                          }));
                    },
                  )
                ],
              ),
            )

          ],
        )
      ],
    );
  }

  void _saveowner(text)async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString("Owner_session", text);
    print(text);

  }
}
