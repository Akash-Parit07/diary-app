import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

import '../fonts/fonts.dart';
import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class EventsScreen extends StatefulWidget with NavigationStates {
  static const String routeName = "/EventsScreen";
   @override
  _EventsScreen  createState() => _EventsScreen();
}




class _EventsScreen extends State<EventsScreen>{

 DateTime currentBackPressTime;
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;
  String selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {  
        currentBackPressTime = now;
          Fluttertoast.showToast(msg: 'Press again to exit app',toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM ,// also possible "TOP" and "CENTER"
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            );
        return Future.value(false);
      }

      return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope( 
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
            title: 
            Center(
              child:Text('Events')
              ),
            /*leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            ), */
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding:EdgeInsets.only(bottom:20),
                ),
                    TableCalendar(
                  events: _events,
                  initialCalendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                      canEventMarkersOverflow: true,
                      todayColor: Colors.orange,
                      selectedColor: Theme.of(context).primaryColor,
                      todayStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.white)),
                  headerStyle: HeaderStyle(
                    centerHeaderTitle: true,
                    formatButtonDecoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonShowsNext: false,
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (date, events) {
                    setState(() {
                      _selectedEvents = events;
                    });
                  },
                  builders: CalendarBuilders(
                    selectedDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context).accentColor,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                    todayDayBuilder: (context, date, events) => Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  calendarController: _controller,
                ),
                ..._selectedEvents.map((event) => Card(
                      elevation: 2.0,
                      color: Colors.white,
                      child: ListTile(
                          leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                            child: Icon(
                              Icons.keyboard_arrow_right,
                            ),
                          ),
                          title: Text(event,style: dLabelStyle,),
                          subtitle: Text(_controller.selectedDay.day.toString()+'/'+_controller.selectedDay.month.toString()+'/'+_controller.selectedDay.year.toString(),style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'OpenSans',
                                  ),),   
                        /* trailing: GestureDetector(
                            child: Icon(
                            Icons.delete,
                            ),         
                          onTap: (){
                          // print(_events[_controller.selectedDay]);
                          },
                          ),*/
                        ),
                    ),
                )],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
                _showAddDialog();
            },
          ),
        ),
    );
  }

 /* _catchCancellation(){
     showDialog(
                context: context,
                builder: (context){
                          return AlertDialog(
                            shape:  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
                            title: Text(' ',style: wLabelStyle,),
                            content: SingleChildScrollView( 
                              child: ListBody(
                                children:<Widget>[
                                    Text('Cancelled !',style: wLabelStyle,),
                                ],
                              ),     
                            ),

                            actions: <Widget>[
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                       },
                      );
  }*/

  _showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
               shape:  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
               title: Text('Add Event',style: wLabelStyle,),

              content: TextField(
                controller: _eventController,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                ),
              ),
              actions: <Widget>[
                 /* FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                        _eventController.text = 'Something';
                         _events[_controller.selectedDay]
                          .add(_eventController.text);
                        Navigator.pop(context);
                    }
                  ),*/
                FlatButton(
                  child: Text("Save"),
                  onPressed: () {
                     if (_eventController.text.isEmpty) {
                      return;
                    }
                    if (_events[_controller.selectedDay] != null) {
                      try{
                         _events[_controller.selectedDay]
                          .add(_eventController.text);
                      }
                      catch(e){
                        Navigator.pop(context);
                      }
                     
                    } else {
                       if (_eventController.text.isEmpty) {
                        _eventController.text = "Some";
                       }
                       
                        _events[_controller.selectedDay] = [
                          _eventController.text
                        ];
                      
                    }
                    prefs.setString("events", json.encode(encodeMap(_events)));
                    _eventController.clear();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
    setState(() {
      _selectedEvents = _events[_controller.selectedDay];
    });
  }



}// End of class

