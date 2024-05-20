import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lectio_divina/screen/cariAlkitab.dart';
import 'package:lectio_divina/screen/pilihKitab.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class Alkitab extends StatefulWidget {
  final int kitab;
  final int bab;
  final String ayat;

  const Alkitab(
      {Key? key, required this.kitab, required this.bab, required this.ayat})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlkitabState();
  }
}

class _AlkitabState extends State<Alkitab> {
  final itemController = ItemScrollController();

  // void scrollToIndex(int index) => itemController.jumpTo(index: index);
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    controller.scrollToIndex(int.parse(widget.ayat) - 1,
        preferPosition: AutoScrollPosition.begin);
  }

  List selected = [];
  int book = 0;
  int chapter = 0;
// Fungsi untuk mengkonversi kode Unicode menjadi karakter yang sesuai
  String convertUnicode(String input) {
    // Membuat daftar kode Unicode menggunakan metode codeUnits
    List<int> codeUnits = input.runes.toList();

    // Menggunakan StringBuffer untuk menggabungkan karakter yang dikonversi
    StringBuffer buffer = StringBuffer();

    // Melakukan iterasi pada setiap kode Unicode
    for (int codeUnit in codeUnits) {
      // Mengkonversi kode Unicode menjadi karakter dan menambahkannya ke buffer
      buffer.write(String.fromCharCode(codeUnit));
    }

    // Mengembalikan string hasil konversi
    return buffer.toString();
  }

  String convertSpecialString(String input) {
    // Membuat peta konversi untuk karakter khusus
    Map<String, String> conversionMap = {
      '<t \/>':
          '', // Ganti 'Teks setelah konversi' dengan string yang diinginkan
      // Tambahkan entri lain jika diperlukan
    };

    // Melakukan konversi berdasarkan peta
    conversionMap.forEach((key, value) {
      input = input.replaceAll(key, value);
    });

    return input;
  }

  // Widget tampilAlkitab() {
  //   return
  // }

  double? fontSizeAyat = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                // itemScrollController: itemController,
                controller: controller,
                itemCount: globals.kitab[book].pasal[chapter].ayat.length,
                // physics: const NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (globals.kitab[book].pasal[chapter].ayat[index].title !=
                      "") {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      highlightColor: Colors.black.withOpacity(0.1),
                      controller: controller,
                      index: index,
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              child: Container(
                                  child: Text(
                                globals.kitab[book].pasal[chapter].ayat[index]
                                    .title,
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
                                      globals.kitab[book].pasal[chapter]
                                          .ayat[index].nomor,
                                      style: TextStyle(
                                        fontSize: fontSizeAyat,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text(
                                      convertSpecialString(convertUnicode(
                                          globals.kitab[book].pasal[chapter]
                                              .ayat[index].text)),
                                      style: TextStyle(
                                        fontSize: fontSizeAyat,
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              onLongPress: () {
                                setState(() {
                                  selected.add("test");
                                  // debugPrint(selected[3]);
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      highlightColor: Colors.black.withOpacity(0.1),
                      controller: controller,
                      index: index,
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                globals.kitab[book].pasal[chapter].ayat[index]
                                    .nomor,
                                style: TextStyle(
                                  fontSize: fontSizeAyat,
                                ),
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                globals.kitab[book].pasal[chapter].ayat[index]
                                    .text,
                                style: TextStyle(
                                  fontSize: fontSizeAyat,
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                    );
                  }
                }),
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
                      if (chapter - 1 == -1) {
                        chapter = 0;
                        if (book - 1 == -1) {
                          book = 0;
                        } else {
                          book -= 1;
                        }
                      } else {
                        chapter -= 1;
                      }
                    });
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 24, left: 24),
                    child: Text(
                        globals.kitab[book].singkatan +
                            " " +
                            globals.kitab[book].pasal[chapter].nomor,
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
                      if (chapter + 1 > globals.kitab[book].pasal.length - 1) {
                        if (book + 1 > globals.kitab.length - 1) {
                          book = 0;
                          chapter = 0;
                        } else {
                          book += 1;
                          chapter = 0;
                        }
                      } else {
                        chapter += 1;
                      }
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
