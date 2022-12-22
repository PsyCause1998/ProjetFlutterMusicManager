import 'package:flutter/material.dart';
import 'package:music_manager/models/radio.dart';
import 'package:music_manager/pages/radio_audio_player_view.dart';
import '../controllers/db_acces_controller.dart';

class RadioListView extends StatefulWidget {
  const RadioListView({super.key});

  @override
  State<RadioListView> createState() => _RadioListViewState();
}

class _RadioListViewState extends State<RadioListView> {
  late List<RadioModel> radios = [];
  @override
  void initState() {
    getRadios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (radios.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Column(children: [
        displayRadioList(),
        displayAddButton(),
      ]);
    }
  }

  Expanded displayRadioList() {
    return Expanded(
      child: ListView.builder(
        itemCount: radios.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center, //?
              child: ListTile(
                title: Text(
                  radios[index].name,
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RadioAudioPlayerView(radios
                      ,index),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Padding displayAddButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        onPressed: () async {
          // await Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const AddArtistView()));
          // setState(() {
          //   if (selection != "") {
          //     getArtits();
          //   }
          //   getArtistByName(selection);
          // });
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

// return ListTile(
//             title: Text(radios[index].name),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => RadioAudioPlayerView(radios[index]),
//                 ),
//               );
//             },
//           );

  Future<void> getRadios() async {
    radios = await DbAccesController().fecthRadios();
    setState(() {});
  }
}
