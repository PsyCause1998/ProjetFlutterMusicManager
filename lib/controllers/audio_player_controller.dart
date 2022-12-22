import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:music_manager/bloc/audio_player_bloc/audio_player_bloc.dart';
import 'package:music_manager/bloc/audio_player_bloc/audio_player_events.dart';
import '../models/track.dart';
import 'db_acces_controller.dart';

class AudioPlayerController {
  static final AudioPlayerController _instance = AudioPlayerController._();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _playing = true;
  List<Track> _tracksList = [];
  int _trackIndex = 0;
  List<String> url = [];
  final List<double> _speeds = [0.5, 1, 1.5, 2];
  int _currentSpeedIndex = 1;
  Duration _musicPosition = const Duration();
  Duration _musicLenght = const Duration();
  AudioPlayerController._();
  factory AudioPlayerController() => _instance;
  final AudioPlayerBloc _audioPlayerBloc = AudioPlayerBloc();
  Future<void> setTracksList(List<Track> tracksList, int index) async {
    await reset();
    _trackIndex = index;
    _tracksList = tracksList;
    await initializePlayer();
  }

  Future<void> setTrack(Track track) async {
    await reset();
    _tracksList = [track];
    await initializePlayer();
  }

  get currentTrack {
    return _tracksList[_trackIndex];
  }

  get position {
    return _musicPosition;
  }

  get musicLenght {
    return _musicLenght;
  }

  get playing {
    return _playing;
  }

  get speed {
    return _speeds[_currentSpeedIndex];
  }

  initializePlayer() async {
    initializeUrl();
    await setSource(url[_trackIndex]);
    setDurationLenght();
    setPosition();
    setActionAtEnd();
  }

  initializeUrl() {
    url = List.from(_tracksList.map(
        (track) => 'http://${DbAccesController.host}:3000/song/${track.id}'));
    print(url);
  }

  setSource(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> reset() async {
    _playing = true;
    _currentSpeedIndex = 1;
    await _audioPlayer.setPlaybackRate(_speeds[_currentSpeedIndex]);
    _trackIndex = 0;
  }

  Future<void> play() async {
    _playing = true;
    await _audioPlayer.setPlaybackRate(_speeds[_currentSpeedIndex]);
    await _audioPlayer.resume();
  }

  Future<void> pause() async {
    _playing = false;
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    _playing = false;
    await _audioPlayer.stop();
    await reset();
    await initializePlayer();
    await pause();
  }

  seekToSec(int d) {
    _audioPlayer.seek(Duration(seconds: d));
  }

  Future<void> nextMusic() async {
    if (_tracksList.length > 1) {
      if (_trackIndex == url.length - 1) {
        _trackIndex = 0;
      } else {
        _trackIndex += 1;
      }
      _playing = true;
      _currentSpeedIndex = 1;
      await _audioPlayer.setPlaybackRate(_speeds[_currentSpeedIndex]);
      setSource(url[_trackIndex]);
      _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
    }
  }

  Future<void> priviousMusic() async {
    if (_tracksList.length > 1) {
      if (_trackIndex == 0) {
        _trackIndex = url.length - 1;
      } else {
        _trackIndex -= 1;
      }
      _playing = true;
      _currentSpeedIndex = 1;
      await _audioPlayer.setPlaybackRate(_speeds[_currentSpeedIndex]);
      setSource(url[_trackIndex]);
    }
  }

  Future<void> changeSpeed() async {
    if (_currentSpeedIndex == _speeds.length - 1) {
      _currentSpeedIndex = 0;
    } else {
      _currentSpeedIndex += 1;
    }
    await _audioPlayer.setPlaybackRate(_speeds[_currentSpeedIndex]);
  }

  setDurationLenght() {
    _audioPlayer.onDurationChanged.listen((Duration d) {
      _musicLenght = d;
      _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
    });
  }

  setPosition() {
    _audioPlayer.onPositionChanged.listen((Duration d) {
      _musicPosition = d;
      _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
    });
  }

  setActionAtEnd() {
    _audioPlayer.onPlayerComplete.listen((event) async {
      _currentSpeedIndex = 1;
      await _audioPlayer.setPlaybackRate(_speeds[_currentSpeedIndex]);
      nextMusic();
      _audioPlayerBloc.add(AudioPlayerChangeStateEvent());
    });
  }

  dispose() {
    _audioPlayer.dispose();
  }
}
