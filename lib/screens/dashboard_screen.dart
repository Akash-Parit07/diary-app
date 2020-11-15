import '../screens/instant_view.dart';
import '../utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import '../fonts/fonts.dart';
import '../model/diary.dart';
import 'package:flutter/material.dart';
import '../bloc.navigation_bloc/navigation_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashBoard extends StatefulWidget with NavigationStates {

  @override
  DashBoardState createState() => DashBoardState();
}

class DashBoardState extends State<DashBoard> {

  DatabaseHelper helper = DatabaseHelper();
  DateTime currentBackPressTime;
  CarouselSlider carouselSlider;
  int _current = 0;
   List imgList = [
    'assets/images/shot1.jpg',
    'assets/images/shot2.jpg',
    'assets/images/shot3.jpg',
    'assets/images/shot4.jpg',
  ];

  List<Diary> diaryList;
  int count = 0;


  List<T> map<T>(List list,Function handler){
    List<T> result = [];
    for(var i=0;i<list.length;i++){
      result.add(handler(i,list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {

    if(diaryList == null){
      diaryList = List<Diary>();
      _getList();
    }

    return WillPopScope( 
      onWillPop: onWillPop,
      child:Scaffold(
        appBar: AppBar(
            title:Center(
                child:Text('Dashboard')
                ),
            ),
            body:  _checkDB(),
          ),
      );
  }

  _checkDB(){
    if(diaryList.length != 0){
      return buildListView();
    }
    else{
      return buildCarouselSlider();
    }
  }

ListView  buildListView(){
     return ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int position) {
				return Card(
                  elevation: 2.0,
                  color: Colors.white,
                  child: ListTile(
                      leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(this.diaryList[position].title,style: dLabelStyle,),
                      subtitle: Text(this.diaryList[position].date,style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'OpenSans',
                              ),),   
                      trailing: GestureDetector(
                        child: Icon(
                        Icons.delete,
                        ),         
                      onTap: (){
                       _delete(context, diaryList[position]);
                      },
                    ),
                  onTap: () {
                   // print(this.diaryList[position].id);
                   navigateToDetail(this.diaryList[position].title, this.diaryList[position].date,this.diaryList[position].time, this.diaryList[position].place,this.diaryList[position].image, this.diaryList[position].note) ;
                  },
                ),
               );
              },
            );    
  }

void navigateToDetail(String title,String date,String time,String place, String img,String note) {
	   Navigator.push(context, MaterialPageRoute(builder: (context) {
		  return InstantView(title,date,time,place,img,note);
	  }));
  }

void _delete(BuildContext context, Diary diary) async {

		int result = await helper.deleteNote(diary.id);
		if (result != 0) {
			toastMsg('Note Deleted Successfully');
			_getList();
		}
    else{
     toastMsg('Some Error');
    }
  }

dynamic buildCarouselSlider(){
    return  Container(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children:<Widget>[
              carouselSlider = CarouselSlider(
                height: 460,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds:2),
                autoPlayAnimationDuration: Duration(milliseconds:2000),
                pauseAutoPlayOnTouch: Duration(seconds:10),
                onPageChanged:(index){
                  setState(() {
                    _current = index;
                  });
                } ,
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
                              child: Image.asset(imgUrl,fit:BoxFit.fill),
                            );
                          },
                        );
                      }).toList(),
              ),
               SizedBox(
                       height: 14,
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
               SizedBox(height: 14,),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    onPressed: goToPrevious,
                    child: Text('<',
                     style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  ),
                  OutlineButton(
                    onPressed: goToNext,
                    child: Text('>',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold
                    ),
                    ),
                  )
                ],
               ),
            ],
          ),
        );
  }

Future<bool> onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null || now.difference(currentBackPressTime) > Duration(seconds: 2)) {  
        currentBackPressTime = now;
          toastMsg('Press again to exit app');
        return Future.value(false);
      }

      return Future.value(true);
  }

toastMsg(String msg){
  Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM ,// also possible "TOP" and "CENTER"
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            );
}

goToPrevious(){
  carouselSlider.previousPage(
    duration:Duration(milliseconds:300),
    curve: Curves.ease
  );
}

goToNext(){
  carouselSlider.nextPage(
    duration:Duration(milliseconds:300),
    curve: Curves.decelerate
  );
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



}//End of class


