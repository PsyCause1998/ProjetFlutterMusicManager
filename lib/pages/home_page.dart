import 'package:flutter/material.dart';
import 'package:music_manager/controllers/db_acces_controller.dart';
import 'package:music_manager/models/album.dart';
import 'package:music_manager/models/artist.dart';
import 'package:music_manager/models/displayable.dart';
import 'package:music_manager/models/displayable_enum.dart';
import 'package:music_manager/pages/add_artist_view.dart';
import 'package:music_manager/pages/album_detail_view.dart';
import 'package:music_manager/pages/music_audio_player_view.dart';
import 'package:music_manager/pages/radio_list_view.dart';
import '../models/track.dart';
import 'artist_detail_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final DbAccesController _dbAccesController = DbAccesController();
  DisplayableEnum displayEnum = DisplayableEnum.artist;
  late List<Artist> artistlists = [];
  late List<Album> albumlists = [];
  late List<Track> tracklists = [];
  late String selection = 'Rechercher';
  late DrawerSections currentPage = DrawerSections.music;
  late Widget container;
  @override
  void initState() {
    super.initState();
    getArtits();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    if (currentPage == DrawerSections.music) container = musicSection(_formKey);
    if (currentPage == DrawerSections.radio) container = const RadioListView();
    if (currentPage == DrawerSections.settings) {
      container = const Center(child: Text('Settings'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Manager'),
      ),
      body: container,
      drawer: displayDrawer(),
    );
  }

  Column musicSection(GlobalKey<FormState> _formKey) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, //?
      children: [
        displayMenu(),
        displayResearch(_formKey),
        displayMenuSelection(),
        displayListView(),
        displayEnum == DisplayableEnum.artist
            ? displayAddButton()
            : const SizedBox(
                width: 0,
                height: 0,
              )
      ],
    );
  }

  Drawer displayDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 40),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Expanded(child: Icon(Icons.music_note)),
                const Expanded(child: Text('Music')),
              ],
            ),
            onTap: () {
              setState(() {
                currentPage = DrawerSections.music;
                displayEnum = DisplayableEnum.artist;
                getArtits();
              });
              Navigator.pop(context);
              setState(() {});
            },
          ),
          ListTile(
            title: Row(
              children: [
                const Expanded(child: Icon(Icons.radio)),
                const Expanded(child: Text('Radio'))
              ],
            ),
            onTap: () {
              setState(() {
                currentPage = DrawerSections.radio;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Row(
              children: [
                Expanded(child: Icon(Icons.settings)),
                Expanded(child: const Text('Settings')),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                currentPage = DrawerSections.settings;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget displayListView() {
    if (displayEnum == DisplayableEnum.album) {
      return generateListView(albumlists);
    } else if (displayEnum == DisplayableEnum.artist) {
      return generateListView(artistlists);
    } else if (displayEnum == DisplayableEnum.track) {
      return generateListView(tracklists);
    }
    return const Text('Error to load widget');
  }

  Widget generateListView(List<Displayable> list) {
    return Expanded(
      child: ListView.builder(
        itemCount: list.length,
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
                  list[index].getName(),
                ),
                onTap: () async {
                  if (list[index].getTypes() is Artist) {
                    Artist artistDeleted = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ArtistDetailView(list[index].getTypes())));
                    if (artistDeleted != null) {
                      setState(() {
                        artistlists.remove(artistDeleted);
                      });
                    }
                    if (selection.trim() == '') {
                      await getArtits();
                      setState(() {});
                    } else {
                      getArtistByName(selection);
                      setState(() {});
                    }
                  }
                  if (list[index].getTypes() is Album) {
                    print('${list[index].getName()}');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AlbumDetailView(list[index].getTypes())));
                  }
                  if (list[index].getTypes() is Track) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return MusicAudioPlayerView(list[index].getTypes());
                    }));
                  }
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
          bool canceled = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddArtistView()));
          if (canceled) {
          } else {
            if (selection.trim() == "") {
              getArtits();
            } else {
              getArtistByName(selection);
            }
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget displayResearch(GlobalKey<FormState> _formKey) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: selection, hintText: selection),
                      onChanged: (value) {
                        selection = value;
                      },
                    ),
                  ),
                ),
              ],
            )),
        ElevatedButton(
            onPressed: () => getWithSelection(selection),
            child: const Icon(Icons.loupe))
      ],
    );
  }

  Row displayMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 100,
            child: ElevatedButton(
                onPressed: () {
                  if (displayEnum != DisplayableEnum.artist) {
                    displayEnum = DisplayableEnum.artist;
                    getArtits();
                  }
                },
                child: const Text('Artists', style: TextStyle(fontSize: 18))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 100,
            child: ElevatedButton(
                onPressed: () {
                  if (displayEnum != DisplayableEnum.album) {
                    displayEnum = DisplayableEnum.album;
                    getAlbums();
                  }
                },
                child: const Text('Albums', style: TextStyle(fontSize: 18))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            width: 100,
            child: ElevatedButton(
                onPressed: () {
                  if (displayEnum != DisplayableEnum.track) {
                    displayEnum = DisplayableEnum.track;
                    getTracks();
                  }
                },
                child: const Text('Tracks', style: TextStyle(fontSize: 18))),
          ),
        )
      ],
    );
  }

  Future<void> getAlbums() async {
    albumlists = await _dbAccesController.fetchAlbum();
    setState(() {});
  }

  Future<void> getTracks() async {
    tracklists = await _dbAccesController.fetchTrack();
    setState(() {});
  }

  Future<void> getArtits() async {
    artistlists = await _dbAccesController.fetchArtist();
    setState(() {});
  }

  Future<void> getWithSelection(String selection) async {
    if (selection != '' || selection != 'Rechercher') {
      switch (displayEnum) {
        case DisplayableEnum.artist:
          await getArtistByName(selection);
          break;
        case DisplayableEnum.album:
          await getAlbumByName(selection);
          break;
        case DisplayableEnum.track:
          await getTracksByName(selection);
          break;
      }
    }
  }

  Future<void> getArtistByName(String selection) async {
    artistlists = await _dbAccesController.fetchArtistByName(selection);
    setState(() {});
  }

  Future<void> getAlbumByName(String selection) async {
    albumlists = await _dbAccesController.fetchAlbumByName(selection);
    setState(() {});
  }

  Future<void> getTracksByName(String selection) async {
    tracklists = await _dbAccesController.fetchTrackByName(selection);
    setState(() {});
  }

  Widget displayMenuSelection() {
    String menuSelection = "";
    switch (displayEnum) {
      case DisplayableEnum.album:
        menuSelection = "Albums";
        break;
      case DisplayableEnum.artist:
        menuSelection = "Artists";
        break;
      case DisplayableEnum.track:
        menuSelection = "Tracks";
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10, left: 1, right: 1),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0)),
          color: Colors.blue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                menuSelection,
                style: const TextStyle(
                  fontSize: 32,
                  backgroundColor: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum DrawerSections { music, radio, settings }
