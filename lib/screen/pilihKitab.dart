import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lectio_divina/screen/pilihBabKitab.dart';

import 'package:lectio_divina/globals.dart' as globals;

class PilihKitab extends StatefulWidget {
  const PilihKitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PilihKitabState();
  }
}

class _PilihKitabState extends State<PilihKitab> {
  Color fontColor = Color.fromARGB(255, 0, 58, 157);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.pop(context)}),
        title: Text(
          'Pilih Kitab',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              GridView.builder(
                  itemCount: globals.kitab.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    if (index >= 39) {
                      fontColor = Color.fromARGB(255, 255, 0, 0);
                    }
                    return TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PilihBabKitab(
                                  kitab: globals.kitab[index].id,
                                ),
                              ));
                        },
                        child: Text(
                          globals.kitab[index].singkatan,
                          style: TextStyle(color: fontColor),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
