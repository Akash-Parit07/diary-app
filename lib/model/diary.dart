
class Diary{
  int _id;
  String _title;
  String _note;
  String _image;
  String _date;
  String _time;
  String _place;

  Diary(this._title,this._date,this._time,[this._image,this._note,this._place]);

  Diary.withId(this._id,this._title,this._date,this._time,[this._image,this._note,this._place]);

  //getters
  int get id => _id;
  String get title => _title;
  String get note => _note;
  String get image => _image;
  String get date => _date;
  String get time => _time;
  String get place => _place;

  //setters
  set title(String newTitle){
    this._title = newTitle;
  }

  set note(String newnote){
    this._note = newnote;
  }

  set image(String newimage){
    this._image = newimage;
  }

  set date(String newdate){
    this._date = newdate;
  }

  set time(String newtime){
    this._time = newtime;
  }

  set place(String newplace){
    this._place = newplace;
  }

  // convert obj to map 
  Map<String,dynamic> toMap(){

    var map =  Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }

    map['title'] = _title;
    map['note'] = _note;
    map['date'] = _date;
    map['time'] = _time;
    map['image'] = _image;
    map['place'] = _place;

    return map;
  }


  //Exract diary obj from map obj
  Diary.fromMapObject(Map<String,dynamic> map){
     this._id = map['id'];
     this._title =  map['title'];
     this._note  =  map['note'];
     this._image = map['image'];
     this._date =  map['date'];
     this._time  =  map['time'];
     this._place = map['place'];
  }

}//End of class










