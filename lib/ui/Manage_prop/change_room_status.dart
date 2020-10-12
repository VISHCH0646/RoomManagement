import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class ChangeStatus extends StatefulWidget {
  @override
  final String _propertyKey;
  _ChangeStatusState createState() => _ChangeStatusState(this._propertyKey);
  ChangeStatus(this._propertyKey);

}
final _formkey = GlobalKey<FormState>();
class _ChangeStatusState extends State<ChangeStatus> {
  _ChangeStatusState(this._propertyKey);
  final String _propertyKey;
  var  _tenant_name,_tenant_wcontact,_tenant_contact;
  bool _empty=false;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenant_name=TextEditingController(text: '');
    _tenant_contact=TextEditingController(text: '');
    _tenant_wcontact=TextEditingController(text: '');
    database.reference().child('Property').child(_propertyKey).once().then(((DataSnapshot snapshot){
      Map<dynamic,dynamic> data=snapshot.value;
      setState(() {
        _empty=data['status'];
        print(_empty);
      });

    }));
    Future.delayed(Duration(milliseconds: 500),(){
    if(_empty==true){
      print('in');
      database.reference().child("Property").child(_propertyKey).child('tenant').once().then(((DataSnapshot snapshot){
        Map<dynamic,dynamic> data=snapshot.value;
        setState(() {
          print(data['name']);
          _tenant_name.text=data['name'];
          _tenant_contact.text=data['contact'];
          _tenant_wcontact.text=data['wcontact'];
        });
      }));
    }});


  }
  @override
  Widget build(BuildContext context) {


    Widget content;

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
      )
      );
      if (Vibration.hasVibrator() != null) {
        Vibration.vibrate();
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: InkWell(
              child: Icon(Icons.close,color: Colors.grey,size: 30,),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
      body: content,
    );
  }

  Widget ifPortrait() {
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Room Status: '),
            Switch(value: _empty, onChanged: (value){
              setState(() {
                _empty=value;
              });
              print(value);
            },activeColor: Colors.green,),
          ],
        ),
        Visibility(
          visible: _empty,
          child: Container(
            child: Form(
              key:  _formkey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,top: 8),
                    child: Text("Update Tenant Details",style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20
                    ),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _tenant_name,
                          decoration: InputDecoration(
                            hintText: "Name",
                            labelText: "Name",
                            enabled: false,
                          ),
                          validator: (value){
                            if(value.length<3){
                              return 'Please Enter Full Name';
                            }
                          },
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(25),
                            ]

                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        width: 125,
                        child: TextFormField(
                          controller: _tenant_contact,
                          decoration: InputDecoration(
                            hintText: "Contact",
                            labelText: "Contact",
                            errorMaxLines: 10,
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value){
                            if(value.length!=10){
                              return 'Please Enter Valid Number';
                            }
                          },
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(10),
                              WhitelistingTextInputFormatter.digitsOnly,
                            ]

                        ),
                      ),
                      Container(
                        width: 125,
                        child: TextFormField(
                          controller: _tenant_wcontact,
                          decoration: InputDecoration(
                            hintText: "Contact(Whatsapp)",
                            labelText: "Contact(Whatsapp)",
                            errorMaxLines: 10,
                          ),
                          validator: (value){
                            if(value.length!=10){
                              return 'Please Enter Valid Number';
                            }
                          },
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(10),
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                          keyboardType: TextInputType.number,

                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(onPressed: (){UpdateStatus();}, child: Text('Update Details',style: TextStyle(color: Colors.white),),color: Colors.black,)
            ],
          ),
        )
      ],
    );

  }

  void UpdateStatus() {
    if(_empty==false)
      {
        database.reference().child('Property').child(_propertyKey).child('status').set(_empty);
        database.reference().child('Property').child(_propertyKey).child('tenant').set(null);
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Details Updated'),
                actions: <Widget>[
                  FlatButton(onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context,{
                      'name': _tenant_name.text,
                      'contact':_tenant_contact.text,
                      'wcontact':_tenant_wcontact.text
                    }
                    );
                  }, child: Text('Ok')),
                ],
              );
            }
        );
      }
    else if(_empty=true){
      if(_formkey.currentState.validate()){
        var data={
          'name':_tenant_name.text,
          'contact':_tenant_contact.text,
          'wcontact':_tenant_wcontact.text
        };
        database.reference().child('Property').child(_propertyKey).child('status').set(_empty);
        database.reference().child('Property').child(_propertyKey).child('tenant').set(data);
        print(_empty);
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Details Updated'),
                actions: <Widget>[
                  FlatButton(onPressed: (){

                    Navigator.pop(context);
                    Navigator.pop(context,{
                      'name': _empty==false?"NA":_tenant_name.text,
                      'contact':_empty==false?"NA":_tenant_contact.text,
                      'wcontact':_empty==false?"NA":_tenant_wcontact.text
                    }
                    );
                  }, child: Text('Ok')),
                ],
              );
            }
        );

      }

    }
  }


}
