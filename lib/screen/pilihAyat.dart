import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lectio_divina/class/ayat.dart';

class PilihAyat extends StatefulWidget {
  final String kitab;
  final String bab;
  PilihAyat({Key? key, required this.kitab, required this.bab})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _PilihAyatState();
  }
}

class _PilihAyatState extends State<PilihAyat> {
  List ayat = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/ayt.json');
    final data = await json.decode(response);
    setState(() {
      for (var i in data) {
        if ((i["abbr"] == widget.kitab && i["chapter"] == widget.bab)) {
          ayat.add(i["verse"]);
        }
      }

      debugPrint(ayat.length.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
    debugPrint(widget.kitab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.pop(context)}),
        title: Text(
          'Pilih Ayat',
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
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              GridView.builder(
                  itemCount: ayat.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (context, index) {
                    return TextButton(
                        onPressed: () {
                          debugPrint(ayat[index]);
                        },
                        child: Text(ayat[index]));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
