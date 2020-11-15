import '../sidebar/sidebar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../themes.dart';
import 'package:flutter/material.dart';



void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget{
  static const String routeName = "/MainScreen";
  @override
  _MainScreenState  createState() => _MainScreenState();

}


class _MainScreenState extends State<MainScreen>{

  @override
    Widget build(BuildContext context){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primaryColor:  Color(0xFF398AE5)),
          home: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: drawerBackgroundColor,
              title:Text('Personal Dairy')
              ),
              body:BlocProvider<NavigationBloc>(
                  create: (context) => NavigationBloc(),
                child:Stack( 
                  children:<Widget>[
                    BlocBuilder<NavigationBloc,NavigationStates>(
                    builder: (context,navigationState){
                      return navigationState as Widget;
                    },
                  ),
               SideBar(),
              ],
                ),    
           ),
          ) ,
        );
    }
}