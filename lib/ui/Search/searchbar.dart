import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_pg/model/Property.dart';
import 'package:flutter_app_pg/ui/Search/property_details.dart';
import 'package:vibration/vibration.dart';
class SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _searchText = "";
  List<Property> names = new List();
  //String _image='';
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  List<Property> filteredNames = new List();

  final TextEditingController _filter=TextEditingController();
  _SearchBarState(){
    _filter.addListener((){
      if(_filter.text.toString().isEmpty){
        setState(() {
          _searchText="";
          filteredNames=List();
        });
      }
      else{
        setState(() {
          _searchText=_filter.text.toString();
        });
      }
    });
  }

  @override
  void initState( ) {
    // TODO: implement initState
    //_image='';
    this. _getNames();
    super.initState();

  }

  @override
  Widget build( BuildContext context ) {
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
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(Icons.arrow_back, color: Colors.black45,),
          onTap: ( ) {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          controller: _filter,
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(
                  left: 15, bottom: 11, top: 11, right: 15),
              hintText: 'Enter Property to Search',)

        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.search, color: Colors.black45,),
          )
        ],

      ),
      body: content,
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget ifPortrait( ) {
    if(_searchText.isNotEmpty){
      filteredNames=names;
      List<Property> temp=List();
      for(int i=0;i<filteredNames.length;i++)
        {

          if((filteredNames[i].bname.toLowerCase().contains(_searchText.toLowerCase()))||
          filteredNames[i].city.toLowerCase().contains(_searchText.toLowerCase())){
            temp.add(filteredNames[i]);
          }
        }
      if(temp.length==0){
        return ListTile(
          title: Text('No Properties Found!!!'),
        );
      }
      filteredNames=temp;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (_,int index){
        return Card(
          child: ListTile(
            title: Text(filteredNames[index].bname.toString()),
            subtitle: Text('Room No.: ${filteredNames[index].rno.toString()}'),
            leading:SizedBox(
              height: 300,
              width: 100,
              child: Image.network(filteredNames[index].image,fit: BoxFit.cover,),
            ),
            onTap: (){
              List info=new List();
              database.reference().child("Property").child(filteredNames[index].key.toString())
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
                return new PropertyDetails(filteredNames[index].key,info);
              }));
            },
          ),
        );
      },

    );
  }

  void _getNames()async
  {
    Query _query = database.reference().child('Property');
    _query.onChildAdded.listen(_onEntryAdded);
  }

  void _onEntryAdded(Event event)async {
    setState(( ) {
      names.add(Property.fromSnapshot(event.snapshot));
    });
  }
}
