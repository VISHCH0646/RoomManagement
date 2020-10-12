import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';



final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;


class OwnerProfile extends StatefulWidget {
  @override
  _OwnerProfileState createState() => _OwnerProfileState(_contact);
  OwnerProfile(this._contact);
  var _contact;
}

class _OwnerProfileState extends State<OwnerProfile> {
  var _contactkey;
  _OwnerProfileState(this._contactkey);

  var _name,_email,_contact,_altcontact,_addr1,_addr2,_landmark,_locality,_city,_pincode,_state;
  final _formkey = GlobalKey<FormState>();
  bool _updateDetails=false,_updateProfile=true;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name=new TextEditingController(text: "");
    _email=new TextEditingController(text: "");
    _contact=new TextEditingController(text: "");
    _altcontact=new TextEditingController(text: "");
    _addr1=new TextEditingController(text: "");
    _addr2=new TextEditingController(text: "");
    _landmark=new TextEditingController(text: "");
    _locality=new TextEditingController(text: "");
    _city=new TextEditingController(text: "");
    _pincode=new TextEditingController(text: "");
    _state=new TextEditingController(text: "");
    getDetails();
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
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: Colors.black,
      ),
      body: content,
    );
  }

  Widget ifPortrait() {
    return ListView(
      children: <Widget>[
        Container(
          height: 34,
          width: 34,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 3,bottom:18.0),
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person,size: 100,color: Colors.white,),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children:[
                    Visibility(
                      child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: (){},
                        padding: EdgeInsets.only(top: 80,right: 19),


                      ),
                      visible: _updateDetails,
                    ),

                  ]
                )
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right:8.4,left: 8.4,top: 10.3),
          child: Container(
            height: 2.0,
            color: Colors.black,
          ),
        ),
        Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left:28.0,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Basic Details:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic
                    ) ,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0,top: 10),
                child: Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Full Name';
                      }
                      return null;
                    },
                    controller: _name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Enter Full Name",labelText: "Full Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                    ),
                      enabled: _updateDetails
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0,top: 10),
                child: Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Email';
                      }
                      return null;
                    },
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: "Enter Email",labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                    ),
                      enabled: _updateDetails
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0,top: 10),
                    child: Container(
                      height: 50,
                      width: 140,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Contact';
                          }
                          return null;
                        },
                        controller: _contact,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Enter Contact",labelText: "Contact",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),
                        enabled: false,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,top: 10),
                    child: Container(
                      height: 50,
                      width: 150,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Contact';
                          }
                          return null;
                        },
                        controller: _altcontact,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Enter Alternate Contact",labelText: "Alternate Contact",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),
                          enabled: _updateDetails
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right:9.0,left: 9.0,top: 18.3),
                child: Container(
                  height: 1.5,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:28.0,top: 10.0),
                child: Row(
                  children: <Widget>[
                    Text("Current Address: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic
                      ) ,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0,top: 10),
                child: Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Address';
                      }
                      return null;
                    },
                    controller: _addr1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Enter Address Line 1",labelText: "Address Line 1",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                    ),
                      enabled: _updateDetails
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0,top: 10),
                child: Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter Address';
                      }
                      return null;
                    },
                    controller: _addr2,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Enter Address Line 2",labelText: "Address Line 2",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                    ),
                      enabled: _updateDetails
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0,top: 10),
                    child: Container(
                      height: 50,
                      width: 140,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Landmark';
                          }
                          return null;
                        },
                        controller: _landmark,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Enter Landmark",labelText: "Landmark",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),
                          enabled: _updateDetails
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,top: 10),
                    child: Container(
                      height: 50,
                      width: 150,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Locality/Town';
                          }
                          return null;
                        },
                        controller: _locality,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Enter Locality/Town",labelText: "Locality/Town",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),
                        enabled: _updateDetails,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 3.0,top: 10),
                    child: Container(
                      height: 50,
                      width: 140,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter City/District';
                          }
                          return null;
                        },
                        controller: _city,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(hintText: "Enter City/District",labelText: "City/District",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),
                          enabled: _updateDetails
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,top: 10),
                    child: Container(
                      height: 50,
                      width: 150,
                      child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Pincode';
                          }
                          return null;
                        },
                        controller: _pincode,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(hintText: "Enter Pincode",labelText: "Pincode",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                              gapPadding: 3.3),
                        ),
                          enabled: _updateDetails
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0,top: 10),
                child: Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter State';
                      }
                      return null;
                    },
                    controller: _state,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(hintText: "Enter State",labelText: "State",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                          gapPadding: 3.3),
                    ),
                    enabled: _updateDetails,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Visibility(
                  child: FlatButton(
                    child: Text("Save Details",style: TextStyle(color: Colors.white),),
                    color: Colors.black,
                    onPressed: (){
                     // _updateProfile();
                      setState(() {
                        _updateDetails=false;
                        _updateProfile=true;
                      });
                    },
                  ),
                  visible:_updateDetails,// _phone.text.toString().isEmpty?true:false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Visibility(
                  child: FlatButton(
                    padding: EdgeInsets.only(top:12,bottom: 12,right: 60,left: 60),
                    child: Text("Update Profile",style: TextStyle(color: Colors.white),),
                    color: Colors.black,
                    onPressed: (){
                      // _updateProfile();
                      setState(() {
                        _updateDetails=true;
                        _updateProfile=false;
                      });
                    },
                  ),
                  visible:_updateProfile,// _phone.text.toString().isEmpty?true:false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void getDetails() {
    database.reference().child("owners").child(_contactkey).once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> data=snapshot.value;
        print(data['email']);

         setState(() {
           _name.text=data['name'];
           _email.text=data['email'];
           _contact.text=data['contact'];
         });

    });
  }
}
