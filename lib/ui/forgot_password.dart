import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var _emailid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("In init method");
    _emailid=new TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {


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
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Colors.black,
      ),
      body: content,
    );
  }

  Widget ifPortrait() {

    return Column(

      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top:18.0),
          child: Text("Recover Password",
      style:TextStyle(
          fontSize: 32
      ) ,
    ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:29.0,left: 10,right: 10),
          child: TextField(
            controller: _emailid,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "Enter Email",labelText: "Email",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                  gapPadding: 3.3),
              errorText: _emailid.text==""?null:_validateEmail(_emailid.text),
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
              child: Text("Get Reset Link",style: TextStyle(fontSize: 15),),
            ),
            splashColor: Colors.black,
            shape: OutlineInputBorder(borderRadius: BorderRadius.circular(9),),
            onPressed: (){

              _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(duration: new Duration(seconds: 4), content:
                  new Row(
                    children: <Widget>[
                      new CircularProgressIndicator(),
                      new Text(" Sending Link...")
                    ],
                  ),
                  ));
                  _resetLink(_emailid.text)
                    .whenComplete((){
                      Navigator.of(context).pop();
                  });


            },
          ),
        ),
      ],

    );
  }

   _resetLink(String email)async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      switch(e.error){
        case 'ERROR_INVALID_EMAIL':
          _scaffoldKey.currentState.showSnackBar(
              new SnackBar(content: Text(
                  "Invalid Email!! Please Check Email")));
          break;
      }
    }
    //return user;

  }
  String _validateEmail(String em) {
    var email = em;
    bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (emailValid == false) {
      return "Enter Valid Email Id";
    }
    else {
      return null;
    }
  }
}
