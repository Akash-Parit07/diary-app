import 'package:fluttertoast/fluttertoast.dart';

import '../fonts/fonts.dart';
import '../model/diary.dart';
import '../utils/database_helper.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../utils/utility.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';


class WriteScreen extends StatefulWidget with NavigationStates {

   @override
  WriteScreenState  createState() => WriteScreenState();
}



class WriteScreenState extends State<WriteScreen> {
  //DatabaseHelper databaseHelper = DatabaseHelper();
  DatabaseHelper helper = DatabaseHelper();
  Diary diary;

  
  DateTime pickedDate;
  TimeOfDay pickedTime;
  var week = new List();
 // var month = new List();
 
  File image;
  String imgString;
  String location;
  String date;
  String time;
  TextEditingController _locationController;
  TextEditingController _titleController;
  TextEditingController _noteController;
   DateTime currentBackPressTime;

  @override
  void initState(){
    super.initState();
    pickedDate = DateTime.now();
    date = (_getWeekDay(pickedDate.weekday).toString()+', '+ pickedDate.day.toString()+' '+_getMonth(pickedDate.month).toString()+' '+pickedDate.year.toString() );
    pickedTime = TimeOfDay.now();
    time = (pickedTime.hour.toString()+':'+pickedTime.minute.toString());
    _locationController = TextEditingController();
    _titleController = TextEditingController();
    _noteController = TextEditingController();
    location = "Select Location";
  }

  @override
  void dispose(){
    _locationController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _save() async{

    if(_titleController.text.length == 0){
      _displayToastMessage('Please enter the title');
      return;
    }
  
    //print('string - ');
    //print(Utility.imageFromBase64String(imgString));
    
    Diary diary = Diary(_titleController.text, date, time,imgString,_noteController.text,_locationController.text);
    int result;
    try{
      result = await helper.insertDiary(diary);
    }
    catch(e){
      _displayToastMessage('Error while writing diary');
    }

    if(result != 0)
    {
      _displayToastMessage('Diary written successfully');
      setState(() {
        _locationController.text = '';
        _titleController.text = '';
        _noteController.text = '';
        image = null;
      });
      //print(diary.title);
      //print(diary.note);
      //print(diary.place);
      //print(diary.date);
      //print(diary.time);
      //print(diary.image);
    }
    else
    {
      _displayToastMessage('Error while writing diary');
    }
  }


 _displayToastMessage(String msg){
     Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM ,// also possible "TOP" and "CENTER"
            backgroundColor: Colors.black87,
            textColor: Colors.white,);
  }

Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {  
        currentBackPressTime = now;
         _displayToastMessage('Press again to exit app');
        return Future.value(false);
      }

      return Future.value(true);
  }

_pickDate() async{
    DateTime date1 = await showDatePicker(
      context: context, 
      initialDate: pickedDate, 
      firstDate: DateTime(DateTime.now().year-20), 
      lastDate: DateTime(DateTime.now().year+20)
    );
    if(date1 != null)
      setState(() {
        pickedDate = date1;
        date = (_getWeekDay(pickedDate.weekday).toString()+', '+ pickedDate.day.toString()+' '+_getMonth(pickedDate.month).toString()+' '+pickedDate.year.toString() );
      });
  }

_pickTime() async{
    TimeOfDay t = await showTimePicker(
      context: context, 
      initialTime: pickedTime
      );
      if(t != null)
        setState(() {
          pickedTime = t;
          time = (pickedTime.hour.toString()+':'+pickedTime.minute.toString());
        });
  } 

String _getWeekDay(int dayNum){
    week = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return(week[dayNum-1]);
  }

String _getMonth(int monNum){
    week = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return(week[monNum-1]);
  }

_pickFromCamera() async{
   // File img = await ImagePicker.pickImage(source: ImageSource.gallery);
     File img;
     try{
       img = await ImagePicker.pickImage(source: ImageSource.gallery);
       imgString = Utility.base64String(img.readAsBytesSync());
     }
     catch(e){
       //print('error');
     }
     if(img != null){
       setState(() {
          image = img;
       });
     }
  }

Widget _buildCalenderIconBtn(){
      return Padding(
        padding: EdgeInsets.only(left:10.0,top:10.0,),
        child: InkWell(
          onTap: () => print(' '),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Row(
                  children:[
                    FloatingActionButton(
                              onPressed: ()=> _pickDate(),
                              tooltip: 'Calender',
                              child: Icon(Icons.calendar_today,color: Colors.white,),
                              backgroundColor: Color(0xFF398AE5),
                              ),
                      SizedBox(width:18.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '$date',
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

Widget _buildClockIconBtn(){
      return Padding(
      padding: EdgeInsets.only(left:10.0,top:10.0,),
      child: InkWell(
        onTap: () => print(' '),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children:[
                  FloatingActionButton(
                            onPressed: ()=>_pickTime(),
                            tooltip: 'Clock',
                            child: Icon(Icons.timer,color: Colors.white,),
                              backgroundColor: Color(0xFF398AE5),
                            ),
                  SizedBox(width:18.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$time',
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
 
Widget _buildTitleField(){
   
      return Padding(
					    padding: EdgeInsets.only(top: 30.0, bottom: 15.0,right: 10),
					    child: TextField(
						    controller: _titleController,
						    style: textStyle,
						    onChanged: (value) {
						    	//debugPrint('Something changed in Title Text Field');
						    },
						    decoration: InputDecoration(
							    labelText: 'Title',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(8.0)
							    ),
                   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54),),
                   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
					     ),
              ),
				    );
  }

Widget _buildEditNotesField(){
      return Padding(
					    padding: EdgeInsets.only(top: 20.0, bottom: 15.0,right: 10.0),
					    child: TextField(
						    controller: _noteController,
                 keyboardType: TextInputType.multiline,
                 minLines: 2,
                  maxLines: 5,
						    style: textStyle,
						    onChanged: (value) {
						    //	debugPrint('Something changed in Title Text Field');
						    },
						    decoration: InputDecoration(
							    labelText: 'Note',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(8.0)
							    ),
                   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54),),
                   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
					     ),
              ),
				    );
  }

Widget _buildSelectImage(){
      return Padding(
      padding: EdgeInsets.only(left:10.0,right:10.0,top:8.0,),
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
                            child: Icon(Icons.camera_alt,color: Colors.white,),
                              backgroundColor: Color(0xFF398AE5),
                            ),
                  SizedBox(width:18.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Select image',
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

Widget _buildSelectLocation(){
       return Padding(
					    padding: EdgeInsets.only(top: 25.0, bottom: 35.0,right: 10),
					    child: TextField(
						    controller: _locationController,
						    style: textStyle,
						    onChanged: (value) {
						    	//debugPrint('Something changed in Title Text Field');
						    },
						    decoration: InputDecoration(
							    labelText: 'Place/Location',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(8.0)
							    ),
                   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black54),),
                   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green),),
					     ),
              ),
				    );
  }

Widget _buildImageField(){
    return Center(
        child:Padding(
        padding: EdgeInsets.only(left:10.0,right: 5.0),
         child:InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  width: 262,
                  height: 180.0,
                  //color: Colors.grey,
                  child: Center(
                    child:image == null
                          ? Text('No image selected',
                             style: TextStyle(
                              fontFamily: 'NexaLight',
                              fontSize: 19.0,
                              fontWeight: FontWeight.bold
                            )
                          )
                          :  
                              Image.file(
                                 image,
                              fit: BoxFit.cover,
                              ),   
                  ),
                )
              ],
            ),
          ),
        ),
    );
       
  }

  @override
  Widget build(BuildContext context) {
     
      return WillPopScope( 
      onWillPop: onWillPop,
          child: Scaffold(
          appBar: AppBar(
            title:Center(
              child: Text('Write Diary'),
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
                      vertical:0.0,
                    ),
            
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                      _buildImageField(),
                      _buildCalenderIconBtn(),
                      _buildClockIconBtn(),
                      _buildTitleField(),
                      _buildEditNotesField(),
                      _buildSelectImage(),
                      _buildSelectLocation(),


                    ],
                    ), 
                  ),

                )

                ],
              ),
            ),
          ),
        floatingActionButton:FloatingActionButton(
                      onPressed: ()=>_save(),
                      tooltip: 'Done',
                      child: Icon(Icons.done,color: Colors.white,),
                                  backgroundColor: Colors.deepPurple,
                    ),
      
        ),
      );
      
  }   

} // end of class
