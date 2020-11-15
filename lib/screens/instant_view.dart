import 'package:fluttertoast/fluttertoast.dart';
import '../utils/utility.dart';
import '../fonts/fonts.dart';
import '../model/diary.dart';
import 'package:flutter/material.dart';

class InstantView extends StatefulWidget {
  
  String title;
  String date;
  String place;
  String img;
  String note;
  String time;

   InstantView([this.title,this.date,this.time,this.place,this.img,this.note]);

   @override
   State<StatefulWidget> createState() {
    return _InstantView(this.title,this.date,this.time,this.place,this.img,this.note);
  }
   
}

class _InstantView extends State<InstantView> {

  String _date;
 /* Image getImage(photoReference) {
    final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
    final maxWidth = "1000";
    final maxHeight = "200";
    final url = "$baseUrl?maxwidth=$maxWidth&photoreference=$photoReference&key=$PLACES_API_KEY";
    return Image.network(url, fit: BoxFit.cover);
  }*/


  String firstHalfNote;
  String secondHalfNote;
  String _title;
  String _place;
  String time;
  String date;
  bool flag =  true;
  double _noteHeight = 220;       // Container Height
  String _note ;
  String _img;

  _InstantView(this._title,this.date,this.time,this._place,this._img,this._note);
  
   @override
  void initState(){
    super.initState();
    //print(_title);
    //_note = "Nature is something that has inspired poets of all generations. The environment is a constant source of inspiration that has changed and challenged some of the greatest thinkers and writers of all time. Transcendentalists escaped to nature's beauty to find refuge. Ancient philosophers from Homer to Confucious sought answers to life's toughest questions by investing time in listening to the environment's ageless wisdom. It's a wonderful reality that any writer can tap into.";
    //_place = 'On Earth';
    //imgList.add(Utility.imageFromBase64String(img4));
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
                  padding: EdgeInsets.only(left:10.0,top:15.0),
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
                      date+' , '+time,
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

getImage(){
  if(_img != null){
    return Utility.imageFromBase64String(_img);
  }
  else{
    return;
  }

}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body:Center(
              child: CustomScrollView(
                slivers:<Widget>[
                  SliverAppBar(
                    title: Text(''),
                    backgroundColor: Colors.green,
                    expandedHeight: 310.0,
                    flexibleSpace: FlexibleSpaceBar(
                    background:getImage(),
                    ),
                  ),

                 SliverFixedExtentList(
                itemExtent: _noteHeight,
                delegate: SliverChildListDelegate([
                  Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top:13.0,left:10.0,right: 10.0,bottom: 0),
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
                  SizedBox(height:3.0)
                ]),
                ),
                
            ],
          ),
        ),
       );
    
  }


}// End of class
