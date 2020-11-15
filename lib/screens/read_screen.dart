import 'package:fluttertoast/fluttertoast.dart';
import '../utils/utility.dart';
import 'package:sqflite/sqflite.dart';
import '../fonts/fonts.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import '../model/diary.dart';
import '../utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ReadScreen extends StatefulWidget with NavigationStates {
  @override
  _ReadScreen createState() => _ReadScreen();
   //ReadScreen([this.diary,this.title,this.date,this.place,this.img,this.note]);
   
}

class _ReadScreen extends State<ReadScreen> {

  DatabaseHelper helper = DatabaseHelper();
  List<Diary> diaryList;
  List<Diary> imageList;
  int count = 0;
  int i = 0;
  DateTime currentBackPressTime;

  DateTime pickedDate;
  var week = new List();
  String _date;
 /* Image getImage(photoReference) {
    final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
    final maxWidth = "1000";
    final maxHeight = "200";
    final url = "$baseUrl?maxwidth=$maxWidth&photoreference=$photoReference&key=$PLACES_API_KEY";
    return Image.network(url, fit: BoxFit.cover);
  }*/

  int _current = 0;
  String firstHalfNote;
  String secondHalfNote;
  String _title;
  String _place;
  String time;
  String date;
  bool flag =  true;
  double _noteHeight = 200;       // Container Height
  String _note ;
  List imgList = [
    'assets/images/img.jpg',
    'assets/images/img2.jpg',
    'assets/images/img3.jpg',
    'assets/images/img4.jpg',
    'assets/images/img5.jpg',
  ];
  
  

  List lst = List();
  int imCount = 0;

  List<T> map<T>(List list,Function handler){
    List<T> result = [];
    for(var i=0;i<list.length;i++){
      result.add(handler(i,list[i]));
    }
    return result;
  }

   @override
  void initState(){
    super.initState();
    pickedDate = DateTime.now();
    _note = "Nature is something that has inspired poets of all generations. The environment is a constant source of inspiration that has changed and challenged some of the greatest thinkers and writers of all time. Transcendentalists escaped to nature's beauty to find refuge. Ancient philosophers from Homer to Confucious sought answers to life's toughest questions by investing time in listening to the environment's ageless wisdom. It's a wonderful reality that any writer can tap into.";
    _title = 'Beauty of the nature ';
    _date = 'Monday, 1 June 2020';
    _place = 'On Earth';
    time = '11:00';
  
   
   // imgList.add(Utility.imageFromBase64String(img1));
   // imgList.add(Utility.imageFromBase64String(img2));
   // imgList.add(Utility.imageFromBase64String(img3));
   // imgList.add(Utility.imageFromBase64String(img4));
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

   String _getWeekDay(int dayNum){
    week = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return(week[dayNum-1]);
  }

  String _getMonth(int monNum){
    week = ['January','February','March','April','May','June','July','August','September','October','November','December'];
    return(week[monNum-1]);
  }


  Widget buildButtons() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
         SizedBox(
          width: MediaQuery.of(context).size.width*0.60,
          child: RaisedButton(
            child: Text('Continue Reading'),
            color: Colors.amberAccent,
            onPressed: () {
              if(i < count)
              {
                if(imageList[i].image != null){
                  imgList.clear();
                  imgList.add(Utility.imageFromBase64String(imageList[i].image));
                }
               // print(imageList.length.toString() +'   '+ diaryList.length.toString());
               // print(diaryList[i].place);
                setState(() {
                  _title = diaryList[i].title;
                  _note = diaryList[i].note;
                  _date = diaryList[i].date;
                  _place = diaryList[i].place;
                  time = diaryList[i].time;
                });
              }
              
              i++;
              if(i > count){
                _showMessage('End of diary, please write diary');
                i = 0;
              }
              
            },
          ),
        ),

        SizedBox(
          width:  MediaQuery.of(context).size.width*0.60,
          child: RaisedButton(
            child: Text("Goto Date"),
            color: Colors.deepPurpleAccent,
            textColor: Colors.white,
            onPressed: () async {
              await _pickDate();
              //print("Goto Date $date");
              _getDataWhere(date);
            },
          ),
        ),
      ],
    );
  }

   _getDataWhere(String date){
     int i;
     for(i=0;i<diaryList.length;i++){
       if(diaryList[i].date == date){
         break;
       }
     }
    
    try{
      if( i == diaryList.length && diaryList[i].date != date){
      _showMessage('No data found for $date');
      return;
      }
      else{
        setState(() {
                    _title = diaryList[i].title;
                    _note = diaryList[i].note;
                    _date = diaryList[i].date;
                    _place = diaryList[i].place;
                    time = diaryList[i].time;
        });
      }
    }
    catch(e){
      _showMessage('No data found for $date');
      return;
    }
              
   }

  _showMessage(String msg){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
               shape:  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
               title: Text(msg,style: wLabelStyle,),
        ),
    );

  }

  _checkLenOfNote(){
    if (_note.length > 50) {
      firstHalfNote = _note.substring(0, 90);
      secondHalfNote = _note.substring(90, _note.length);
    } else {
      firstHalfNote = _note;
      secondHalfNote = "";
    }
  }
  
  _buildTitle(){
    return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                Padding(
                  padding: EdgeInsets.only(left:10.0,top:13.0),
                ),
                 Text(
                      _title,
                      style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      fontSize: 23.0,
                      ),
                    ),
                
               ], 
         );
  }

  _buildDate(){
    return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                Padding(
                  padding: EdgeInsets.only(left:10.0,top:6.0),
                ),
                 Text(
                      _date+' ,'+time,
                      style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      fontSize: 20.0,
                      ),
                    ),
                
               ], 
        );
 }

  _buildPlace(){
    return  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget>[
                Padding(
                  padding: EdgeInsets.only(left:10.0,top:3.0),
                ),
                 Text(
                      _place,
                      style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      fontSize: 18.0,
                      ),
                    ),
                
               ], 
         );
  }

  _buildNote(){
    _checkLenOfNote();
    return  Container(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //children:<Widget>[
                  padding: EdgeInsets.only(left:10.0,top:8.0),
                  child:secondHalfNote.isEmpty
                        ? new Text(firstHalfNote , style: readNoteTextStyle,)
                        : new Column(
                          children: <Widget>[
                            new Text(
                              flag ? (firstHalfNote +"...") : (firstHalfNote + secondHalfNote),
                              style: readNoteTextStyle,
                            ),
                            new InkWell(
                              child:  new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Text(
                                    flag ?  "show more  " : "show less  ",
                                    style: TextStyle(color:Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                          ),
                                  ),
                                ],
                              ),
                            onTap: (){
                              setState((){
                                if(flag == true)
                                {
                                  _noteHeight = 500;
                                }
                                else
                                {
                                  _noteHeight = 200;
                                }
                                 flag = !flag; 
                              });
                            },
                            ),
                          ],
                        ),
                
             //  ], 
         );
  }
  
  _addImageToList(){
    for(int i=0 ; i < imageList.length ; i++)
    {
      //print('in for loop..');
      if(imageList[i].date == diaryList[i].date){
          lst.add(imageList[i].image);
          print(imageList[i]);
      }
    }
   // print('len :- $imCount');
  }

  @override
  Widget build(BuildContext context) {

    if(diaryList == null || imageList == null){
      diaryList = List<Diary>();
      imageList = List<Diary>();
      _getList();
      _getPhotos();
      _addImageToList();
    }

    return WillPopScope( 
      onWillPop: onWillPop,
      child: 
          Scaffold(
            body:Center(
              child: CustomScrollView(
                slivers:<Widget>[
            
                SliverFixedExtentList(
                  itemExtent: 405.0,
                  delegate: SliverChildListDelegate([

                    Container(
                        padding: EdgeInsets.only(top:24.89), 
                      width: MediaQuery.of(context).size.width,
                      height: 330.0,
                      child:Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget>[
                        CarouselSlider(
                          height: 330.0,
                          initialPage:0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          reverse: false,
                          enableInfiniteScroll: true,
                          autoPlayInterval: Duration(seconds:2),
                          autoPlayAnimationDuration: Duration(milliseconds:2000),
                          pauseAutoPlayOnTouch: Duration(seconds:10),
                          onPageChanged: (index){
                            setState(() {
                              _current = index;
                            });
                          },
                          items: imgList.map((imgUrl){
                            return Builder(
                              builder: (BuildContext context){
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(horizontal:10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(16.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(1,3),
                                        blurRadius: 9.0,
                                      )
                                    ],
                                  ),
                                  child: _getIm(imgUrl),
                                  
                                );
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: map<Widget>(
                            imgList,(index,url){
                              return Container(
                                width: 10.0,
                                height: 10.0,
                                margin: EdgeInsets.symmetric(vertical:4.0,horizontal:2.0),
                                decoration: BoxDecoration(
                                  shape:BoxShape.circle,
                                  color: _current == index ? Colors.redAccent : Colors.green, 
                                  ) ,
                              );
                            }
                          ),
                          ),
                        ],
                      ),
                    ),
                      //buildSelectedDetails(),
                      
                ]),
                ),
              
                SliverFixedExtentList(
                itemExtent: _noteHeight,
                delegate: SliverChildListDelegate([
                  Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(left:20.0,right: 10.0,bottom: 3),
                    decoration: BoxDecoration(
                      shape:BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(16.0),
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
                    
                    child:Column(
                    children: <Widget>[
                      _buildTitle(),
                      _buildDate(),
                      _buildPlace(),
                        _buildNote(),
                    ],
                    ),
                  ),
                  buildButtons(),
                ]),
                ),
              
              ],
            ),
          ),
        ),
    );
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
  
dynamic _getIm(dynamic imgUrl){
    if(imgList.length == 5){
      return Image.asset(imgUrl,fit: BoxFit.fill,);
    }
    else{
      return imgUrl;
    }
  }

_getList(){
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){

      Future<List<Diary>> diaryListFuture = helper.getNoteList();
      diaryListFuture.then((diaryList){
          setState(() {
            this.diaryList = diaryList;
            this.count = diaryList.length;
          });
      });
    });
  }

_getPhotos(){
     final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Diary>> imgListFuture = helper.getPhotos();
      imgListFuture.then((imageList){
        setState(() {
          this.imageList = imageList;
          this.imCount = imageList.length;
          
          for(int i=1;i<imCount;i++){
           this.imgList.add(Utility.imageFromBase64String(imageList[i].image),);
          }
        });
      });
    });

    
  }

}// End of class
