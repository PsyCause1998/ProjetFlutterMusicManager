import 'package:flutter/material.dart';
import 'package:music_manager/controllers/db_acces_controller.dart';
import 'package:music_manager/models/album.dart';
import 'package:music_manager/models/artist.dart';
import 'package:music_manager/models/track.dart';
import 'package:music_manager/pages/add_album_view.dart';
import 'package:music_manager/pages/edit_artist_view.dart';
import 'package:music_manager/pages/music_audio_player_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ArtistDetailView extends StatefulWidget {
  ArtistDetailView(this._artist, {super.key});
  late Artist _artist;
  late Album al;
  @override
  State<StatefulWidget> createState() => ArtistDetailViewState();
}

class ArtistDetailViewState extends State<ArtistDetailView> {
  late List<Album> albumsList = [];
  late List<Track> selectionList = [];
  Album? selected;
  final DbAccesController _dbAccesController = DbAccesController();
  @override
  void initState() {
    super.initState();
    getAlbumsFromArtist(widget._artist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._artist.name),
          centerTitle: true,
          actions: [
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  Artist edited = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditArtistView(widget._artist),
                      ));
                  if (edited != null) {
                    widget._artist = edited;
                    setState(() {});
                  }
                }),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title:
                      const Text('Do you really want to delete this artist ?'),
                  content: const Text('This action is irreversible'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await _dbAccesController.deleteArtist(widget._artist);
                        Navigator.pop(context);
                        Navigator.pop(context, widget._artist);
                        setState(() {});
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            displayWikiLink(),
            Text('Every album of ${widget._artist.name} :'),
            Column(
              children: [...displayAlbumsFromArtist(widget._artist)],
            ),
            // ...displayTracksFromAlbum(),

            selectionList.isNotEmpty
                ? displayListViewTracksFromAlbum()
                : Container(),
            displayAddButton()
          ],
        ));
  }

  ElevatedButton displayWikiLink() {
    return ElevatedButton(
        onPressed: () {
          _launchWikiUrl(widget._artist.name);
        },
        child: Row(
          children: [
            const Icon(Icons.loupe),
            Text('Wikipedia ${widget._artist.name} page')
          ],
        ));
  }

  Future<void> _launchWikiUrl(String selection) async {
    final Uri url = Uri.parse('https://fr.wikipedia.org/wiki/$selection');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  List<Widget> displayAlbumsFromArtist(Artist artist) {
    return List.generate(
        albumsList.length,
        (index) => Dismissible(
              key: Key(albumsList[index].id.toString()),
              direction: DismissDirection.startToEnd,
              background: Container(
                color: Colors.red,
                child: const Icon(Icons.delete),
              ),
              // onDismissed: (direction) async {
              //   if (direction == DismissDirection.startToEnd) {
              //     await _dbAccesController.deleteAlbum(albumsList[index]);
              //     setState(() {
              //       albumsList.removeAt(index);
              //     });
              //   }
              //   if (direction == DismissDirection.endToStart) {}
              // },
              confirmDismiss: (direction) {
                return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('Delete album'),
                          content: const Text(
                              'Do you really want to delete this album ?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  await _dbAccesController
                                      .deleteAlbum(albumsList[index]);
                                  setState(() {
                                    albumsList.removeAt(index);
                                  });
                                  Navigator.of(context).pop(true);
                                },
                                child: const Text('Delete'))
                          ],
                        ));
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      if (selected != albumsList[index]) {
                        getTracksFromAlbum(albumsList[index]);
                      }
                    },
                    child: Text(' ${albumsList[index].title}')),
              ),
            ));
  }

  Expanded displayListViewTracksFromAlbum() {
    return Expanded(
      child: ListView.builder(
        itemCount: selectionList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${selectionList[index].name}',
                            overflow: TextOverflow.visible,
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _launchYotubeUrl(selectionList[index].name +
                              ' ' +
                              selected!.title);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.youtube_searched_for),
                          ],
                        )),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MusicAudioPlayerView.byList(
                              selectionList, index)));
                },
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> displayTracksFromAlbum() {
    if (albumsList != null) {
      return List.generate(
          selectionList.length,
          (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MusicAudioPlayerView.byList(
                                        selectionList, index)));
                      },
                      child: Text(
                        '${selectionList[index].name}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _launchYotubeUrl(selectionList[index].name +
                              ' ' +
                              selected!.title);
                        },
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Icon(Icons.youtube_searched_for),
                          ],
                        )),
                  ],
                ),
              ));
    } else {
      List<Widget> list = [];
      list.add(const Text('No Album selected'));
      return list;
    }
  }

  Padding displayAddButton() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: FloatingActionButton(
        onPressed: () async {
          bool canceled = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAlbumView(widget._artist)));
          if (canceled) {
          } else {
            getAlbumsFromArtist(widget._artist);
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

  Future<void> _launchYotubeUrl(String selection) async {
    final Uri url =
        Uri.parse('https://www.youtube.com/results?search_query=+$selection');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> getAlbumsFromArtist(Artist artist) async {
    albumsList = await _dbAccesController.fetchAlbumFromArtist(artist);
    setState(() {});
  }

  Future<void> getTracksFromAlbum(Album album) async {
    selected = album;
    selectionList = await _dbAccesController.fetchTracksFromAlbum(album);
    setState(() {});
  }
}
