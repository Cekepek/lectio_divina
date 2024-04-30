import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lectio_divina/screen/pilihBabKitab.dart';

class PilihKitab extends StatefulWidget {
  const PilihKitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PilihKitabState();
  }
}

class _PilihKitabState extends State<PilihKitab> {
  List kitab = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/ayt.json');
    final data = await json.decode(response);
    setState(() {
      for (var i in data) {
        if (!kitab.contains(i["abbr"])) {
          kitab.add(i["abbr"]);
        }
      }
      debugPrint(kitab.length.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

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
                  itemCount: kitab.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    return TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PilihBabKitab(
                                  kitab: kitab[index],
                                ),
                              ));
                        },
                        child: Text(
                          kitab[index],
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 58, 157)),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
