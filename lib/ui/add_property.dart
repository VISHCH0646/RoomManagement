import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

import 'add_appt.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
final _formkey = GlobalKey<FormState>();

class AddProperty extends StatefulWidget {
  @override
  _AddPropertyState createState() => _AddPropertyState(data: data);
  AddProperty({this.data});
  var data;
}

class _AddPropertyState extends State<AddProperty> {
  int dropdownValue = 1;
  String _appttype="Select City";
  _AddPropertyState({this.data});
  var data;
  var _addr1,
      _addr2,
      _landmark,
      _city,
      _pincode,
      _building_name,
      _locality,
      _state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addr1 = TextEditingController(text: "");
    _addr2 = TextEditingController(text: "");
    _landmark = TextEditingController(text: "");
    _city = TextEditingController(text: "");
    _pincode = TextEditingController(text: "");
    _building_name = TextEditingController(text: "");
    _locality = TextEditingController(text: "");
    _state = TextEditingController(text: "Sikkim");
    print('jjjjj $data');
    Future.delayed(Duration(milliseconds: 100),()
    {
      if(data!=null){
        _building_name.text=data['building-name'];
        _addr1.text=data['address']['address-1'];
        _addr2.text=data['address']['address-2'];
        _landmark.text=data['address']['landmark'];
        _locality.text=data['address']['locality'];
        _city.text=data['address']['city'];
        _pincode.text=data['address']['pin'];
        _state.text=data['address']['state'];
      }

    });



  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    var orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      content = ifPortrait();
    } else {
      content = Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Icon(
              Icons.warning,
              size: 70,
              color: Colors.red.shade700,
            ),
          ),
          Text(
            "We do not Support LandScape mode as of now!!!",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            "Please Switch to Portrait Mode",
            style: TextStyle(fontSize: 20),
          )
        ],
      ));
      if (Vibration.hasVibrator() != null) {
        Vibration.vibrate();
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar:
          AppBar(title: Text("Add Property"), backgroundColor: Colors.black),
      body: content,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formkey.currentState.validate()) {
            if (_appttype!='Select City') {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (BuildContext context) {
                return new AddAppartment(
                    _addr1.text,
                    _addr2.text,
                    _landmark.text,
                    _appttype,
                    _pincode.text,
                    _building_name.text,
                    _locality.text,
                    _state.text);
                //_addr1,_addr2,_landmark,_city,_pincode,_building_name,_locality,_state;
              }));
            }
            else{
              _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(content: Text(
                      "Please select City!!!"))
                );
            }
          }
        },
        child: Icon(Icons.navigate_next),
        backgroundColor: Colors.black,
      ),
    );
  }

  Widget ifPortrait() {
    return ListView(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Step 1 ->",
                  style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 9.0, left: 9.0, top: 35),
            child: Container(
              height: 1.5,
              color: Colors.black,
            ),
          ),
          Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 13),
                      child: Text(
                        "Property Name: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 350,
                        child: TextFormField(
                          validator: (value) {
                            if (value.length < 4) {
                              return 'Please enter Building Name';
                            }
                            return null;
                          },
                          controller: _building_name,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Property/Building Name",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          //enabled: _updateDetails
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 9.0, left: 9.0, top: 35),
                  child: Container(
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 13),
                      child: Text(
                        "Property Address: ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, top: 19),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: 350,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Address';
                            }
                            return null;
                          },
                          controller: _addr1,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter Address Line 1",
                            labelText: "Address Line 1",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),
                          ],
                          //enabled: _updateDetails
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, top: 19),
                  child: Container(
                    height: 60,
                    width: 350,
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter Address';
                        }
                        return null;
                      },
                      controller: _addr2,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter Address Line 2",
                        labelText: "Address Line 2",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            gapPadding: 3.3),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(40),
                      ],
                      //enabled: _updateDetails
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0, top: 19),
                      child: Container(
                        height: 60,
                        width: 165,
                        child: TextFormField(
                          validator: (value) {
                            return null;
                          },
                          controller: _landmark,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter Landmark",
                            labelText: "Landmark",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          // enabled: _updateDetails
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 19),
                      child: Container(
                        height: 60,
                        width: 175,
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter Locality/Town';
                            }
                            return null;
                          },
                          controller: _locality,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Enter Locality/Town",
                            labelText: "Locality/Town",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          //enabled: _updateDetails,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0, top: 19),
                      child: Container(
                        height: 60,
                        width: 165,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1.0, style: BorderStyle.solid,color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        child:DropdownButton<String>(


                          //icon: Icon(Icons.business),
                          value: _appttype,
                          style: TextStyle(
                            color: Colors.black45,
                          ),
                          onChanged: (String newValue){
                            setState(() {
                              _appttype=newValue;
                            });
                          },
                          items: <String>["Select City","Gangtok","Majitar","Singtam","Rangpo",""].map<DropdownMenuItem<String>>((String value){
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                width: 120,
                                child: Center(
                                  child: Text(value,
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                            );

                          },).toList(),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 19),
                      child: Container(
                        height: 60,
                        width: 175,
                        child: TextFormField(
                          validator: (value) {
                            if (value.length != 6) {
                              return 'Please enter Pincode';
                            }
                            return null;
                          },
                          controller: _pincode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "Enter Pincode",
                            labelText: "Pincode",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                            WhitelistingTextInputFormatter.digitsOnly
                          ],
                          //   enabled: _updateDetails
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0, top: 19),
                  child: Container(
                    height: 60,
                    width: 350,
                    child: TextFormField(
                      enabled: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter State';
                        }
                        return null;
                      },
                      controller: _state,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter State",
                        labelText: "State",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            gapPadding: 3.3),
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(25),
                      ],
                      //enabled: _updateDetails,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 9.0, left: 9.0, top: 35),
                  child: Container(
                    height: 1.5,
                    color: Colors.black,
                  ),
                ),
//                Row(
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.only(left:12.0,top:13),
//                      child: Text("No. Of Units: ",
//                        style: TextStyle(
//                            fontSize: 20,
//                            fontWeight: FontWeight.bold
//                        ),),
//                    ),
//                  ],
//                ),
//                Container(
//                  height: 60,
//                  width: 350,
//                  child: DropdownButton<int>(
//
//                    //icon: Icon(Icons.business),
//                      value: dropdownValue,
//                    style: TextStyle(
//                      color: Colors.black45,
//                    ),
//                    onChanged: (int newValue){
//                      setState(() {
//                        dropdownValue=newValue;
//                      });
//                    },
//                    items: <int>[1,2,3,4].map<DropdownMenuItem<int>>((int value){
//                      return DropdownMenuItem<int>(
//                        value: value,
//                        child: Text(value.toString(),
//                        ),
//                      );
//
//                  },).toList(),
//
//                  ),
//
//
//                ),
                Container(
                  height: 15,
                ),
//                FlatButton(
//                    child: Text("Next",style: TextStyle(color: Colors.white),),
//                    color: Colors.black,
//                  onPressed: (){},
//                  padding: const EdgeInsets.only(left: 70,right: 70,top: 10,bottom: 10),
//                  ),
                Container(
                  height: 15,
                ),
              ],
            ),
          )
        ],
      ),
    ]);
  }
}
