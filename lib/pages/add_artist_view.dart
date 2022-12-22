import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_manager/controllers/db_acces_controller.dart';
import 'package:music_manager/models/artist.dart';

class AddArtistView extends StatefulWidget {
  const AddArtistView({super.key});

  @override
  State<AddArtistView> createState() => _AddArtistViewState();
}

class _AddArtistViewState extends State<AddArtistView> {
  late Artist artistToCreate;
  late String name = "";
  late bool exist = false;
  late List<Artist> artists = [];
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add An Artist')),
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
                    validator: (value) {
                      print(value.toString());
                      if (name.isEmpty) {
                        return 'Please enter some text';
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
      ),
    );
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
                await DbAccesController().addArtist(Artist(id: 0, name: name));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Artist correctly added'),
                  ),
                );
                Navigator.pop(context);
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Artist not added'),
                  ),
                );
              }
            },
            child: const Text('Add')),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'))
      ],
    );
  }

  Future<void> getArtistSameName(String name) async {
    artists = await DbAccesController().fetchArtistByName(name);
  }

  Future<bool> existArtist(String name) async {
    artists = await DbAccesController().fetchArtistByName(name);
    return artists
        .where((artist) => artist.name.toLowerCase() == name.toLowerCase())
        .toList()
        .isNotEmpty;
  }
}
