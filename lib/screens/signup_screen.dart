import 'package:flutter/material.dart';
import '../fonts/fonts.dart';
import 'package:flutter/services.dart';

void main() => runApp(SignupScreen());

class SignupScreen extends StatefulWidget{
  static const String routeName = "/SignupScreen";
  @override
  _SignupScreenState  createState() => _SignupScreenState();

}


class _SignupScreenState extends State<SignupScreen>{

//Build TextBox 
Widget _buildEmailTF(){
  
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                      'Email',
                      style: kLabelStyle,
                    ),
          
                SizedBox(height: 10.0,),
                Container(
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle,
                    height: 60.0,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top:14.0),
                        prefixIcon: Icon(Icons.email,color:Colors.white),
                        hintText: 'Enter your Email',
                        hintStyle: kHintTextStyle,
                        ),

                    ),
                )
            ],
     );
  }

//Builds Password Label and TextBox
Widget _buildPassTF(){
    return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                      'Password',
                      style: kLabelStyle,
                    ),
          
                SizedBox(height: 10.0,),
                Container(
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle,
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
                        prefixIcon: Icon(Icons.lock,color:Colors.white),
                        hintText: 'Enter your Password',
                        hintStyle: kHintTextStyle,
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
                      'Confirm Password',
                      style: kLabelStyle,
                    ),
          
                SizedBox(height: 10.0,),
                Container(
                    alignment: Alignment.centerLeft,
                    decoration: kBoxDecorationStyle,
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
                        prefixIcon: Icon(Icons.lock,color:Colors.white),
                        hintText: 'Re-Type Password',
                        hintStyle: kHintTextStyle,
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
               child: RaisedButton(
                 elevation: 5.0,
                 onPressed: ()=> print('Signup Button Pressed'),
                 padding: EdgeInsets.all(15.0),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(30.0),
                 ),
                 color: Colors.white,
                 child: Text(
                   'SIGN UP',
                   style: TextStyle(
                    color: Color(0xFF527DAA),
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'OpenSans',
                   ),
                 ),
               ),
    );

}

//Builds LogIn button
Widget _buildlogInBtn(){
  return  GestureDetector(
       onTap: ()=>{
            Navigator.pop(context)
          }, 
          //print('Login'),
         child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Have an Account?  ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                TextSpan(
                  text :'Login',
                  style : TextStyle(
                    color : Colors.white,
                    fontSize : 18.0,
                    fontWeight : FontWeight.bold,
                  ),
                ),
              ],
            ),
         ), 
    );
}

 @override
Widget build(BuildContext context) {
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
                //Sign Up Label
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ), 
                  ),

                  //Email Label and Textbox
                  SizedBox(height: 30.0),
                  _buildEmailTF(),

                  //Password Label and Textbox
                  SizedBox(height: 30.0),
                  _buildPassTF(),

                   //Password Label and Textbox
                  SizedBox(height: 30.0),
                  _buildConfirmPassTF(),

                  //Remember me
                  //_buildRememberMeCheckBox(),

                   //Sign Up Button
                  _buildSignupBtn(),

                   //Login Button
                  _buildlogInBtn(),

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