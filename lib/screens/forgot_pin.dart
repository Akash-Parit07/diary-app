import '../screens/set_security_pin.dart';
import '../model/settings.dart';
import '../utils/database_helper_settings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import '../fonts/fonts.dart';
import 'package:flutter/services.dart';

void main() => runApp(ForgotPinScreen());

class ForgotPinScreen extends StatefulWidget{

  @override
    _ForgotPinScreenState createState() => _ForgotPinScreenState();
}


//Login Page
class _ForgotPinScreenState extends State<ForgotPinScreen>{

final dobController = TextEditingController();
int flag = 0;
String _dob;
DatabaseHelper helper = DatabaseHelper();
Color iColor = Colors.white;
Color _borderColor =  Color(0xFF6CA8F1);
Color _boxShadow = Colors.black26;

//Builds Password Label and TextBox
Widget _buildPassTF(){
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                      'Birth-Date',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                      ),
                    ),
          
                SizedBox(height: 10.0,),
                Container(
                    alignment: Alignment.centerLeft,
                   decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border:Border.all(color:_borderColor),
                      color: Color(0xFF6CA8F1),
                      boxShadow: [
                        BoxShadow(
                          color: _boxShadow,
                          blurRadius: 5.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 60.0,
                    child: TextField(
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top:14.0),
                        prefixIcon: Icon(Icons.calendar_today,color:iColor),
                        hintText: 'DD/MM/YYYY',
                        hintStyle: kHintTextStyle,
                        ),
                      controller: dobController,
                    ),
                )
            ],
        );


  }

//Builds Login button
Widget _buildLoginBtn(){
  return  Container(
               padding: EdgeInsets.symmetric(vertical:25.0), 
               width: double.infinity,
               child: RaisedButton(
                 elevation: 5.0,
                 onPressed: (){
                   _verify();
                 },
                 padding: EdgeInsets.all(15.0),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(30.0),
                 ),
                 color: Colors.white,
                 child: Text(
                   'Verify',
                   style: TextStyle(
                    color: Colors.deepPurple,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
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
            if(settingsList[0].dob != null){
              _dob = settingsList[0].dob;
            }
          });
      });
    });
  }

 _verify(){
   if(dobController.text.length == 0){
     message('Enter Birth-Date');
     return;
   }
   if(_dob == dobController.text){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (BuildContext context) => SetPinScreen()));
   }
   else{
     setState(() {
       iColor = Colors.red;
       _borderColor = Colors.red;
       _boxShadow = Colors.red;
     });
     message('Incorrect Birth-Date');
   }
 }

 message(String msg){
   Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM ,// also possible "TOP" and "CENTER"
            backgroundColor: Colors.black87,
            textColor: Colors.white,);
 }

//To dispose the value in text controller when the widget is disposed.
@override
void dispose(){
    dobController.dispose();
    super.dispose();
  }


@override
Widget build(BuildContext context) {
    _getList();
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus() ,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1,0.4,0.7,0.9],
                  ),
                ),
              ),

            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical:120.0,
                ),
                //Sign In Label
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text(
                      'Forgot PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ), 
                  ),

                  
                  SizedBox(height: 30.0),
                  SizedBox(height: 30.0),
                  //Password Label and Textbox
                  SizedBox(height: 30.0),
                  _buildPassTF(),
                                  
                  SizedBox(height: 30.0),
                  //Login Button
                  _buildLoginBtn(),

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


}//end of class _SecurityScreenState








