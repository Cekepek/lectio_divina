import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lectio_divina/class/ayat.dart';
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
    debugPrint(ayat.length.toString());
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
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  //   child: Container(
                  //       child: Text(
                  //     "Allah menciptakan langit dan bumi serta isinya",
                  //     style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 24,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   )),
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "1",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Pada mulanya Allah menciptakan langit dan bumi. ",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "2",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Bumi belum berbentuk dan kosong; gelap gulita menutupi samudera raya, dan Roh Allah melayang-layang di atas permukaan air.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "3",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Berfirmanlah Allah: ”Jadilah terang.” Lalu terang itu jadi.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "4",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Allah melihat bahwa terang itu baik, lalu dipisahkan-Nyalah terang itu dari gelap.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "5",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Dan Allah menamai terang itu siang, dan gelap itu malam. Jadilah petang dan jadilah pagi, itulah hari pertama.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "6",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Berfirmanlah Allah: 'Jadilah cakrawala di tengah segala air untuk memisahkan air dari air.'",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "7",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Maka Allah menjadikan cakrawala dan Ia memisahkan air yang ada di bawah cakrawala itu dari air yang ada di atasnya. Dan jadilah demikian.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "8",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Lalu Allah menamai cakrawala itu langit. Jadilah petang dan jadilah pagi, itulah hari kedua.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "9",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Berfirmanlah Allah: ”Hendaklah segala air yang di bawah langit berkumpul pada satu tempat, sehingga kelihatan yang kering.” Dan jadilah demikian.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "10",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Lalu Allah menamai yang kering itu darat, dan kumpulan air itu dinamai-Nya laut. Allah melihat bahwa semuanya itu baik.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "11",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Berfirmanlah Allah: ”Hendaklah tanah menumbuhkan tunas-tunas muda, tumbuh-tumbuhan yang berbiji, segala jenis pohon buah-buahan yang menghasilkan buah yang berbiji, supaya ada tumbuh-tumbuhan di bumi.” Dan jadilah demikian.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "12",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Tanah itu menumbuhkan tunas-tunas muda, segala jenis tumbuh-tumbuhan yang berbiji dan segala jenis pohon pohonan yang menghasilkan buah yang berbiji. Allah melihat bahwa semuanya itu baik.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "13",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //         child: Padding(
                  //       padding: EdgeInsets.all(12),
                  //       child: Text(
                  //         "Jadilah petang dan jadilah pagi, itulah hari ketiga.",
                  //         style: TextStyle(
                  //           fontSize: fontSizeAyat,
                  //         ),
                  //       ),
                  //     ))
                  //   ],
                  // ),
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
