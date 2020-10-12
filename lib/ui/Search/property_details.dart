import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vibration/vibration.dart';
class PropertyDetails extends StatefulWidget {
  @override
  _PropertyDetailsState createState() => _PropertyDetailsState(_key,_info);
  PropertyDetails(this._key,this._info);
  var _key,filteredNames,index;
  List _info;
}
class _PropertyDetailsState extends State<PropertyDetails> {
  _PropertyDetailsState(this._key,this._info);
  var _key;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  List _info;
  String _bname='',_rent='',_address='',_kitchen='',_toilet='',_furnished='',_desc='',_roomtype='',_roomno='',_floorno='';
  Query _query;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database.reference().child('Property').child(_key).once().then((DataSnapshot snapshot){
      Map<dynamic,dynamic> data=snapshot.value;
      setState(() {
        _roomno=data['roomno'].toString();
        _floorno=data['floor'].toString();
        _roomtype=data['roomtype'];
        _desc=data['desc'];
        _bname=data['buildingname'];
        _rent=data['rent'];
        _address=data['address']['address1']+", "+data['address']['address2']+', Near '+data['address']['locality']+', '+data['address']['city']+", "+data['address']['state']+'\nPin: '+data['address']['pin'];
        _kitchen=data['kitchen'];
        _toilet=data['toilet'];
        _furnished=data['furnished'];
      });

    });

  }
  @override
  Widget build(BuildContext context) {
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
      body: content
    );
  }
  Widget ifProtrait(){
    return Stack(
      children: <Widget>[
//          Container(
//                foregroundDecoration: BoxDecoration(
//                    color: Colors.black26
//                ),
//                height: 400,
//                child:
//                ListView(
//                  scrollDirection: Axis.horizontal,
//                  children: <Widget>[
//                    InkWell(onTap: ()=>print("Hello"),child: Image.asset('images/Gangtok.jpg')),
//                    Image.asset('images/rent.jpg'),
//
//                    Image.asset('images/Majitar.jpg'),
//                  ],
//                )
////              ListView.builder(
////                itemCount: info==null?0:info.length,
////                scrollDirection: Axis.horizontal,
////                  itemBuilder: (BuildContext context,int index){
////                  return Image.network(info[index]);
////                  })
//            ),
        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 0.0,bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  foregroundDecoration: BoxDecoration(
                      color: Colors.black26
                  ),
                  height: 400,
                  child:
//                    ListView(
//                      scrollDirection: Axis.horizontal,
//                      children: <Widget>[
//                        InkWell(onTap: ()=>print("Hello"),child: Image.asset('images/Gangtok.jpg',fit: BoxFit.fitWidth,)),
//                        Image.asset('images/rent.jpg'),
//
//                        Image.asset('images/Majitar.jpg'),
//                      ],
//                    )
                  ListView.builder(
                      itemCount: _info==null?0:_info.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context,int index){
                        return Image.network(_info[index],fit: BoxFit.fitWidth,);
                      })
              ),
              const SizedBox(height: 2),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal:16.0),
                  child:null
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:10.0),
                child: Card(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(width: 20.0),
                      SizedBox(
                        height: 60,
                        width: 200,
                        child: AutoSizeText(
                          _bname,
                          style:GoogleFonts.aldrich(fontSize: 25,fontWeight: FontWeight.bold), //TextStyle(color: Colors.black87, fontSize: 28.0, fontWeight: FontWeight.bold,fontFamily: 'Raleway'),
                          maxLines: 2,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        color: Colors.grey,
                        icon: Icon(Icons.favorite_border),
                        onPressed: () =>print("Added to favourates"),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right:32.0,bottom: 32.0,left: 20.0,top: 0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(

                      children: <Widget>[
                        Icon(Icons.location_on, size: 25.0, color: Colors.grey,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text.rich(TextSpan(children: [
//                                  WidgetSpan(
//                                      child: Icon(Icons.location_on, size: 19.0, color: Colors.grey,)
//                                  ),
                                TextSpan(
                                    text: _address
                                )
                              ]), style: TextStyle(color: Colors.grey, fontSize: 13.0),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:8.0),
                          child: Column(
                            children: <Widget>[
                              AutoSizeText("\₹ ${_rent}",maxLines: 1, style:GoogleFonts.aldrich(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0
                              ),),
                              Text("/per month",style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey
                              ),)
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        color: Colors.black,
                        textColor: Colors.white,
                        child: Text("Contact Owner", style:GoogleFonts.aldrich(
                            fontWeight: FontWeight.normal
                        ),),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text("DESCRIPTION",style: GoogleFonts.aldrich(fontWeight: FontWeight.w600,fontSize: 14.0 ),),
                    const SizedBox(height: 10.0),
                    Text(_desc,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14),),
                    const SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Text('Room Type: ',style: TextStyle(fontWeight: FontWeight.w400),),
                        Text(_roomtype,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Floor No: ',style: TextStyle(fontWeight: FontWeight.w400),),
                        Text(_floorno,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14),)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Room No.: ',style: TextStyle(fontWeight: FontWeight.w400),),
                        Text(_roomno,style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14),)
                      ],
                    ),


                    const SizedBox(height: 20.0),
                    Text("FACILITIES",style: GoogleFonts.aldrich(fontWeight: FontWeight.w600,fontSize: 14.0 ),),
                    const SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Text('Kitchen ',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14)) ,
                        Icon(_kitchen=='Yes'?Icons.done:Icons.close,color: Colors.grey,)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Attached Toilet ',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14)) ,
                        Icon(_toilet=='Yes'?Icons.done:Icons.close,color: Colors.grey,)
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('Furnished ',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14)) ,
                        Icon(_furnished=='Yes'?Icons.done:Icons.close,color: Colors.grey,)
                      ],
                    ),
//                    const SizedBox(height: 20,),
//                    Text("More Like This",style: GoogleFonts.aldrich(fontSize: 15.5,fontWeight: FontWeight.w600),),
//                    const SizedBox(height:10)
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text("DETAIL",style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal
            ),),
          ),
        ),

      ],
    );
  }
}




























//import 'package:flutter/material.dart';
//import 'package:flutter_app_pg/model/Property.dart';
//import 'package:vibration/vibration.dart';
//
//class PropertyDetails extends StatefulWidget {
//  @override
//  _PropertyDetailsState createState() => _PropertyDetailsState(key,filteredNames,index);
//  PropertyDetails(key,filteredNames,index);
//  var key,filteredNames,index;
//}
//
//class _PropertyDetailsState extends State<PropertyDetails> {
//  _PropertyDetailsState(key,filteredNames,index);
//  var key,filteredNames,index;
//  List<Property> details;
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    details=filteredNames;
//
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    Widget content;
//
//    var orientation = MediaQuery
//        .of(context)
//        .orientation;
//    if (orientation == Orientation.portrait) {
//      content = ifPortrait();
//    }
//    else {
//      content = Center(child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.only(bottom: 10.0),
//            child: Icon(Icons.warning, size: 70, color: Colors.red.shade700,),
//          ),
//          Text("We do not Support LandScape mode as of now!!!",
//            style: TextStyle(fontSize: 20),),
//          Text(
//            "Please Switch to Portrait Mode", style: TextStyle(fontSize: 20),)
//        ],
//      )
//      );
//      if (Vibration.hasVibrator() != null) {
//        Vibration.vibrate();
//      }
//    }
//    return Scaffold(
//      body: content,
//    );
//  }
//  Widget  ifPortrait(){
//      return Stack(
//        children: <Widget>[
//
////          SizedBox.fromSize(
////            size: Size.fromHeight(400.0),
////            child: ListView.builder(
////                scrollDirection: Axis.horizontal,
////                itemCount: ,
////                itemBuilder: null,
////
////            )
////          )
//        Container(foregroundDecoration:BoxDecoration(
//          color: Colors.black26
//        ),
//            child: Image.asset('images/rent.jpg',fit: BoxFit.cover,height: 400,)),
//        SingleChildScrollView(
//          padding: const EdgeInsets.only(top:16,bottom: 20),
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              const SizedBox(height:272),
//              Text("Jignish Bhai Rental Properties",
//                style: TextStyle(
//                  color: Colors.white,
//                  fontSize: 28,
//                  fontWeight: FontWeight.bold
//                ),
//              ),
//              Row(
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//                  IconButton(icon: Icon(Icons.favorite_border), onPressed: (){},
//                  color: Colors.white,)
//                ],
//              ),
//             Container(
//               padding: const EdgeInsets.all(16.0),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisSize: MainAxisSize.min,
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Expanded(child: Column(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Row()
//                          ],
//                        )),
//                        Column(
//                         children: <Widget>[
//                           Text('Rs. 5000',style: TextStyle(
//                             color: Colors.black87,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 20
//                           ),),
//                           Text('per Month')
//                         ],
//                        )
//                      ],
//                    ),
//                    const SizedBox(height: 20,),
//                    SizedBox(
//                      width: double.infinity,
//                      child: RaisedButton(onPressed: (){},
//                        shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(30.0)
//                        ),
//                      color: Colors.black,
//                        child: Text("Contact Owner",style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal),),
//                      ),
//                    ),
//                    const SizedBox(height: 20,),
//                    Text("Description".toUpperCase(),style: TextStyle(
//                      fontWeight: FontWeight.w600,
//                      color: Colors.black87
//                    ),),
//                   Text('1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n',style: TextStyle(
//                     fontSize: 30
//                   ),)
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//          Positioned(
//            top: 0,
//            left: 0,
//            right: 0,
//            child: AppBar(
//              backgroundColor: Colors.transparent,
//              elevation: 0,
//              title: Text('DETAILS',style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),),
//              centerTitle: true,
//              leading: Icon(Icons.arrow_back,color: Colors.white,),
//            ),
//          ),
//        ],
//      );
//  }
//}
