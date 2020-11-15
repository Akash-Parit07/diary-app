import 'package:fluttertoast/fluttertoast.dart';
import '../model/settings.dart';
import '../utils/database_helper_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(SetPinScreen());

class SetPinScreen extends StatefulWidget{

  @override
  _SetPinScreenState  createState() => _SetPinScreenState();

}


class _SetPinScreenState extends State<SetPinScreen>{

DatabaseHelper helper = DatabaseHelper();
TextEditingController _pin;
TextEditingController _confirmPin;
Color _borderColor;
//int _intPin,_intConfirmPin;

@override
void initState() { 
  super.initState();
  _pin = TextEditingController();
  _confirmPin = TextEditingController();
   _borderColor = Colors.black;
   
}

//Builds Password Label and TextBox
Widget _buildPassTF(){
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                      'PIN',
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
                      border:Border.all(color:_borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: _borderColor,
                          blurRadius: 5.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 60.0,
                    child: TextField(
                      controller: _pin,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top:14.0),
                        prefixIcon: Icon(Icons.lock,color:Colors.black),
                        hintText: 'Enter your PIN',
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

// Confirm Password textbox
Widget _buildConfirmPassTF(){
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                      'Confirm PIN',
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
                      border:Border.all(color:_borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: _borderColor,
                          blurRadius: 5.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    height: 60.0,
                    child: TextField(
                      controller: _confirmPin,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'OpenSans',
                        ),
                      onChanged:(value){
                        if(_pin.text == _confirmPin.text){
                          setState(() {
                            _borderColor = Colors.green;
                          });
                        }
                        else{
                           setState(() {
                            _borderColor = Colors.red;
                          });
                        }
                      },
                      //maxLength: 4,
                      //maxLengthEnforced: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top:14.0),
                        prefixIcon: Icon(Icons.lock,color:Colors.black),
                        hintText: 'Re-Type PIN',
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

//Builds SignUp button
Widget _buildSignupBtn(){
  return  Container(
               padding: EdgeInsets.symmetric(vertical:25.0), 
               width: double.infinity,
               height: 105,
               child: RaisedButton(
                 elevation: 7.0,
                 onPressed: ()=> save(),
                 padding: EdgeInsets.all(15.0),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(30.0),
                 ),
                 color: Colors.blueAccent,
                 child: Text(
                   'SET PIN',
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

save() async {
  Settings sett = Settings();
  int res = 0;
  if(_pin.text == _confirmPin.text){  
    try{
      sett.pin = int.parse(_confirmPin.text);
      res = await helper.updatePin(sett);
      message('Pin Saved');
       Navigator.of(context).pop();
    }
    catch(e){
      message('Enter only numbers');
    }
  }
  else{
    message('Re-enter PIN');
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
          padding: EdgeInsets.only(left:50.0),
          child:Text('Set Security PIN')
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
                  vertical:80.0,
                ),
        
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
            
                  //Password Label and Textbox
                  SizedBox(height: 30.0),
                  _buildPassTF(),

                   //Password Label and Textbox
                  SizedBox(height: 30.0),
                  _buildConfirmPassTF(),

                  SizedBox(height: 50.0),
                   //Sign Up Button
                  _buildSignupBtn(),


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