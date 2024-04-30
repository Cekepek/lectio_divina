import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lectio_divina/main.dart';
import 'package:lectio_divina/screen/cariAlkitab.dart';
import 'package:lectio_divina/screen/pilihKitab.dart';

class Alkitab extends StatefulWidget {
  const Alkitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlkitabState();
  }
}

class _AlkitabState extends State<Alkitab> {
  List ayat = [];
  List selected = [];
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/ayt.json');
    final data = await json.decode(response);
    setState(() {
      for (var i in data) {
        if ((i["abbr"] == "Kej") && (i["chapter"] == "1")) {
          ayat.add(i);
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  Widget tampilAlkitab() {
    return ListView.builder(
        itemCount: ayat.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (ayat[index]["title"] != "") {
            return Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Container(
                        child: Text(
                      ayat[index]["title"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
                  GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            ayat[index]["verse"],
                            style: TextStyle(
                              fontSize: fontSizeAyat,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            ayat[index]["text"],
                            style: TextStyle(
                              fontSize: fontSizeAyat,
                            ),
                          ),
                        ))
                      ],
                    ),
                    onLongPress: () {
                      setState(() {
                        selected
                            .add(ayat[index]["abbr"] + ayat[index]["verse"]);
                        debugPrint(selected[3]);
                      });
                    },
                  )
                ],
              ),
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    ayat[index]["verse"],
                    style: TextStyle(
                      fontSize: fontSizeAyat,
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    ayat[index]["text"],
                    style: TextStyle(
                      fontSize: fontSizeAyat,
                    ),
                  ),
                ))
              ],
            );
          }
        });
  }

  double? fontSizeAyat = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  tampilAlkitab(),
                ],
              ),
            ),
          ),
          Container(
            height: 56,
            color: themeColor,
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Text("<",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      )),
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 24, left: 24),
                    child: Text("Kejadian 1",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PilihKitab(),
                      ),
                    );
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 24,
                    ),
                    child: Text(">",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        )),
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.search,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CariAlkitab(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
