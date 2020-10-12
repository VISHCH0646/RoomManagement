import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'done_page_owner.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();




class AddAppartment extends StatefulWidget {

  @override
  _AddAppartmentState createState() => _AddAppartmentState(_addr1,_addr2,_landmark,_city,_pincode,_building_name,_locality,_state);
  AddAppartment(this._addr1,this._addr2,this._landmark,this._city,this._pincode,this._building_name,this._locality,this._state);
  var _addr1,_addr2,_landmark,_city,_pincode,_building_name,_locality,_state;

}
ProgressDialog pr;

class _AddAppartmentState extends State<AddAppartment> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref;
  _AddAppartmentState(this._addr1,this._addr2,this._landmark,this._city,this._pincode,this._building_name,this._locality,this._state);
  var _addr1,_addr2,_landmark,_city,_pincode,_building_name,_locality,_state;
  final FirebaseStorage _storageee=FirebaseStorage(storageBucket: "gs://pg-finder-80f9c.appspot.com");
  var resultList;
  var _Owner_id;
  var _roomno,_rent,_desc;
  int _kitchen=0,_toilet=0;
  var _image;
  var _urlDownloads=List();
  bool uploaded=false;
  List <Asset> _images=List<Asset>();
  int _units;
  int _floornum=0;
  bool _RegisterDone=true;
  String _appttype="Select",_roomType="Select",url;
  double _min=0.0;
  var _images_url={};
//  Widget getImages(){
//    return GridView.count(
//      crossAxisCount: 3,
//      children: List.generate(_images.length, (index) {
//        Asset asset = _images[index];
//        return AssetThumb(
//          asset: asset,
//          width: 300,
//          height: 300,
//        );
//      }),
//    );
 // }
  Future saveImage(Asset asset,int i) async {
    ByteData byteData = await asset.getByteData(quality: 25);
    List<int> imageData =byteData.buffer.asUint8List();
    StorageReference ref = _storageee.ref().child("Images_room/${_Owner_id.toString()}/${_building_name.toString()}/${_roomno.text.toString()}/${i.toString()}");//FirebaseStorage.instance
    StorageUploadTask uploadTask = ref.putData(imageData);
    pr.update(
        //message: "Please wait...",
        progress:i.toDouble()*10,
//        progressWidget: Container(
//            padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())
    );
    var url=await (await uploadTask.onComplete).ref.getDownloadURL();
    _images_url["image${i}"]=url;
    //saveImg(url.toString(),i);
    //sssreturn await (await uploadTask.onComplete).ref.getDownloadURL();


  // print(_urlDownloads[i]);
   //return url.toString();
    }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pr = new ProgressDialog(context,showLogs: true,type: ProgressDialogType.Download,isDismissible: false);
    pr.style(
        message: 'Uploading Images...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.bounceInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    _roomno=TextEditingController(text: "");
    _rent=TextEditingController(text: "");
    _desc=TextEditingController(text: "");
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
        title: Text("Add Appartment"),
        backgroundColor: Colors.black,
      ),
      body: content,
      floatingActionButton: Visibility(
        child: FloatingActionButton(child: Icon(Icons.done),onPressed: ()async{

         // pr.show();
          getOwner();
          if(formValidate()) {
            pr.show();

              for (int i = 0; i < _images.length; i++) {
                print(i);
                //_urlDownloads[i]=
                     await saveImage(_images[i], i);
                print("Image Selected Successfully...");
              }
              pr.update(
                  message: "Please wait...",
                  progress:10.0 ,
                  progressWidget: Container(
                      padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())
              );
              var data={
                "buildingname":_building_name.toString(),
                "roomno":_roomno.text.toString(),
                "address":{
                  "address1":_addr1.toString(),
                  "address2":_addr2.toString(),
                  "landmark":_landmark.toString(),
                  "locality":_locality.toString(),
                  "city":_city.toString(),
                  "pin":_pincode.toString(),
                  "state":_state.toString()
                },
                "owner":_Owner_id.toString(),
                "floor":_floornum,
                "appttype":_appttype,
                "roomtype":_roomType,
                "kitchen":_kitchen==0?"Yes":"No",
                "toilet":_toilet==0?"Yes":"No",
                "rent":_rent.text.toString(),
                "desc":_desc.text.toString(),
                "images":_images_url,
                'status':false
//               {
//                  "image0":_urlDownloads[0],
//                  "image1":_urlDownloads[1],
//                  "image2":_urlDownloads[2],
//                  "image3":_urlDownloads[3],
//                  "image4":_urlDownloads[4],
//                  "image5":_urlDownloads[5],
//                  "image6":_urlDownloads[6],
//                  "image7":_urlDownloads[7],
//                  "image8":_urlDownloads[8],
//                  "image9":_urlDownloads[9],
//                }

              };
              var buildings={
                "building-name":_building_name.toString(),
                "address":{
                  "address-1":_addr1.toString(),
                  "address-2":_addr2.toString(),
                  "landmark":_landmark.toString(),
                  "locality":_locality.toString(),
                  "city":_city.toString(),
                  "pin":_pincode.toString(),
                  "state":_state.toString()
                },
                "owner":_Owner_id.toString(),

              };
              database.reference().child("Property").push().set(data);
              database.reference().child("Buildings").push().set(buildings);
              pr.dismiss();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Done(data: buildings,)),
                    (Route<dynamic> route) => false,
              );


          }

          
        },
          backgroundColor: Colors.black,
          
        ),
        visible: true,
      ),
    );
  }

  Widget ifPortrait() {

    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:18.0,left: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Step 2 ->",
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,

                    ),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right:9.0,left: 9.0,top: 35),
              child: Container(
                height: 1.5,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Text("Floor Number: ",
                    style: TextStyle(
                      fontSize: 18
                ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:13.0,top: 15.0),
                    child: DropdownButton<int>(

                      //icon: Icon(Icons.business),
                      value: _floornum,
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      onChanged: (int newValue){
                        setState(() {
                          _floornum=newValue;
                        });
                      },
                      items: <int>[0,1,2,3,4].map<DropdownMenuItem<int>>((int value){
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Container(
                            width: 150,
                            child: Center(
                              child: Text(value.toString(),
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
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Text("Room No. : ",
                      style: TextStyle(
                          fontSize: 18
                      ),),
                  ),
                  Container(
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Container(
                      height: 40,
                      width: 100,
                      child: TextField(
                        controller: _roomno,
                          keyboardType: TextInputType.text,
                          //obscureText: true,
                          decoration: InputDecoration(hintText: "",labelText: "",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5),],
                      ),
                    ),
                  )

                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Text("Appartment Type: ",
                      style: TextStyle(
                          fontSize: 18
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:13.0,top: 15.0),
                    child: DropdownButton<String>(

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
                      items: <String>["Select","Furnished","Unfurnished"].map<DropdownMenuItem<String>>((String value){
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


                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Text("Room Type: ",
                      style: TextStyle(
                          fontSize: 18
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:50.0,top: 10.0),
                    child: DropdownButton<String>(

                      //icon: Icon(Icons.business),
                      value: _roomType,
                      style: TextStyle(
                        color: Colors.black45,
                      ),
                      onChanged: (String newValue){
                        setState(() {
                          _roomType=newValue;
                        });
                      },
                      items: <String>["Select","1 BHK","2 BHK","3 BHK","4 BHK"].map<DropdownMenuItem<String>>((String value){
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

                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Text("Kitchen: ",
                      style: TextStyle(
                          fontSize: 18
                      ),),
                  ),
                  Container(
                    width: 67,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Radio<int>(
                        activeColor: Colors.black,
                        value: 0,
                        groupValue: _kitchen,
                        onChanged: _handle
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Text("Yes"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Radio<int>(
                        activeColor: Colors.black,
                        value: 1,
                        groupValue: _kitchen,
                        onChanged: _handle
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Text("No"),
                  ),

                ],
              ),


            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Text("Attatched Toilet: ",
                      style: TextStyle(
                          fontSize: 18
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Radio<int>(
                        activeColor: Colors.black,
                        value: 0,
                        groupValue: _toilet,
                        onChanged: _Toilet
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Text("Yes"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Radio<int>(
                        activeColor: Colors.black,
                        value: 1,
                        groupValue: _toilet,
                        onChanged: _Toilet
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Text("No"),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Text("Rent (Rs.): ",
                      style: TextStyle(
                          fontSize: 18
                      ),),
                  ),
                  Container(
                    width: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:15.0,left: 8.0),
                    child: Container(
                      height: 40,
                      width: 100,
                      child: TextField(
                          controller: _rent,
                          keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                          //obscureText: true,
                          decoration: InputDecoration(hintText: "",labelText: "",
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                                gapPadding: 3.3),
                          ),
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(6),
                          WhitelistingTextInputFormatter.digitsOnly,
                      ]),
                    ),
                  )

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right:9.0,left: 9.0,top: 35),
              child: Container(
                height: 1.5,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top:0.0,left: 8.0),
                child: Text("Description:",
                  style: TextStyle(
                      fontSize: 18
                  ),),
              ),
            ),
            Container(
              height: 80,
              width: 300,
              child: TextField(
                keyboardType: TextInputType.multiline,
                controller: _desc,
                maxLines: null,
                  decoration: InputDecoration(hintText: "Provide Brief Room Summary",labelText: "",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0),
                        gapPadding: 3.3),
                  )


              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right:9.0,left: 9.0,top: 10),
              child: Container(
                height: 1.5,
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.only(top:0.0,left: 8.0),
                child: Text("Images:",
                  style: TextStyle(
                      fontSize: 18
                  ),),
              ),
            ),
            Visibility(
              child: Container(
                height: 60,
                width: 200,
                child: Column(
                  children: <Widget>[
                    InkWell(child: Icon(Icons.camera_alt,size: 40,),
                    onTap: chooseFile,
                    ),
                    Text("Click Here to Add Images")
                  ],
                ),
              ),
              visible: !uploaded,
            ),
           Visibility(
             child: Text("${_images.length} images selected"),
             visible: uploaded,
           )
           // Stack(child: AssetThumb(asset: _images[0], width: 30, height: 30))




          ],

        )
      ],
    );

  }

  void _handle(int value) {
    setState(() {
      _kitchen=value;
    });
  }

  void _Toilet(int value) {
    setState(() {
      _toilet=value;
    });
  }

  Future chooseFile()async {
    print("Hello 1");
//    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
//      setState(() {
//        print("hello");
//        _image = image;
//      });
//    });
    resultList = await MultiImagePicker.pickImages(

      maxImages :  10 ,
      enableCamera: true,
            //cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat")
    );
    print(resultList);
    setState(() {
      _images=resultList;
      uploaded=true;
    });
  }

  void getOwner()async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    _Owner_id=preferences.getString("Owner_session");
  }

  bool formValidate() {
    if(_roomno.text.toString().isEmpty){
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text(
              "Please enter Room No.!!!")));
      return false;
    }
    if(_appttype=="Select"){
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text(
              "Please select Appartment Type!!!")));
      return false;
    }
    if(_roomType=="Select"){
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text(
              "Please select Room Type!!!")));
      return false;
    }
    if(_rent.text.toString().isEmpty)
      {
        _scaffoldKey.currentState.showSnackBar(
            new SnackBar(content: Text(
                "Please enter Room Rent!!!")));
        return false;
      }
    if(_desc.text.toString().length<10){
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text(
              "Please Provide Room Description: Minimum 10 characters")));
      return false;
    }
    if(_images.length<1){
      _scaffoldKey.currentState.showSnackBar(
          new SnackBar(content: Text(
              "Please Upload Images")));
      return false;

    }
    return true;
  }

  void saveImg(String url,int i) {
    print("in save");
    _urlDownloads[i]=(url);
  }
}
