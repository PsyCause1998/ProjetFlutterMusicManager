import 'dart:convert';
import '../models/album.dart';
import '../models/artist.dart';
import '../models/radio.dart';
import '../models/track.dart';
import 'package:http/http.dart' as http;

class DbAccesController {
  static final DbAccesController _dbAccesController = DbAccesController._();
  static String host = "10.0.2.2"; //"localhost";
  DbAccesController._();

  factory DbAccesController() {
    return _dbAccesController;
  }

  Future<List<Track>> fetchTrack() async {
    try {
      var url = Uri.parse('http://$host:3000/api/tracks');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        return List<Track>.from(data.map((track) => Track.fromJson(track)));
      } else {
        throw Exception('Failed to load tracks');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<Artist>> fetchArtist() async {
    var url = Uri.parse('http://$host:3000/api/artists');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        return List<Artist>.from(data.map((artist) => Artist.fromJson(artist)));
      } else {
        throw Exception('Failed to load atists');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<Album>> fetchAlbum() async {
    try {
      var url = Uri.parse('http://$host:3000/api/albums');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);

        return List<Album>.from(data.map((artist) => Album.fromJson(artist)));
      } else {
        throw Exception('Failed to load albums');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<Album>> fetchAlbumFromArtist(Artist artist) async {
    try {
      var url = Uri.parse('http://$host:3000/api/albumsBy=${artist.id}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        return List<Album>.from(data.map((album) => Album.fromJson(album)));
      } else {
        throw Exception('Failed to load Albums from ${artist.name}');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<Track>> fetchTracksFromAlbum(Album album) async {
    try {
      var url = Uri.parse('http://$host:3000/api/trackBy=${album.id}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        return List<Track>.from(data.map((track) => Track.fromJson(track)));
      } else {
        throw Exception('Failed to load tracks from ${album.title}');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<Artist>> fetchArtistByName(String name) async {
    var url = Uri.parse('http://$host:3000/api/artists=$name');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        return List<Artist>.from(data.map((artist) => Artist.fromJson(artist)));
      } else {
        throw Exception('Failed to load atists');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<Album>> fetchAlbumByName(String name) async {
    try {
      var url = Uri.parse('http://$host:3000/api/albums=$name');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);

        return List<Album>.from(data.map((artist) => Album.fromJson(artist)));
      } else {
        throw Exception('Failed to load albums');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<Track>> fetchTrackByName(String name) async {
    try {
      var url = Uri.parse('http://$host:3000/api/tracks=$name');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        return List<Track>.from(data.map((track) => Track.fromJson(track)));
      } else {
        throw Exception('Failed to load tracks');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<void> addArtist(Artist artist) async {
    try {
      var url = Uri.parse('http://$host:3000/api/artist');
      dynamic response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': artist.name,
          }));
      print(response.body);
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<void> updateArtist(Artist artist, String name) async {
    try {
      var url = Uri.parse('http://$host:3000/api/artist=${artist.id}');
      dynamic response = await http.patch(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'id': artist.id.toString(),
            'name': name,
          }));
      print(response.body);
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<List<RadioModel>> fecthRadios() async {
    try {
      var url = Uri.parse('http://$host:3000/api/radios');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Iterable data = jsonDecode(response.body);
        print(data);
        return List<RadioModel>.from(
            data.map((radio) => RadioModel.fromJson(radio)));
      } else {
        throw Exception('Failed to load radios');
      }
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<void> deleteArtist(Artist artist) async {
    try {
      var url = Uri.parse('http://$host:3000/api/artist=${artist.id}');
      http.delete(url);
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<void> addAlbumToArtist(Artist artist, Album album) async {
    try {
      var url = Uri.parse('http://$host:3000/api/album');
      http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'artistId': artist.id.toString(),
            'title': album.title,
          }));
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }

  Future<void> deleteAlbum(Album albumsList) async {
    try {
      var url = Uri.parse('http://$host:3000/api/album=${albumsList.id}');
      http.delete(url);
    } on Exception catch (_) {
      print('throw connexion API error');
      throw Exception('Connexion API Error');
    }
  }
}
