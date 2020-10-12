import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_app_pg/model/Constraints.dart';
import 'package:flutter_app_pg/ui/Manage_prop/change_room_status.dart';
import 'package:flutter_boom_menu/flutter_boom_menu.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
var room_no="Please Wait";
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
class ManageProperty extends StatefulWidget {
  @override
  _ManagePropertyState createState() => _ManagePropertyState(_propertykey,_roomno);
  ManageProperty(this._propertykey,this._roomno);
  String _propertykey;var _roomno;
}

class _ManagePropertyState extends State<ManageProperty> {
  String _propertyKey;var _roomno="Please Wait...";
  var _empty=false;
  var _buildingname,_rent,_desc;
  var _address1,_address2,_landmark,_locality,_city,_pincode,_state;
  var _roomnoo,_floor,_roomType,_kitchen,_toilet;
  var _tenant_name,_tenant_contact,_tenant_wcontact;
  var _update_rent;
  _ManagePropertyState(this._propertyKey,this._roomno);
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  List info=List();
  Query _query;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _address1=TextEditingController(text: "");
    _address2=TextEditingController(text: "");
    _landmark=TextEditingController(text: "");
    _locality=TextEditingController(text: "");
    _locality=TextEditingController(text: "");
    _city=TextEditingController(text: '');
    _pincode=TextEditingController(text: '');
    _state=TextEditingController(text: '');
    _buildingname=TextEditingController(text: "");
    _roomnoo=TextEditingController(text: _roomno);
    _floor=TextEditingController(text: 'Please Wait...');
    _roomType=TextEditingController(text: "Please Wait...");
    _kitchen=TextEditingController(text: 'Please Wait...');
    _toilet=TextEditingController(text: "Please Wait...");
    _rent=TextEditingController(text: 'Please Wait');
    _desc=TextEditingController(text: '');
    _tenant_name=TextEditingController(text: '');
    _tenant_contact=TextEditingController(text: '');
    _tenant_wcontact=TextEditingController(text: '');
    _update_rent=TextEditingController(text: '');
    database.reference().child("Property").child(_propertyKey).child("images").once().then(((DataSnapshot snapshot){
      Map<dynamic,dynamic> data=snapshot.value;
      print(_buildingname.text);

      for(var i=0;i<data.length;i++)
      {
        setState(() {
          info.add(data['image$i']);
        });

        print(data['image$i']);

      }

      //  print(_propertyKey);
      database.reference().child('Property').child(_propertyKey).once().then(((DataSnapshot snapshot){
        Map<dynamic,dynamic> data=snapshot.value;
        setState(() {
          _buildingname.text=data['buildingname'];
          _floor.text=data['floor'].toString();
          _roomType.text=data['roomtype'];
          _kitchen.text=data['kitchen'];
          _toilet.text=data['toilet'];
          _rent.text=data['rent'];
          _desc.text=data['desc'];
          _empty=data['status'];
        });
        setState(() {
          room_no="${_buildingname.text}"+"\n"+"Room No. :"+_roomno;
        });
      }));
      getAddress();
      getTenant();



    }));


  }
  @override
  Widget build(BuildContext context) {
    Widget content;

    var orientation = MediaQuery
        .of(context)
        .orientation;
    if (orientation == Orientation.portrait) {
      content = ifPortrait(context);
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
            "Please Switch to Portrait Mode", style: TextStyle(fontSize: 20),
          )
        ],
      )
      );
      if (Vibration.hasVibrator() != null) {
        Vibration.vibrate();
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
          child: AppBar(
            automaticallyImplyLeading: true,
            elevation: 5.0,
            title: Text(room_no),
            backgroundColor: Colors.black,
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: ChoiceAction,
                itemBuilder: (BuildContext context){
                  return Constraints.choice.map((String c){
                    return PopupMenuItem<String>(
                      value: c,
                      child: Text(c),
                    );
                  }).toList();
                },

              ),

            ],
          ), preferredSize:Size.fromHeight(80.0)),
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: false,

      body: content,
//      floatingActionButton:
//              BoomMenu(
//                animatedIcon: AnimatedIcons.menu_close,
//                animatedIconTheme: IconThemeData(size: 22.0),
//                onOpen: () => print('OPENING DIAL'),
//                onClose: () => print('DIAL CLOSED'),
//                scrollVisible: true,
//                backgroundColor: Colors.black,
//                overlayColor: Colors.black,
//                overlayOpacity: 0.7,
//                children: [
//                  MenuItem(
//                    child: Icon(Icons.update, color: Colors.white),
//                    title: "Update Room Status",
//                    titleColor: Colors.white,
//                    subtitle: "Add Tanent details/Change Status",
//                    subTitleColor: Colors.white,
//                    backgroundColor: Colors.black,
//                    onTap: () => print('FIRST CHILD'),
//                  ),
//                  MenuItem(
//                    child: Icon(Icons.image, color: Colors.white),
//                    title: "Update Room Images",
//                    titleColor: Colors.white,
//                    subtitle: "Add/Update Room Images",
//                    subTitleColor: Colors.white,
//                    backgroundColor: Colors.black,
//                    onTap: () => print('Second CHILD'),
//                  ),
//                  MenuItem(
//                    child: Icon(Icons.attach_money, color: Colors.white),
//                    title: "Update Room Rent",
//                    titleColor: Colors.white,
//                    subtitle: "Update rent of the room",
//                    subTitleColor: Colors.white,
//                    backgroundColor: Colors.black,
//                    onTap: () => print('Second CHILD'),
//                  ),
//                ],
//
//              ),

      );

  }

  Widget ifPortrait(var context) {
    return Flex(direction: Axis.vertical,children: <Widget>[
      Flexible(
          flex: 0,
          child:Container(
            height: 300,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: info.length,
                itemBuilder: (BuildContext context,int position){
                  return Container(
                    child: new Card(
                      color: Colors.white70,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      child: Image.network(info[position],height: 180,width: 300,fit: BoxFit.cover,),

                    ),
                  );
                }
            ),
          )
      ),
      Flexible(child: Container(height: 1,color: Colors.black,)),
      Flexible(flex:100,child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(height: 12,),
          Form(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _buildingname,
                          decoration: InputDecoration(
                            hintText: "Building Name",
                            labelText: "Buiding Name",
                            enabled: false,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _address1,
                          decoration: InputDecoration(
                            hintText: "Address Line 1",
                            labelText: "Address Line 1",
                            errorMaxLines: 10,



                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(

                          controller: _address2,
                          decoration: InputDecoration(
                              hintText: "Address Line 2",
                              labelText: "Address Line 2",
                              errorMaxLines: 10,
                              fillColor: Colors.orange



                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

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
                          controller: _landmark,
                          decoration: InputDecoration(
                            hintText: "Landmark",
                            labelText: "Landmark",
                            errorMaxLines: 10,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

                        ),
                      ),
                      Container(
                        width: 125,
                        child: TextFormField(
                          controller: _locality,
                          decoration: InputDecoration(
                            hintText: "Locality/Town",
                            labelText: "Locality/Town",
                            errorMaxLines: 10,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

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
                          controller: _city,
                          decoration: InputDecoration(
                            hintText: "City/District",
                            labelText: "City/District",
                            errorMaxLines: 10,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

                        ),
                      ),
                      Container(
                        width: 125,
                        child: TextFormField(
                          controller: _pincode,
                          decoration: InputDecoration(
                            hintText: "Pincode",
                            labelText: "Pincode",
                            errorMaxLines: 10,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

                        ),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(

                          controller: _state,
                          decoration: InputDecoration(
                              hintText: "State",
                              labelText: "State",
                              errorMaxLines: 10,
                              fillColor: Colors.orange
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

                        ),
                      ),
                    ],
                  ),
                ],
              )
          ),
          Container(height: 8,),
          Padding(
            padding: const EdgeInsets.only(right:8.0,left: 8.0),
            child: Container(height: 1,color: Colors.black,),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black),
                  color: Colors.lightBlueAccent.shade50
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,top: 8),
                    child: Text("Room Details",style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 20
                    ),),
                  ),
                  Container(height: 0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _roomnoo,
                          decoration: InputDecoration(
                            hintText: "Room No.",
                            labelText: "Room No.",
                            enabled: false,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,

                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _floor,
                          decoration: InputDecoration(
                            hintText: "Floor No.",
                            labelText: "Floor No.",
                            enabled: false,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _roomType,
                          decoration: InputDecoration(
                            hintText: "Room Type:",
                            labelText: "Room Type:",
                            enabled: false,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _kitchen,
                          decoration: InputDecoration(
                            hintText: "Kitchen",
                            labelText: "Kitchen",
                            enabled: false,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _toilet,
                          decoration: InputDecoration(
                            hintText: "Attatched Toilet Available",
                            labelText: "Attatched Toilet",
                            enabled: false,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                          width: 290,
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            controller: _desc,
                            enabled: false,
                            maxLines: null,
                            decoration: InputDecoration(
                              hintText: "Room Description",
                              labelText: "Room Description",
                              enabled: false,
                            ),
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 290,
                        child: TextFormField(
                          controller: _rent,
                          decoration: InputDecoration(
                            hintText: "Rent (Rs.)",
                            labelText: "Rent (Rs.)",
                            enabled: false,
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0,top: 8),
                    child: Text("Tenant Details",style: TextStyle(
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(40),],
                          enabled: false,
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),],
                          enabled: false,

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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),],
                          enabled: false,

                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          )

        ],
      ),),

    ],);
  }

  void getAddress() {
    database.reference().child('Property').child(_propertyKey).child("address").once().then(((DataSnapshot snapshot){
      Map<dynamic,dynamic> data=snapshot.value;
      setState(() {
        _address1.text=data['address1'];
        _address2.text=data['address2'];
        _landmark.text=data['landmark'];
        _locality.text=data['locality'];
        _city.text=data['city'];
        _pincode.text=data['pin'];
        _state.text=data['state'];
      });
    }));

  }

  void getTenant() {

    database.reference().child('Property').child(_propertyKey).child('tenant').once().then(((DataSnapshot snapshot){
      Map<dynamic,dynamic> data=snapshot.value;
      setState(() {
        if(data!=null) {
          _tenant_name.text = data['name'];
          _tenant_contact.text=data['contact'];
          _tenant_wcontact.text=data['wcontact'];
        }
        else{
          _tenant_name.text="NA";
          _tenant_contact.text="NA";
          _tenant_wcontact.text="NA";
        }
      });
    }));
  }

  showMenuProperty() {


  }

  ChoiceAction(String selected) {
    if(selected==Constraints.tenant){
      print("Room Status");
      changeStatus(context);
    }
    else if(selected==Constraints.rent){
      print("Rent");
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Update Rent'),
              content: TextField(
                controller: _update_rent,
                decoration: InputDecoration(
                  labelText: "Enter Rent (Rs.)",
                ),
                keyboardType: TextInputType.number,
                inputFormatters:<TextInputFormatter> [
                  LengthLimitingTextInputFormatter(6),
                  WhitelistingTextInputFormatter.digitsOnly,],
              ),
              actions: <Widget>[
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('Cancel')),
                FlatButton(onPressed: (){
                  if(_update_rent.text.toString().isNotEmpty){
                    database.reference().child('Property').child(_propertyKey).child('rent').set(_update_rent.text);
                    Navigator.pop(context);
                    setState(() {
                      _rent.text=_update_rent.text;
                    });
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text(
                        "Rent Updated..")));
                  }
                }, child: Text('Update'))
              ],
            );
          }
      );
    }
    else if(selected==Constraints.updateImages){
      print('Images');
    }
    else if(selected==Constraints.removeProperty)
      {
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Remove Property'),
                content: Text('This will remove proerty from our records.'),
                actions: <Widget>[
                  FlatButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('Cancel')),
                  FlatButton(onPressed: (){
                    database.reference().child('Property').child(_propertyKey).set(null);
                    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text(
                        "Property Removed Successfully..")));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();

                  }, child: Text('Update'))
                ],
              );
            }
        );


      }

  }

  Future changeStatus(BuildContext context)async {
    Map result=await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
      return ChangeStatus(_propertyKey);
    }));
    if(result!=null){
      _tenant_name.text=result['name'];
      _tenant_contact.text=result['contact'];
      _tenant_wcontact.text=result['wcontact'];
    }
    else{
      _tenant_name.text=result['name'];
      _tenant_contact.text=result['contact'];
      _tenant_wcontact.text=result['wcontact'];

    }

  }



}

