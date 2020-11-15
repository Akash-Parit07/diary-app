
//import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/settings.dart';
import '../utils/database_helper_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:image_picker/image_picker.dart';

void main() => runApp(EditProfile());

class EditProfile extends StatefulWidget{

  @override
  _EditProfileState  createState() => _EditProfileState();

}


class _EditProfileState extends State<EditProfile>{

 // File _image;
  TextEditingController _nameTEC;
  TextEditingController _birthDateTEC;
  DatabaseHelper helper;
  

@override
void initState() { 
  super.initState();
  _nameTEC = TextEditingController();
  _birthDateTEC = TextEditingController();
  helper = DatabaseHelper();
}

Widget _buildNameTF(){
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
          
                SizedBox(height: 10.0,),
                Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 60.0,
                    child: TextField(
                      controller: _nameTEC,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top:14.0),
                        prefixIcon: Icon(Icons.supervised_user_circle,color:Colors.black),
                        hintText: 'Enter your name',
                        hintStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'OpenSans',
                            ),
                        ),

                    ),
                )
            ],
        );
  }

Widget _buildBirthdateTF(){
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                      'Birth-Date',
                      style:  TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
          
                SizedBox(height: 10.0,),
                Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 60.0,
                    child: TextField(
                      controller: _birthDateTEC,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top:14.0),
                        prefixIcon: Icon(Icons.date_range,color:Colors.black),
                        hintText: 'DD/MM/YYYY',
                        hintStyle: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'OpenSans',
                            ),
                        ),

                    ),
                )
            ],
        );
  }

Widget _buildSaveBtn(){
  return  Container(
               padding: EdgeInsets.symmetric(vertical:25.0), 
               width: double.infinity,
               child: RaisedButton(
                 elevation: 5.0,
                 onPressed: ()=> save(),
                 padding: EdgeInsets.all(15.0),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(30.0),
                 ),
                 color: Colors.blueAccent,
                 child: Text(
                   'SAVE',
                   style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                   ),
                 ),
               ),
    );

}

/*Widget _buildSelectImage(){
      return Padding(
      padding: EdgeInsets.only(left:10.0,right:10.0,top:10.0,),
      child: InkWell(
        onTap: () => print(' '),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children:[
                  FloatingActionButton(
                            onPressed: ()=> _pickFromCamera(),
                            tooltip: 'Image',
                            child: Icon(Icons.camera_alt,color: Colors.black,),
                              backgroundColor: Colors.blueAccent
                            ),
                  SizedBox(width:18.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Select profile image',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold
                            )
                        ),
                      ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
  }

_pickFromCamera() async{
   // File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
     if(img != null){
       _image = img;
       setState(() {
       });
     }
  }*/
 
save() async {
  Settings sett = Settings();
  int res;
  if( _nameTEC.text.length == 0 || _birthDateTEC.text.length == 0){
    message('Please add name & birthdate');
    return;
  }

  try{
    sett.name = _nameTEC.text;
    sett.dob = _birthDateTEC.text;
    res = await helper.updateProfile(sett);
    message('Profile Saved');
    _nameTEC.text = '';
    _birthDateTEC.text = '';
  }
  catch(e){
    message('Error while saving profile');
  }
}
 
message(String msg){
     Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM ,// also possible "TOP" and "CENTER"
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              );
  }
 @override
Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        Padding(
          padding: EdgeInsets.only(left:60.0),
          child:Text('Edit Profile')
          ),
         leading: IconButton(
         icon: Icon(Icons.arrow_back, color: Colors.black),
         onPressed: () => Navigator.of(context).pop(),
         ), 
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus() ,
          child: Stack(
            children: <Widget>[
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical:30.0,
                ),
        
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.person,size:40),
                    radius: 50,
                  ),
            
                  //Password Label and Textbox
                  SizedBox(height: 30.0),
                  _buildNameTF(),

                   //Password Label and Textbox
                  SizedBox(height: 30.0),
                  _buildBirthdateTF(),

                  //SizedBox(height: 30.0),
                  //_buildSelectImage(),

                  SizedBox(height: 50.0),
                   //Sign Up Button
                  _buildSaveBtn(),


                ],
                ), 
              ),

            )

            ],
          ),
        ),
      ),
    );
  }

}

