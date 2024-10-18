import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  State<SwitchButton> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchButton> {
  bool light = false;

  Future<void> changeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("backgroundMusic", globals.backgroundMusic);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlameAudio.bgm.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      inactiveTrackColor: Colors.white,
      value: globals.backgroundMusic,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() {
          value
              ? FlameAudio.bgm.play(
                  'Kumasuk Ruang Maha Kudus (Instrumental).mp3',
                  volume: 1)
              : FlameAudio.bgm.stop();
          globals.backgroundMusic = value;
          changeSettings();
        });
      },
    );
  }
}
