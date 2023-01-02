import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_manager/models/artist.dart';

import '../controllers/db_acces_controller.dart';

class EditArtistView extends StatefulWidget {
  final Artist artist;
  const EditArtistView(this.artist, {super.key});

  @override
  State<EditArtistView> createState() => _EditArtistViewState();
}

class _EditArtistViewState extends State<EditArtistView> {
  Artist get artist => widget.artist;
  final _formKey = GlobalKey<FormState>();
  String name = "";
  bool exist = false;

  @override
  void initState() {
    name = widget.artist.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit Artist')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Artist Name:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      initialValue: name,
                      validator: (value) {
                        print(value.toString());
                        if (name.isEmpty) {
                          return 'Please enter some text';
                        }
                        if (value == artist.name) {
                          return "you can't change the name to the same name";
                        }
                        if (exist) {
                          return 'Artist name already exist';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                  ),
                  displayButtons()
                ],
              ),
            ),
          ],
        ));
  }

  Row displayButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
            onPressed: () async {
              exist = await existArtist(name);
              print(exist);
              if (_formKey.currentState!.validate()) {
                await DbAccesController().updateArtist(artist, name);
                widget.artist.name = name;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Artist correctly edited'),
                  ),
                );
                Navigator.pop(context, widget.artist);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Artist not edited'),
                  ),
                );
              }
            },
            child: const Text('Edit')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'))
      ],
    );
  }

  Future<bool> existArtist(String name) async {
    List<Artist> artists;
    artists = await DbAccesController().fetchArtistByName(name);
    return artists
        .where((artist) => artist.name.toLowerCase() == name.toLowerCase())
        .toList()
        .isNotEmpty;
  }
}
