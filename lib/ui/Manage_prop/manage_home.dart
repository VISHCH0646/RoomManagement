import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pg/ui/Manage_prop/ManageProperty.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:delayed_display/delayed_display.dart';

class ManageHome extends StatefulWidget {
  @override
  _ManageHomeState createState() => _ManageHomeState();
}

class _ManageHomeState extends State<ManageHome> {
  String _owner;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  List<Info> info=List();
  Query _query;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var c=getNamee();
    var pr=new ProgressDialog(context, showLogs: true, type: ProgressDialogType.Normal,isDismissible: false);
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

    Future.delayed(Duration(milliseconds: 800),()
    {
    //  pr.show();
      _query =
          database.reference().child("Property").orderByChild("owner").equalTo(
              _owner.toString());
      _query.onChildAdded.listen(_onEntryAdded);

      // databaseReference.onChildChanged.listen(_onChanged);
    });

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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Manage Properties")

          ],
        ),
        leading: Icon(Icons.receipt ),
      ),
      body: content,
    );
  }

  Widget ifPortrait() {
    return  Column(
      children: <Widget>[
        Container(height: 15,),
        Flexible(
          flex: 0,
        child: Text(info.length==0?"No Registered Properties":"Your Properties",style: TextStyle(
          fontSize: 30,
          fontFamily: String.fromCharCode(90),
          color: Colors.black45
        ),),
          fit: FlexFit.tight,
    ),
        Container(height: 20,),
        Flexible(
          child: Visibility(
            visible: _query==null?false:true,
            child: FirebaseAnimatedList(
              defaultChild: CircularProgressIndicator(),
                      query: _query==null?null:_query ,
                      itemBuilder: (_, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        return Container(
                          height: 90,
                          child: new Card(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            child: ListTile(
                              dense: false,
                              onTap:(){
                                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
                                  return ManageProperty(info[index].key,info[index].toilet);
                                }));
                              },
                              leading: Container(height:80,width:80,child: Image.network(info[index].url1,fit: BoxFit.fitWidth,)),
                              title: _query==null?CircularProgressIndicator():Text('${info[index].buildingname}'),
                              subtitle:_query==null?CircularProgressIndicator(): Text('Room No.  :${info[index].toilet}'),
                            ),
                          ),
                        );
                      },scrollDirection: Axis.vertical,
                    ),
          ),
        ),
      ],
    );

  }

  Future<String> getNamee() async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
   var  _getName=preferences.getString("Owner_session");
   _owner=_getName;
   return _getName;
  }
  void _onEntryAdded(Event event) {
    setState(() {
      info.add(Info.fromSnapshot(event.snapshot));
    });
  }

//  ManageProp(var a,var roomno,var context) {
//    a=a.toString();
//    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
//      return ManageProperty(a,roomno);
//    }));

  //}

}



class Info{
  String key;
  String buildingname;
  String toilet;
  String url1;

  Info(this.buildingname,this.toilet,this.url1);
  Info.fromSnapshot(DataSnapshot snapshot):key=snapshot.key,buildingname=snapshot.value["buildingname"],
  toilet=snapshot.value['roomno'],url1=snapshot.value['images']['image0'];
}
