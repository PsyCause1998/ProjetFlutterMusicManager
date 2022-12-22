import 'package:flutter/material.dart';
import 'package:music_manager/controllers/db_acces_controller.dart';
import 'package:music_manager/models/album.dart';
import 'package:music_manager/models/track.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_track_view.dart';
import 'music_audio_player_view.dart';

class AlbumDetailView extends StatefulWidget {
  final Album _album;
  const AlbumDetailView(this._album, {super.key});

  @override
  State<StatefulWidget> createState() => AlbumDetailViewState();
}

class AlbumDetailViewState extends State<AlbumDetailView> {
  final DbAccesController _dbAccesController = DbAccesController();
  get album=>widget._album;
  List<Track> tracksList = [];
  @override
  void initState() {
    super.initState();
    getTracksFromAlbum(widget._album);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget._album.title)),
      body: Column(
        children: [displayWikiLink(), displayTracksListView()],
      ),
    );
  }

  ElevatedButton displayWikiLink() {
    return ElevatedButton(
        onPressed: () {
          String selection = widget._album.title.replaceAll(RegExp(' '), '_');
          _launchWikiUrl(selection);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Wikipedia ${widget._album.title}'),
            const Icon(Icons.loupe)
          ],
        ));
  }

  Expanded displayTracksListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: tracksList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicAudioPlayerView.byList(
                                    tracksList, index)));
                      },
                      child: Text(
                        '${tracksList[index].name}',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                ElevatedButton(
                    onPressed: () {
                      _launchYotubeUrl(
                          '${widget._album.title} ${tracksList[index].name}');
                    },
                    child: const Icon(Icons.youtube_searched_for))
              ],
            ),
          );
        },
      ),
    );
  }
  FloatingActionButton displayAddButton() {
    return FloatingActionButton(
      onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  AddTrackView(album)));
      },
      backgroundColor: Colors.blue,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
  Future<void> getTracksFromAlbum(Album album) async {
    tracksList = await _dbAccesController.fetchTracksFromAlbum(album);
    setState(() {});
  }

  Future<void> _launchYotubeUrl(String selection) async {
    final Uri url =
        Uri.parse('https://www.youtube.com/results?search_query=+$selection');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchWikiUrl(String selection) async {
    final Uri url = Uri.parse('https://fr.wikipedia.org/wiki/$selection');
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
