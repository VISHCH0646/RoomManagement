import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pg/model/version.dart';
import 'package:flutter_app_pg/ui/Loginscreen.dart';
import 'package:flutter_app_pg/ui/add_property.dart';
import 'package:flutter_app_pg/ui/owner_profile.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:async_loader/async_loader.dart';
import 'package:progress_hud/progress_hud.dart';

import 'Manage_prop/manage_home.dart';
import 'add_appt.dart';

final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
const TIMEOUT = const Duration(seconds: 5);
ProgressDialog pr;
ProgressHUD _progressHUD;
bool _checkConfig=true;
final GlobalKey<AsyncLoaderState> _asyncLoaderState = new GlobalKey<AsyncLoaderState>();


class OwnerDashboard extends StatefulWidget {
  @override
  _OwnerDashboardState createState() => _OwnerDashboardState();
  var contact;
  OwnerDashboard({this.contact});
}

class _OwnerDashboardState extends State<OwnerDashboard> {

  String owner_name="";
  String owner_email="";
  bool _proceed=true;
  @override
  void initState() {
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
          var a=getName(pr);
          print(contact);
          print("done");

          Future.delayed(Duration(seconds: 4)).then((_) {
            pr.dismiss();
            pr.dismiss();
          });

//      Future.delayed(Duration.zero,(){
//        pr.dismiss();
//      });
    });



  }
  var contact;
  _OwnerDashboardState({this.contact});
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
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
      appBar: AppBar(
        title: Text("Owner's Dashboard"),
        backgroundColor: Colors.black,
      ),
      body: content,
      drawer: drawer_items(),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
    );
  }

  Widget ifPortrait() {
    return ListView(
      children:[ Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            owner_name,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold
            ),
          ),
          FlatButton(
            child: Text("LogOut"),
            onPressed: ()=>_signOut(),
          ),
          FlatButton(
            child: Text("Add Property",style: TextStyle(color: Colors.white),),
            color: Colors.black,
            onPressed: (){
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new AddProperty();
                      }));

            },
          ),
          Container(height:50,width: 50),
          FlatButton(
            child: Text("Manage Properties",style: TextStyle(color: Colors.white),),
            color: Colors.black,
            onPressed: (){
              Navigator.of(context).push(
                  new MaterialPageRoute(
                      builder: (BuildContext context) {
                        return new ManageHome();
                      }));

            },
          ),

        ],
      ),
    ]
    );
  }
  _signOut()async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("Owner_session", null);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }

  Future<dynamic> getName(var pr) async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    contact=pref.getString("Owner_session");
    print("Contact: $contact");

    final FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref;
    String name;
    database.reference().child("owners").child(contact).once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> data=snapshot.value;
      setState(() {
        owner_name=data['name'];
        owner_email=data['email'];
      });
    });
    return ref;
    _checkConfig=false;
  }

  drawer_items() {
    if(MediaQuery.of(context).orientation==Orientation.portrait) {
      return Drawer(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                    accountName: InkWell(child: Text(
                      owner_name,
                      style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                   ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    accountEmail: Text(owner_email
                    ,style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                  currentAccountPicture: InkWell(
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_outline, color: Colors.black)
                    )
                ),


                ),
                ListTile(
                  leading: Icon(Icons.perm_identity,color: Colors.black45,),
                  title: Text("Profile"),
                  onTap: (){
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) {
                              return new OwnerProfile(contact);
                            }));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.headset),

                )

              ],
            )
          ],
        ),
      );
    }
  }
  loadPage(){
    var _asyncLoader = new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => await getMessage(),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) =>
      new Text('Sorry, there was an error loading your joke'),
      renderSuccess: ({data}) => new Text(data),
    );
  }

  getMessage() async {
    return new Future.delayed(TIMEOUT, () => 'Welcome to your async screen');
  }

}
