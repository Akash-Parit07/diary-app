import 'dart:async';

import '../model/settings.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/database_helper_settings.dart';
import '../fonts/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../sidebar/menu_item.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> isSidebarOpenedStreamController;
  Stream<bool> isSidebarOpenedStream;
  StreamSink<bool> isSidebarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);
  int currentSelectedIndex = 0;
  String _userName = "User";
  String _birthDate = "";

  DatabaseHelper helper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
    _getList();

  }

   _getList(){
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Settings>> settingsListFuture = helper.getNoteList();
      settingsListFuture.then((settingsList){
          setState(() {
            if(settingsList[0].name != null){
              _userName = settingsList[0].name;
            }
            if(settingsList[0].dob != null){
              _birthDate = settingsList[0].dob;
            }
          });
      });
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if (isAnimationCompleted) {
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color(0xFF398AE5),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                      ),
                      ListTile(
                        title: Text(
                          _userName,
                          style: dashLabelStyle,
                        ),
                        subtitle: Text(
                          _birthDate,
                          style: TextStyle(
                                color: Colors.white60,
                                fontWeight: FontWeight.w300,
                                fontSize: 20,
                                fontFamily: 'OpenSans',
                              ),
                        ),
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 35,
                          ),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 1,
                        color: Colors.black54,
                        indent: 20,
                        endIndent: 20,
                      ),
                      MenuItem(
                        icon: Icons.insert_chart,
                        title: "Dash Board",
                        onTap: () {
                          onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.DashBoardClickedEvent);                      },
                      ),
                      MenuItem(
                        icon: Icons.book,
                        title: "Read",
                        onTap: () {
                          onIconPressed();
                             BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.ReadClickedEvent);
                        },
                      ),
                      MenuItem(
                        icon: Icons.insert_comment,
                        title: "Write",
                        onTap: () {
                          onIconPressed();
                             BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.WriteClickedEvent);
                        },
                      ),
                      MenuItem(
                        icon: Icons.event,
                        title: "Events",
                        onTap: () {
                          onIconPressed();
                             BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.EventsClickedEvent);
                        },
                      ),
                      Divider(
                       height: 54,
                        thickness: 1,
                        color: Colors.black54,
                        indent: 20,
                        endIndent: 20,
                      ),
                      MenuItem(
                        icon: Icons.settings,
                        title: "Settings",
                        onTap: () {
                          onIconPressed();
                             BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.SettingsClickedEvent);
                        },
                      ),        
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xFF398AE5),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
