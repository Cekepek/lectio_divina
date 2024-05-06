import 'dart:convert';
import 'dart:ffi';

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
  int book = 66;
  int chapter = 22;

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/json/ayt.json');
    final data = await json.decode(response);
    setState(() {
      ayat.clear();
      List test = [];
      for (var i in data) {
        // if ((i["book"] == book.toString()) &&
        //     (i["chapter"] == chapter.toString())) {
        //   ayat.add(i);
        // }
        if ((i["book"] == book.toString()) &&
            (i["chapter"] == chapter.toString())) {
          test.add(i);
        }
      }
      if (test.isNotEmpty) {
        ayat = test;
      } else {
        book += 1;
        chapter = 1;
        for (var i in data) {
          if ((i["book"] == book.toString()) &&
              (i["chapter"] == chapter.toString())) {
            test.add(i);
          }
        }
        if (test.isNotEmpty) {
          ayat = test;
        } else {
          book = 1;
          chapter = 1;
          for (var i in data) {
            if ((i["book"] == book.toString()) &&
                (i["chapter"] == chapter.toString())) {
              ayat.add(i);
            }
          }
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
            color: Theme.of(context).colorScheme.inversePrimary,
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
                  onTap: () {
                    setState(() {
                      if (chapter - 1 == 0) {
                        chapter = 1;
                        if (book - 1 == 0) {
                          book = 1;
                        } else {
                          book -= 1;
                        }
                      } else {
                        chapter -= 1;
                      }
                      readJson();
                    });
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 24, left: 24),
                    child: Text(ayat[1]["abbr"] + " " + ayat[1]["chapter"],
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
                  onTap: () {
                    setState(() {
                      chapter += 1;
                      readJson();
                    });
                  },
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
