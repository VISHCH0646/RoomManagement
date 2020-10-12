import 'package:firebase_database/firebase_database.dart';

class Property{
  String bname,rno,city,image;
  var key;
  Property(this.bname,this.rno,this.city,this.image);
  Property.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        bname = snapshot.value["buildingname"],
        rno = snapshot.value["roomno"],
        city=snapshot.value['address']["city"],
        image=snapshot.value['images']['image0'];

  }







