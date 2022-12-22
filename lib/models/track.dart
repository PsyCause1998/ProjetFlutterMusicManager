import 'dart:convert';

import 'package:music_manager/models/displayable.dart';

class Track implements Displayable{
late int _id,_albumId,_millis,_bytes;
late String _name,_composer;
Track(this._id,this._name,this._albumId,this._composer,this._millis,this._bytes,);
factory Track.fromJson (Map<String,dynamic> json){
  return Track(
    json['TrackId'],
    json['Name'],
    json['AlbumId'],
    json['Composer']==Null?json['Composer']:'',
    json['Milliseconds'],
   json ['Bytes']
  );
}
get id=>_id;
get albumId=>_albumId;
get millis=>_millis;
get bytes=>_bytes;
get name=>_name;
get composer=>_composer;

  @override
  String getName() {
    return name;
  }
  
  @override
  getTypes() {
    return this;
  }

}