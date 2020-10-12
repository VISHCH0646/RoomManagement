import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {

  final FirebaseDatabase database = FirebaseDatabase.instance;
  bool ifPhone=false;

  var _name,_email,_phone;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name=new TextEditingController(text: "");
    _email=new TextEditingController(text: "");
    _phone=new TextEditingController(text: "");
    getProfile();

  }






  @override
  Widget build(BuildContext context) {

    Widget content;
    // var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery
        .of(context)
        .orientation;
    if (orientation == Orientation.portrait) {
      content = ifPortrait();
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
          Padding(
            padding: const EdgeInsets.only(top:50.0,bottom: 70.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom:18.0),
                  child: CircleAvatar(
                    radius: 90,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person,size: 100,color: Colors.white,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text("Name:  "),
                      Container(
                        height: 60,
                        width: 270,
                        child: TextField(
                            controller: _name,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(hintText: "Enter Full Name",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                                  gapPadding: 3.3),

                            ),
                          enableInteractiveSelection: false,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text("Email:  "),
                      Container(
                        height: 60,
                        width: 270,
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: "Enter Full Name",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),

                          ),
                          enableInteractiveSelection: false,
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:6.0,right: 6.0,top: 10.0),
                  child: Row(
                    children: <Widget>[
                      Text("Phone \n No.:  "),
                      Container(
                        height: 60,
                        width: 270,
                        child: TextField(
                          controller: _phone,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(hintText: "Enter Phone Number",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),

                          ),
                          enableInteractiveSelection: false,
                          enabled: ifPhone,
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  child: FlatButton(
                    child: Text("Save Details",style: TextStyle(color: Colors.white),),
                    color: Colors.black,
                    onPressed: (){
                      _updateProfile();
                    },
                  ),
                  visible:ifPhone,// _phone.text.toString().isEmpty?true:false,
                ),


              ],
            ),
          )
        ],
      );
  }

  void getProfile()async {
    try{
      FirebaseUser user=await _firebaseAuth.currentUser();
      _name.text=user.displayName;
      _email.text=user.email;
      _phone.text=user.phoneNumber;

      if(_name.text.toString().isEmpty || _email.text.toString().isEmpty || _phone.text.toString().isEmpty){
        DatabaseReference ref=database.reference().child("users");
       ref.reference().child(user.uid).once().then((DataSnapshot snapshot){
         Map<dynamic,dynamic> data=snapshot.value;
         _name.text=data['name'];
         _email.text=data['email'];
        _phone.text=data['contact'];
       });
       if(_phone.text.toString().isEmpty){
         setState(() {
           ifPhone=true;
         });
       }

      }

    }catch(e){print("ERROR?????????");}
  }

  void _updateProfile()async {
    FirebaseUser user=await _firebaseAuth.currentUser();
    database.reference().child("users").child(user.uid).update({"contact":_phone.text});
    setState(() {
      database.reference().child("users").child(user.uid).once().then((DataSnapshot snapshot){
        Map<dynamic,dynamic> data=snapshot.value;
        _phone.text=data['contact'];
      });
      ifPhone=false;
    });
  }

}
