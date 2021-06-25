


import 'dart:io';

import 'package:flutter_app/main.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';



class SoundPlayer{

  Future<int> play(String soundUrl) async {
    int result = await MyApp().audioPlayer.play(soundUrl);
    if (result == 1) {
      print("success playing audio from url");
    }
    return result;
  }

}