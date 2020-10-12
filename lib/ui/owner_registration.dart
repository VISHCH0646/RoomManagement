import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_otp/flutter_otp.dart';

final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

class OwnerRegistration extends StatefulWidget {
  @override
  _OwnerRegistrationState createState() => _OwnerRegistrationState();
}
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class _OwnerRegistrationState extends State<OwnerRegistration> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
  var _phoneAuthCredential;
  var _fname,_lname,_email,_contact,_passw,_cpassw,_otp;
  var _session;
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _otp=new TextEditingController(text: "");
    _fname=new TextEditingController(text: "");
    _lname=new TextEditingController(text: "");
    _email=new TextEditingController(text: "");
    _contact=new TextEditingController(text: "");
    _passw=new TextEditingController(text: "");
    _cpassw=new TextEditingController(text: "");
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
          title: Text("Owner Registration"),
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
              padding: const EdgeInsets.only(top:12.0,bottom: 17.9),
              child: Text(
        "Register as Owner",
      style: TextStyle(
        fontSize: 40
      ),
    ),
            ),

            Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0,top: 16),
                        child: Container(
                          height: 60,
                          width: 170,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter First Name';
                              }
                              return null;
                            },
                             controller: _fname,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(hintText: "Enter First Name",labelText: "First Name",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                                  gapPadding: 3.3),
                            ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),]
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,top: 16.0),
                        child: Container(
                          height: 60,
                          width: 170,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Last Name';
                              }
                              return null;
                            },
                            controller: _lname,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(hintText: "Enter Last Name",labelText: "Last Name",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                                  gapPadding: 3.3),
                              //errorText: _lname.text==""?null:null
                            ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),]
                          ),
                        ),
                      )

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 16.0),
                    child: TextFormField(
                      validator: (value) {
                        var email = value;
                        bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
                        if(emailValid==false)
                        {
                          return "Enter Valid Email Id";
                        }
                        else{
                          return null;
                        }
                      },
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: "Enter Email Address",labelText: "Email Id",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                            gapPadding: 3.3),
                      //  errorText: _email.text==""?null:_validateEmail(_email.text),
                      ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(50),]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                    child: TextFormField(
                        validator: (value) {
                          if(value.length!=10){
                            return "Number should be of 10 digits";
                          }
                          return null;
                        },
                        controller: _contact,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        decoration: InputDecoration(hintText: "Enter Contact Number",labelText: "Contact Number",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        //  errorText: _password.text==""?null:_validatePassword(_password.text),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),WhitelistingTextInputFormatter.digitsOnly]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                    child: TextFormField(
                        validator: (value) {
                          if(value.length<6)
                          {
                            return "Password Length Should be Greater than 6";
                          }
                          return null;
                        },
                        controller: _passw,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Enter Password",labelText: "Password",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                       //   errorText: _password.text==""?null:_validatePassword(_password.text),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15),]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!=_passw.text) {
                          return 'Both the Password Fields should be Same';
                        }
                        return null;
                      },
                      controller: _cpassw,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Confirm Password",
                        labelText: "Confirm Password",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                            gapPadding: 3.3
                        ),
                      //  errorText: _cpassword.text==""?null:_validatePhone(_phone.text),
                      ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(15)]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20.0),
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 70,right: 70,top:15,bottom: 15),
                        child: Text("Register",style: TextStyle(fontSize: 15),),
                      ),
                      splashColor: Colors.black,
                      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(9),),
                      onPressed: (){
                          if(_fname.text.toString().isNotEmpty && _lname.text.toString().isNotEmpty
                          && _email.text.toString().isNotEmpty && _contact.text.toString().isNotEmpty &&
                           _passw.text.toString().isNotEmpty && _cpassw.text.toString().isNotEmpty) {
                            if (_formkey.currentState.validate()) {
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                    duration: new Duration(seconds: 5), content:
                                  new Row(
                                    children: <Widget>[
                                      new CircularProgressIndicator(),
                                      new Text(" Registering....")
                                    ],
                                  ),
                                  ));
                              var ownerDetails =
                              {
                                "name": _fname.text + " " + _lname.text,
                                "email": _email.text,
                                "contact": _contact.text,
                                "password": _passw.text
                              };
                              bool registered=null;

                                ref = database.reference().child("owners");
                                ref.reference()
                                    .child(_contact.text.toString())
                                    .once()
                                    .then((DataSnapshot snapshot) {
                                  Map<dynamic, dynamic> data = snapshot.value;
                                  try {
                                    data['contact'];
                                    _scaffoldKey.currentState.showSnackBar(
                                        new SnackBar(content: Text(
                                            "Already Registered with this Mobile Number!! Please Login")));
                                  }
                                  catch(e){
                                    print("catched");
                                    registered=false;
                                    ref.reference()
                                        .child(_contact.text.toString())
                                        .set(ownerDetails);

                                  }
                                  print("Hello");
                                  registered = true;

                                });
                              showDialog(context: context,
                                  builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text("Account Created"),
                                      content: Text("Please Login"),
                                      actions: <Widget>[
                                        FlatButton(
                                          onPressed: (){
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Ok",
                                            style: TextStyle(
                                                color: Colors.black
                                            ),),
                                        )
                                      ],
                                    );
                                  }
                              );
                            }
                          }
                          else{
                            _scaffoldKey.currentState.showSnackBar(
                                new SnackBar(content: Text(
                                    "Please Enter All Fields")));
                          }
                        }
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );


  }

  bool _phoneVerification() {
    _submitPhoneNumber();
    showDialog(context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text('Verify Phone Number: '+_contact.text.toString()),
          content: TextField(
            controller: _otp,
            keyboardType: TextInputType.number,
            obscureText: true,
          ),
          actions: <Widget>[
            RaisedButton(onPressed: (){
              return true;
            },
            child: Text("Verify"),
              color: Colors.black,
              textColor: Colors.white,
              elevation: 7,
            ),
            RaisedButton(onPressed: (){
              String codeEntered=_otp.text.toString();
              this._phoneAuthCredential=PhoneAuthProvider.getCredential(verificationId: this._session, smsCode: codeEntered);
              print(this._phoneAuthCredential);
               FirebaseAuth.instance
                  .signInWithCredential(this._phoneAuthCredential)
                  .then((AuthResult authRes) {
                    print('success');
                   return true;
              });
            },
              child: Text("Cancel"),
              color: Colors.black,
              textColor: Colors.white,
              elevation: 7,
            )
          ],
        );
      }

    );
  }
  void verificationCompleted(AuthCredential phoneAuthCredential) {
    print('verificationCompleted');
    this._phoneAuthCredential = phoneAuthCredential;
    print(phoneAuthCredential);
  }
  Future<void> _submitPhoneNumber() async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91 " + _contact.text.toString().trim();
    print(phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable


    void verificationFailed(AuthException error) {
      print(error.message);
    }

    void codeSent(String verificationId, [int code]) {
      this._session=verificationId;
      print('codeSent');
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 10000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
     // verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );// All the callbacks are above
  }


}
