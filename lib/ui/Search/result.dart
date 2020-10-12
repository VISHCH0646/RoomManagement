import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pg/model/Property.dart';
import 'package:flutter_app_pg/ui/Search/property_details.dart';
import 'package:vibration/vibration.dart';
class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState(_image,_name);
  Result(this._image,this._name);
  String _image,_name;
}

class _ResultState extends State<Result> {
  _ResultState(this._image,this._name);
  String _image,_name;
  List<Property> names = new List();
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getNames();
    print(names.length);
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
      body: content,
    );
  }

  Widget ifPortrait() {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              backgroundColor: Colors.black,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(_name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
                  background: Container(
                    foregroundDecoration: BoxDecoration(color: Colors.black26),
                    child: Image.asset(
                      _image,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
          ];
        },
        body:ListView.builder(
        itemBuilder: (_,int index){
      return Card(
      child: ListTile(
      title: Text(names[index].bname.toString()),
      subtitle: Text('Room No.: ${names[index].rno.toString()}'),
      leading:SizedBox(
      height: 300,
      width: 100,
      child: Image.network(names[index].image,fit: BoxFit.cover,),
      ),
      onTap: (){
        List info=new List();
        database.reference().child("Property").child(names[index].key.toString())
            .child("images")
            .once()
            .then((( DataSnapshot snapshot ) {
          Map<dynamic, dynamic> data = snapshot.value;
          // print(_buildingname.text);

          for (var i = 0; i < data.length; i++) {
            setState(( ) {
              info.add(data['image$i']);
            });

            print(data['image$i']);
          }
        }));
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
          return new PropertyDetails(names[index].key,info);
        }));
      },
      ),
      );

        },
        itemCount:names == null ? 0 : names.length,)
      ),
    );
  }

  void _getNames() {
    Query _query = database.reference().child('Property').orderByChild('address/city').equalTo(_name.toString());
    _query.onChildAdded.listen(_onEntryAdded);
  }
  void _onEntryAdded(Event event)async {
    setState(( ) {
      names.add(Property.fromSnapshot(event.snapshot));
    });
  }
}
