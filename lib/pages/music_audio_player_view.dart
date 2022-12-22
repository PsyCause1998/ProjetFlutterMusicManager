import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_manager/bloc/audio_player_bloc/audio_player_bloc.dart';
import 'package:music_manager/bloc/audio_player_bloc/audio_player_events.dart';
import 'package:music_manager/bloc/audio_player_bloc/audio_player_state.dart';
import 'package:music_manager/controllers/db_acces_controller.dart';
import 'package:music_manager/controllers/audio_player_controller.dart';
import 'package:music_manager/models/track.dart';

class MusicAudioPlayerView extends StatefulWidget {
  late final AudioPlayerController _audioPlayer = AudioPlayerController();
  late List<Track> _tracksList;
  int _index = 0;
  MusicAudioPlayerView.byList(this._tracksList, this._index, {super.key});
  MusicAudioPlayerView(Track track, {super.key}) {
    _tracksList = [track];
  }
  @override
  State<MusicAudioPlayerView> createState() => _MusicAudioPlayerViewState();
}

class _MusicAudioPlayerViewState extends State<MusicAudioPlayerView> {
  AudioPlayerController get _audioPlayer => widget._audioPlayer;
  late final AudioPlayerBloc _audioPlayerBloc;
  late dynamic img;
  late Future initFuture;
  @override
  void initState() {
    super.initState();
    initFuture = _audioPlayer.setTracksList(widget._tracksList, widget._index);
    _audioPlayerBloc = AudioPlayerBloc();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            img = NetworkImage(
                'http://${DbAccesController.host}:3000/img/${widget._audioPlayer.currentTrack.albumId}.jpg');
            return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
                bloc: _audioPlayerBloc,
                builder: ((context, state) => Scaffold(
                      appBar: AppBar(),
                      body: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                              Colors.black,
                              Colors.grey,
                              Colors.black
                            ])),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 48),
                          child: Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  displayTitle(),
                                  displaySubTitle(),
                                  const SizedBox(
                                    height: 24.0,
                                  ),
                                  displayImage(),
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  diaplayMusicTilte(),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.0),
                                          topRight: Radius.circular(30.0),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          displaySlider(),
                                          displayButtons()
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    )));
          }
        });
  }

  Row displayButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            iconSize: 45,
            color: Colors.grey,
            onPressed: () async {
              await _audioPlayer.priviousMusic();
              _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
            },
            icon: const Icon(Icons.skip_previous)),
        IconButton(
            iconSize: 62,
            color: Colors.black,
            onPressed: () async {
              if (!_audioPlayer.playing) {
                await _audioPlayer.play();
                _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
              } else {
                await _audioPlayer.pause();
                _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
              }
            },
            icon: Icon(_audioPlayer.playing ? Icons.pause : Icons.play_arrow)),
        IconButton(
            iconSize: 45,
            color: Colors.grey,
            onPressed: () async {
              await _audioPlayer.nextMusic();
              _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
            },
            icon: const Icon(Icons.skip_next)),
        ElevatedButton(
            onPressed: () async {
              await _audioPlayer.changeSpeed();
              _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey, fixedSize: const Size(45, 45)),
            child: Text('${_audioPlayer.speed}')),
      ],
    );
  }

  Center diaplayMusicTilte() {
    return Center(
      child: Text(
        "${_audioPlayer.currentTrack.name}",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Center displayImage() {
    return Center(
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(image: img)),
      ),
    );
  }

  Widget displaySubTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        'Audio Player Music ',
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget displayTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        'Music Manager ',
        style: TextStyle(
            color: Colors.white, fontSize: 38.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget displaySlider() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
      child: Row(
        children: [
          Text(
            '${_audioPlayer.position.inMinutes}:${_audioPlayer.position.inSeconds.remainder(60)}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          Expanded(
            child: Slider.adaptive(
              activeColor: Colors.black,
              inactiveColor: Colors.grey,
              value: _audioPlayer.position.inSeconds.toDouble(),
              max: _audioPlayer.musicLenght.inSeconds.toDouble(),
              onChanged: (value) {
                _audioPlayer.seekToSec(value.toInt());
              },
            ),
          ),
          Text(
            '${_audioPlayer.musicLenght.inMinutes}:${_audioPlayer.musicLenght.inSeconds.remainder(60)}',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
