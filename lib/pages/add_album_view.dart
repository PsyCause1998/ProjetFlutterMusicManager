import 'package:flutter/material.dart';
import 'package:music_manager/models/album.dart';
import 'package:music_manager/models/artist.dart';

import '../controllers/db_acces_controller.dart';

class AddAlbumView extends StatefulWidget {
  final Artist _artist;
  const AddAlbumView(this._artist, {super.key});

  @override
  State<AddAlbumView> createState() => _AddAlbumViewState();
}

class _AddAlbumViewState extends State<AddAlbumView> {
  String title = "";
  bool exist = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Album')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Album Title:',
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Please enter some text';
                      }
                      if (exist) {
                        return ' Album already exist';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      title = value;
                    },
                  ),
                ),
                displayButtons()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row displayButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () async {
              exist = await existAlbumforAtist(title, widget._artist);
              print(exist);
              if (_formKey.currentState!.validate()) {
                await DbAccesController().addAlbumToArtist(
                    widget._artist, Album(0, title, widget._artist.id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Album correctly added'),
                  ),
                );
                Navigator.pop(context, false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Album not added'),
                  ),
                );
              }
            },
            child: const Text('Add')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Cancel'))
      ],
    );
  }

  Future<bool> existAlbumforAtist(String title, Artist artist) async {
    List<Album> list = await DbAccesController().fetchAlbumFromArtist(artist);
    for (Album album in list) {
      if (album.title.toLowerCase() == title.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
}
