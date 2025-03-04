import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:scroll_to_index/scroll_to_index.dart';

class LihatAlkitab extends StatefulWidget {
  const LihatAlkitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LihatAlkitabState();
  }
}

class _LihatAlkitabState extends State<LihatAlkitab> {
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;
  List selected = [];
  int book = 0;
  int chapter = 0;
  double? fontSizeAyat = 20;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    book = globals.namaKitab;
    // if (book - 1 < 0) book = 0;
    chapter = globals.bab;
    // if (chapter - 1 < 0) chapter = 0;
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    controller.scrollToIndex(int.parse(globals.ayat),
        preferPosition: AutoScrollPosition.begin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Alkitab",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
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
                  if (globals.kitab[book].pasal[chapter].ayat[index].tipe ==
                      "t") {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      highlightColor: Colors.blue,
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
                          ],
                        ),
                      ),
                    );
                  } else {
                    return AutoScrollTag(
                      key: ValueKey(index),
                      highlightColor: Colors.blue,
                      controller: controller,
                      index: index,
                      child: GestureDetector(
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
                        onTap: () {
                          // setState(() {
                          //   globals.ayatDipilih.remove(
                          //       globals.kitab[book].pasal[chapter].ayat[index]);
                          // });
                        },
                        onLongPress: () {
                          // setState(() {
                          //   globals.ayatDipilih.contains(globals
                          //           .kitab[book].pasal[chapter].ayat[index])
                          //       ? globals.ayatDipilih.remove(globals
                          //           .kitab[book].pasal[chapter].ayat[index])
                          //       : globals.ayatDipilih.add(globals
                          //           .kitab[book].pasal[chapter].ayat[index]);
                          //   globals.ayatDipilih
                          //       .sort((a, b) => a.id.compareTo(b.id));
                          //   for (Ayat ayat in globals.ayatDipilih) {
                          //     debugPrint(ayat.id.toString());
                          //   }
                          // });
                        },
                      ),
                    );
                  }
                }),
          ),
          Container(
            height: 56,
            color: Theme.of(context).primaryColor,
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
                      controller.jumpTo(0);
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
                  onTap: () {},
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
                      controller.jumpTo(0);
                    });
                  },
                ),
                // GestureDetector(
                //   child: Icon(
                //     CupertinoIcons.search,
                //     color: Colors.white,
                //   ),
                //   onTap: () {},
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
