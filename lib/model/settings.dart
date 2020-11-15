
class Settings{
  int _id;
  String _name;
  String _dob;
  String _image;
  int _darkMode;
  int _security;
  int _pin;

  Settings([this._id,this._name,this._dob,this._image,this._darkMode,this._security,this._pin]);
  
  //getters
  int get id => _id;
  String get name => _name;
  String get dob => _dob;
  String get image => _image;
  int get darkMode => _darkMode;
  int get security => _security;
  int get pin => _pin;

  //setters
  set name(String newTitle){
    this._name = newTitle;
  }

  set dob(String newnote){
    this._dob = newnote;
  }

  set image(String newimage){
    this._image = newimage;
  }

  set darkMode(int newdate){
    this._darkMode = newdate;
  }

  set security(int newtime){
    this._security = newtime;
  }

  set pin(int newplace){
    this._pin = newplace;
  }

  // convert obj to map 
  Map<String,dynamic> toMap(){

    var map =  Map<String,dynamic>();
    if(id != null){
      map['id'] = _id;
    }

    map['name'] = _name;
    map['dob'] = _dob;
    map['image'] = _image;
    map['darkmode'] = _darkMode;
    map['security'] = _security;
    map['pin'] = _pin;

    return map;
  }


  //Exract Settings obj from map obj
  Settings.fromMapObject(Map<String,dynamic> map){
     this._name =  map['name'];
     this._dob  =  map['dob'];
     this._image = map['image'];
     this._darkMode =  map['darkmode'];
     this._security  =  map['security'];
     this._pin = map['pin'];
  }

}//End of class










