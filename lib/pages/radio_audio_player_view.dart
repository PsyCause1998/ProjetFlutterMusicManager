import 'package:flutter/material.dart';
import 'package:music_manager/models/radio.dart';
import 'package:radio_player/radio_player.dart';

class RadioAudioPlayerView extends StatefulWidget {
  List<RadioModel> radios = [];
  RadioPlayer radioPlayer = RadioPlayer();
  int _index = 0;
  RadioModel get currentRadio => radios[_index];
  set index(newindex) {
    _index = newindex;
  }

  RadioAudioPlayerView(this.radios, this._index, {super.key}) {
    radioPlayer.setChannel(title: currentRadio.name, url: currentRadio.url);
  }
  @override
  State<RadioAudioPlayerView> createState() => _RadioAudioPlayerViewState();
}

class _RadioAudioPlayerViewState extends State<RadioAudioPlayerView> {
  late Future initFuture;
  bool playing = true;
  List<RadioModel> get radios => widget.radios;
  RadioModel get currentRadio => widget.currentRadio;
  RadioPlayer get radioPlayer => widget.radioPlayer;
  set setIndex(newindex) {
    widget.index = newindex;
  }

  int get index => widget._index;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.black, Colors.grey, Colors.black])),
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
                              height: 18.0,
                            ),
                            displayRadioTitle(),
                            const SizedBox(
                              height: 30.0,
                            ),
                            SizedBox(
                              height: 150,
                              child: Column(
                                children: [
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
                                          // displaySlider(),
                                          displayButtons()
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ])))),
        );
      }
    });
  }

  Padding displaySubTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        'Radio Stations ',
        style: TextStyle(
            color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.w400),
      ),
    );
  }

  Padding displayTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 12),
      child: Text(
        'Music Manager ',
        style: TextStyle(
            color: Colors.white, fontSize: 38.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Expanded displayImage() {
    return Expanded(
      child: Center(
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                  image: NetworkImage(currentRadio.image), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  displayRadioTitle() {
    return Center(
      child: Text(
        currentRadio.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  displayButtons() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            iconSize: 45,
            color: Colors.grey,
            onPressed: () async {
              radioPlayer.stop();
              priviousRadio();
              radioPlayer.setChannel(
                  title: currentRadio.name, url: currentRadio.url);
              radioPlayer.play();
              setState(() {});
            },
            icon: const Icon(Icons.skip_previous)),
        IconButton(
            iconSize: 62,
            color: Colors.black,
            onPressed: () async {
              if (!playing) {
                playing = true;
                radioPlayer.play();
              } else {
                playing = false;
                radioPlayer.pause();
              }
              setState(() {});
            },
            icon: Icon(playing ? Icons.pause : Icons.play_arrow)),
        IconButton(
            iconSize: 45,
            color: Colors.grey,
            onPressed: () async {
              // radioPlayer.stop();
              nextRadio();
              radioPlayer.setChannel(
                  title: currentRadio.name, url: currentRadio.url);
              setState(() {});
            },
            icon: const Icon(Icons.skip_next)),
      ],
    );
  }

  void priviousRadio() {
    if (index == 0) {
      setIndex = radios.length - 1;
    } else {
      setIndex = index - 1;
    }
  }

  nextRadio() {
    if (index == radios.length - 1) {
      setIndex = 0;
    } else {
      setIndex = index + 1;
    }
  }
}
