import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lectio_divina/screen/cariAlkitab.dart';
import 'package:lectio_divina/screen/pilihKitab.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Alkitab extends StatefulWidget {
  const Alkitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlkitabState();
  }
}

class _AlkitabState extends State<Alkitab> {
  final itemController = ItemScrollController();

  void scrollToIndex(int index) => itemController.jumpTo(index: index);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {});
    // int targetIndex = 6;

    // // Menggunakan ScrollController untuk menavigasi ke indeks tertentu
    // _scrollControllerListView.jumpTo(
    //   targetIndex * 100.0,
    // );
  }

  final ScrollController _scrollController = ScrollController();
  // List ayat = [];
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

  Widget tampilAlkitab() {
    return ListView.builder(
        // itemScrollController: itemController,
        itemCount: globals.kitab[book].pasal[chapter].ayat.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (globals.kitab[book].pasal[chapter].ayat[index].title != "") {
            return Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Container(
                        child: Text(
                      globals.kitab[book].pasal[chapter].ayat[index].title,
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
                            globals
                                .kitab[book].pasal[chapter].ayat[index].nomor,
                            style: TextStyle(
                              fontSize: fontSizeAyat,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            convertSpecialString(convertUnicode(globals
                                .kitab[book].pasal[chapter].ayat[index].text)),
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
            );
          } else {
            return Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      globals.kitab[book].pasal[chapter].ayat[index].nomor,
                      style: TextStyle(
                        fontSize: fontSizeAyat,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      globals.kitab[book].pasal[chapter].ayat[index].text,
                      style: TextStyle(
                        fontSize: fontSizeAyat,
                      ),
                    ),
                  ))
                ],
              ),
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
              controller: _scrollController,
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
                      // Menganimasikan ListView ke indeks tertentu
                      _scrollController.jumpTo(
                          // Menyesuaikan indeks dengan tinggi item untuk mendapatkan posisi akhir yang tepat
                          0.0);
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
                      // Menganimasikan ListView ke indeks tertentu
                      _scrollController.jumpTo(
                          // Menyesuaikan indeks dengan tinggi item untuk mendapatkan posisi akhir yang tepat
                          0.0);
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
