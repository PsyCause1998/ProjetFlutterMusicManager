import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_manager/bloc/audio_player_bloc/audio_player_state.dart';
import 'audio_player_events.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  static final AudioPlayerBloc _instance = AudioPlayerBloc._();
  factory AudioPlayerBloc() => _instance;
  AudioPlayerBloc._() : super(AudioPlayerState()) {
    on<AudioPlayerChangeStateEvent>((((event, emit) {
      emit(AudioPlayerState());
    })));
  }
}
