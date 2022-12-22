import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:music_manager/models/album.dart';

class AddTrackView extends StatefulWidget {
  const AddTrackView(album,  {super.key});

  @override
  State<AddTrackView> createState() => _AddTrackViewState();
}

class _AddTrackViewState extends State<AddTrackView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        
      ]),
    );
  }
}