import 'package:music_manager/models/displayable.dart';

class Artist implements Displayable {
  final int id;
  final String name;

  const Artist({required this.id, required this.name});
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(id: json['ArtistId'], name: json['Name']);
  }

  @override
  String getName() {
    return name;
  }

  getTypes() {
    return this;
  }
}
