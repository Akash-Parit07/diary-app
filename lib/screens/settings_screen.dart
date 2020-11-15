import 'package:sqflite/sqflite.dart';

import '../model/settings.dart';
import '../screens/set_security_pin.dart';
import '../utils/database_helper_settings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';

import 'edit_profile.dart';

class SettingsScreen extends StatefulWidget with NavigationStates {
  static final String path = "lib/src/screens/settings_screen.dart";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dark;
  bool _security;
  bool _isProfileAdded;
  DatabaseHelper helper = DatabaseHelper();
  Settings settings;
  List<Settings> settingsList;
  int count = 0;
   DateTime currentBackPressTime;

  @override
  void initState() { 
    super.initState();
    _dark = false;
    _security = false;
    _isProfileAdded = false;
    if(settingsList == null){
      settingsList = List<Settings>();
      _getList();
    }    
  }

Brightness _getBrightness() {
     return _dark ? Brightness.dark : Brightness.light;
  }

 _getList(){
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Settings>> settingsListFuture = helper.getNoteList();
      settingsListFuture.then((settingsList){
          setState(() {
            if(settingsList[0].security == 0){
              _security = false;
            }
            else{
              _security = true;
            }

            if(settingsList[0].darkMode == 0){
              _dark = false;
            }
            else{
              _dark = true;
            }

            //print(settingsList[0].dob);
            if((settingsList[0].name == null) && (settingsList[0].dob == null)){
              _isProfileAdded =  false;
            }
            else{
              _isProfileAdded = true;
            }

          });
      });
    });
  }

void toggleSwitch(bool value) {
 
      if(_dark == false)
      {
        setState(() {
          _dark = true;
          
          //textHolder = 'Switch is ON';
        });
       // print('Switch is ON');
        // Put your code here which you want to execute on Switch ON event.
 
      }
      else
      {
        setState(() {
          _dark = false;
           //textHolder = 'Switch is OFF';
        });
        //print('Switch is OFF');
        // Put your code here which you want to execute on Switch OFF event.
      }
    _updateDark();
  }

 _updateDark() async{
    Settings sett = Settings();
    int result ;
     if(_dark == true){
          sett.darkMode = 1;
             
            try{
              result = await helper.updateDarkMode(sett);
            }
            catch(e){

            }
           
      }

      if(_dark == false){
          sett.darkMode = 0;
             
            try{
              result = await helper.updateDarkMode(sett);
            }
            catch(e){

            }
      }
      

  }

dynamic securitySwitch (bool value) {
 
      if(_security == false)
      {
        setState(() {
          _security = true;
            //textHolder = 'Switch is ON';
        });
       // print('Switch is ON');
        // Put your code here which you want to execute on Switch ON event.
      }
      else
      {
        setState(() {
          _security = false;
        });
        //print('Switch is OFF');
        // Put your code here which you want to execute on Switch OFF event.
      }  

      _updateSecurity();   
  }

 _updateSecurity() async {
    Settings sett = Settings();
    int result ;
     if(_security == true){
          sett.security = 1;
             
            try{
              result = await helper.updateSecurity(sett);
            }
            catch(e){

            }
           
      }

      if(_security == false){
          sett.security = 0;
             
            try{
              result = await helper.updateSecurity(sett);
            }
            catch(e){

            }
      }
      
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

_displayToastMessage(String msg){
     Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM ,// also possible "TOP" and "CENTER"
            backgroundColor: Colors.black87,
            textColor: Colors.white,);
  }

 
  @override
  Widget build(BuildContext context) {
    return WillPopScope( 
      onWillPop: onWillPop,
      child: Theme(
      isMaterialAppTheme: true,
      data: ThemeData(
        brightness: _getBrightness(),
      ),
      child: Scaffold(
        backgroundColor: _dark ? null : Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          brightness: _getBrightness(),
          iconTheme: IconThemeData(color: _dark ? Colors.white : Colors.black),
          backgroundColor: Colors.transparent,
          
          title:Center(  
            child:Text(
            'Settings',
            style: TextStyle(color: _dark ? Colors.white : Colors.black),
            ),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.only(left:16.0,right:16.0,bottom:16.0,top:40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.blueAccent,
              
                    child: ListTile(
                      onTap: () {
                         Navigator.of(context).push(MaterialPageRoute(
                           builder: (BuildContext context) => EditProfile())
                             );
                      },
                      
                      title: Text(
                        "Add Profile Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leading: CircleAvatar(
                       child: Icon(
                         Icons.person,
                       ),
                      ),
                      trailing: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                 
                  const SizedBox(height: 20.0),
                  


                  SwitchListTile(
                    onChanged: toggleSwitch,
                    value: _dark,
                    activeColor: Colors.purple,
                    contentPadding: const EdgeInsets.all(0),
                    title: Text("Dark Mode(Only for settings)"),
                  ),
         
                  SwitchListTile(
                    onChanged: securitySwitch,
                    value: _security,
                    activeColor: Colors.purple,
                    contentPadding: const EdgeInsets.all(0),
                    title: Text("Security"),
                  ),

                  SizedBox(height: 20.0),
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                       
                          ListTile(
                          leading: Icon(
                            Icons.lock_outline,
                            color: Colors.purple,
                          ),
                          title: Text("Set/Change PIN"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                             _getList();
                            if((_security == false)){
                            _displayToastMessage('Please add profile and set security ON');
                            }
                            if((_isProfileAdded == false)){
                            _displayToastMessage('Please add profile and set security ON');
                            }              
                            else
                            {
                               Navigator.of(context).push(MaterialPageRoute(
                               builder: (BuildContext context) => SetPinScreen())
                             );
                            }
                          },
                       ),
                       
                      ],
                    ),
                  ),
              
                  /* Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.purple,
                          ),
                          title: Text("Export as PDF"),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            //open change language
                          }
                        ),
                       
                      ],
                    ),
                  ),*/
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
           
          ],
        ),
      ),
      ),
    );
  }
 
}//End of class
















      //  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      
