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
  Widget build(BuildContext context) {
    return Switch(
      inactiveTrackColor: Colors.white,
      value: globals.backgroundMusic,
      activeColor: Colors.green,
      onChanged: (bool value) {
        setState(() {
          globals.backgroundMusic = value;
          changeSettings();
        });
      },
    );
  }
}
