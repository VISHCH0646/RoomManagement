import 'package:flutter/material.dart';
import 'package:flutter_app_pg/ui/add_property.dart';

import 'owner_dashboard.dart';

class Done extends StatefulWidget {
  @override
  var data;
  _DoneState createState() => _DoneState(data: data);
  Done({this.data});
}

class _DoneState extends State<Done> {
  _DoneState({this.data});var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Property Registered"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
          height:50 ,
      ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(child: Icon(Icons.done,size: 90,color: Colors.white,),radius: 70,backgroundColor: Colors.black,),
            ],
          ),
          Container(
            height: 35,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Thank You",
              style: TextStyle(
                fontSize: 35,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold
              ),),
            ],
          ),
          Container(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Your Property will be Listed Shortly...",
              style: TextStyle(
                fontSize: 16,
                fontFamily: String.fromCharCode(133),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic
              ),
              )

            ],
          ),
          Container(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(top:18.0,right: 25,left: 25),
            child: FlatButton(


              //Sign in using email code>>>


              onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => OwnerDashboard()),
                      (Route<dynamic> route) => false,
                );
              },
              autofocus: true,
              child: Padding(
                padding: const EdgeInsets.only(right: 5,left: 5,top: 15,bottom: 15),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 24.0),
                      child:Icon(Icons.home,size: 34,),
                    ),
                    Text("Proceed to Dashboard",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.normal,
                          color: Colors.black54
                      ),
                    ),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.black)
              ),

            ),

          ),
      Padding(
        padding: const EdgeInsets.only(top:18.0,right: 25,left: 25),
        child: FlatButton(


          //Sign in using email code>>>


          onPressed: (){
            print('JSON->   $data');
            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context){
              return new AddProperty(data: data,);
            }));
          },
          autofocus: true,
          child: Padding(
            padding: const EdgeInsets.only(right: 0,left: 5,top: 15,bottom: 15),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 24.0),
                  child:Icon(Icons.receipt,size: 34,),
                ),
                Text("Register Another Room",
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      color: Colors.black54
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.black)
          ),

        ),
      )
        ],
      ),
    );
  }
}
