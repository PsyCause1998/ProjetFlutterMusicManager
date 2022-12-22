import 'package:music_manager/models/displayable.dart';

class Album implements Displayable {
  int id, artistId;
  String title;
  Album(this.id, this.title, this.artistId);
  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(json['AlbumId'], json['Title'], json['ArtistId']);
  }

  @override
  String getName() {
    return title;
  }
  
  @override
  getTypes() {
    return this;
  }
}
