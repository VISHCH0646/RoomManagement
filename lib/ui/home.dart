import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app_pg/model/version.dart';
import 'package:flutter_app_pg/ui/Loginscreen.dart';
import 'package:flutter_app_pg/ui/Search/result.dart';
import 'package:flutter_app_pg/ui/Search/searchbar.dart';
import 'package:flutter_app_pg/ui/profile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
var _isGst;
ProgressDialog pr;


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState(useremail:useremail,guest: guest);
  final String useremail;
  final bool guest;

  Home({this.useremail,this.guest});
}

class _HomeState extends State<Home> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
  var _selectedIndex;
  final String useremail;
  final bool guest;
  bool _proceed=true;

  _HomeState( {this.useremail, this.guest} );

  @override
  void initState( ) {
    // TODO: implement initState
    super.initState();
    pr = new ProgressDialog(
        context, showLogs: true, type: ProgressDialogType.Normal,isDismissible: false);
    pr.style(
        message: 'Please Wait..',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInCubic,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    Future.delayed(Duration(milliseconds: 100)).then((_) {
      pr.show();
      database.reference().once().then((DataSnapshot snapshot){
        Map<dynamic,dynamic> data=snapshot.value;
        if(data['version'].toString()!=Version.version){
          _proceed=false;
          Navigator.pop(context);
          showDialog(context:context,
              barrierDismissible: false,
              builder: (BuildContext context){
                return WillPopScope(
                  onWillPop: (){},
                  child: AlertDialog(
                    title: new Text("Update Available"),
                    content: new Text("Please Update the app for more features..."),
                    actions: <Widget>[
                      // usually buttons at the bottom of the dialog
                      new FlatButton(
                        child: new Text("OK"),
                        onPressed: () {
                          exit(0);
                        },
                      ),
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          exit(0);
                        },
                      ),
                    ],
                  ),
                );
              }
          );
        }
      });
      Future.delayed(Duration(seconds: 4)).then((_) {
        pr.dismiss();
        pr.dismiss();
      });
    //_isGuest();
  });
  }


  @override
  Widget build( BuildContext context ) {
    Widget content;
    // var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery
        .of(context)
        .orientation;
    if (orientation == Orientation.portrait) {
      content = ifProtrait();
    }
    else {
      content = Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Icon(Icons.warning, size: 70, color: Colors.red.shade700,),
          ),
          Text("We do not Support LandScape mode as of now!!!",
            style: TextStyle(fontSize: 20),),
          Text(
            "Please Switch to Portrait Mode", style: TextStyle(fontSize: 20),)
        ],
      ));
      if (Vibration.hasVibrator() != null) {
        Vibration.vibrate();
      }
    }


    return Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
        title: Text("Home Page"),
        backgroundColor: Colors.black,
      ),
      drawer: MediaQuery
          .of(context)
          .orientation == Orientation.portrait ? _drawerItems() : null,
      body: content,
      bottomNavigationBar: new BottomNavigationBar(items: [
        new BottomNavigationBarItem(icon: new Icon(Icons.home,color: Colors.white,),title: new Text("Home",style: TSTYLE(),)),
        new BottomNavigationBarItem(icon: new Icon(Icons.search,color: Colors.white),title: new Text("Search",style: TSTYLE(),)),
        new BottomNavigationBarItem(icon: new Icon(Icons.notifications,color: Colors.white),title: new Text("Notifications",style: TSTYLE(),))
      ],onTap: (int i){
        switch(i){
          case 0:
            print("Home");break;
          case 1:
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
              return SearchBar();
            }));
            break;

        }
      },
        backgroundColor: Colors.black,
      ),

    );
  }

  Widget ifProtrait( ) {
    return ListView(
      children: <Widget>[
        Container(height: 180,
        width: 30,
        ),
    Padding(padding: const EdgeInsets.only(top: 1.0),
    child: SizedBox.fromSize(
    size: new Size.fromHeight(100.0),
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
         Cities("Gangtok","images/Gangtok.jpg"),
        Cities("Rangpo","images/Rangpo.jpg"),
        Cities("Singtam","images/Singtam.jpg"),
        Cities("Majitar","images/Majitar.jpg")
      ],
    )
    ) ,
    ),
      ]
    );
  }

  _signOut( ) async {
    _firebaseAuth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("login_user", null);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: ( context ) => LoginScreen()),
          ( Route<dynamic> route ) => false,
    );
  }

  Widget _drawerItems( ) {
    if (MediaQuery
        .of(context)
        .orientation == Orientation.portrait) {
      return Drawer(
        child: ListView(
            children: <Widget>[ Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: InkWell(child: Text(
                      "Hello, ${useremail == null ? "Guest" : useremail}"),
//                    onTap:(){
//                      Navigator.of(context).pop();
//                      Navigator.of(context).push(
//                          new MaterialPageRoute(builder: (BuildContext context) {
//                            return new ProfileDetails();
//                          }));
//                    },
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  currentAccountPicture: InkWell(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_outline, color: Colors.black),
                    ),
//                    onTap:(){
//                      Navigator.of(context).pop();
//                      Navigator.of(context).push(
//                          new MaterialPageRoute(builder: (BuildContext context) {
//                            return new ProfileDetails();
//                          }));
//                    },
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.perm_identity),
                    title: Text("Profile"),
                    onTap: ( ) {
                      if (guest != null) {
                        //  _scaffoldKey.currentState.showSnackBar(
//                          new SnackBar(content: Text(
//                              "Please Login/Register")));
                        print('Please Login/Register');
                        showDialog(context: context,
                            builder: ( BuildContext context ) {
                              return AlertDialog(
                                title: Text("Please Login/Register"),
                                content: Text("Redirecting to Login Page...."),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: ( ) {
                                      Navigator.of(context).pop();
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: ( context ) =>
                                                LoginScreen()),
                                            ( Route<dynamic> route ) => false,
                                      );
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
                      else {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                            new MaterialPageRoute(
                                builder: ( BuildContext context ) {
                                  return new ProfileDetails();
                                }));
                      }
                    }
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text("Saved Properties"),
                  onTap: ( ) async {},
                ),
                ListTile(
                  leading: Icon(Icons.contact_phone),
                  title: Text("Contact Us"),
                  onTap: ( ) {},
                ),
                ListTile(
                  leading: Icon(Icons.business_center),
                  title: Text("About Us"),
                  onTap: ( ) {},
                ),
                ListTile(
                  leading: guest == null ? Icon(Icons.exit_to_app) : Icon(
                      Icons.input),
                  title: guest == null ? Text("LogOut") : Text(
                      "Login/Register"),
                  onTap: ( ) {
                    if (guest == null) {
                      showDialog(context: context,
                          builder: ( BuildContext context ) {
                            return AlertDialog(
                              title: Text("Logout"),
                              content: Text("Logging You Out...."),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: ( ) => _signOut(),
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
                    else {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: ( context ) => LoginScreen()),
                            ( Route<dynamic> route ) => false,
                      );
                    }
                  },
                ),
              ],
            ),
            ]
        ),
      );
    }
    else {
      return null;
    }
  }

//  _isGuest()async {
//    FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
//    FirebaseUser user=await _firebaseAuth.currentUser();
//    print(user.email);
//  }

  Future<String> _getEmail( ) async {
    FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  void _onItemTapped( int index ) {
    print(index);
  }

  TSTYLE() {
    return TextStyle(
      color: Colors.white
    );
  }

  Widget Cities(String name, String image) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
          return new Result(image,name);
        }));
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 11.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(child:Image.asset(image,fit: BoxFit.cover,),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(name,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white))
                      ],
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
