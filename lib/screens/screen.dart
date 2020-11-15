import 'dart:async';
import '../screens/security_screen.dart';
import '../model/settings.dart';
import '../utils/database_helper_settings.dart';
import 'package:sqflite/sqflite.dart';
import '../sidebar/sidebar_layout.dart';
import 'package:flutter/material.dart';
import '../fonts/fonts.dart';
import 'package:flutter/services.dart';

void main() => runApp(Screen());

class Screen extends StatefulWidget{
  static const String routeName = "/Screen";
  @override
  _Screen  createState() => _Screen();

}


class _Screen extends State<Screen>{
  DatabaseHelper helper = DatabaseHelper();
  bool _isSecure = false;
  bool _isPin = false;

@override
Widget build(BuildContext context) {  
  _getList();
  Timer(
         Duration(seconds: 5),
                () {
                  if(_isSecure == true && _isPin == true){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => SecurityScreen()));
                  }
                  else
                  {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => SideBarLayout()));
                  }
                },
    );          
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus() ,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: <Widget>[
                         Container( 
                          height: 130.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16.0),
                            //color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white54,
                                offset: Offset(0,2),
                                blurRadius: 6.0,
                              )
                            ],
                            image: DecorationImage(
                              image: AssetImage('assets/images/icon.jpg'),
                            ),
                          ),
                         ),
                         Padding(
                           padding: EdgeInsets.only(top:10.0)
                          ),
                          Text(
                            'Personal Diary',
                            style:sLabelStyle,
                          ),
                           
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children:<Widget>[
                        CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                          Padding(
                            padding:EdgeInsets.only(top:30.0),
                          ),
                            Text(
                              'Developed By Akash Parit',
                              style: dLabelStyle,
                            ),
                            SizedBox(height: 6.0,),
                            Text(
                            'v0.1.0',
                            style:kLabelStyle,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
}

 _getList(){
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Settings>> settingsListFuture = helper.getNoteList();
      settingsListFuture.then((settingsList){
          setState(() {
            if(settingsList[0].security != null && settingsList[0].pin != null){
              _isSecure = true;
              _isPin = true;
            }
          });
      });
    });
  }


}// End of class