import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/main.dart';
import 'package:lectio_divina/model/themeModel.dart';
import 'package:lectio_divina/screen/cariAlkitab.dart';
import 'package:lectio_divina/screen/pilihKitab.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/screen/tambahLd.dart';
import 'package:lectio_divina/switch_button.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alkitab extends StatefulWidget {
  const Alkitab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlkitabState();
  }
}

class _AlkitabState extends State<Alkitab> {
  String namaFile = "";
  String? directoryPath;
  final itemController = ItemScrollController();

  // void scrollToIndex(int index) => itemController.jumpTo(index: index);
  late AutoScrollController controller;
  final scrollDirection = Axis.vertical;

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
    controller.scrollToIndex(int.parse(globals.ayat) - 1,
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
  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('color', globals.colorTheme.value);
  }

  Widget buildColorPicker() {
    return ColorPicker(
      enableAlpha: false,
      showLabel: false,
      pickerColor: themeColor,
      onColorChanged: (color) {
        setState(() {
          themeColor = color;
          globals.colorTheme = color;
          saveTheme();
        });
      },
    );
  }

  double? fontSizeAyat = 20;
  void pickColor(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Pilih Warna Tema"),
              content: Column(
                children: [
                  buildColorPicker(),
                  TextButton(
                    child: Text("Pilih", style: TextStyle(fontSize: 20)),
                    onPressed: () {
                      theme.updateTheme(themeColor);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
  }

  Future<void> exportFile(String namaFile) async {
    final File file = File('$directoryPath/$namaFile.txt');
    String text = LD.encode(globals.MyLd);
    print(text);
    await file.writeAsString(text);
    toastExportLD();
  }

  void namaFileDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Masukkan Nama File Anda", textAlign: TextAlign.center),
            content: TextField(
              onChanged: (value) {
                namaFile = value;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nama File',
                  hintText: 'FileLD'),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    child: Text("BATALKAN")),
              ),
              MaterialButton(
                onPressed: () {
                  exportFile(namaFile);
                  Navigator.pop(context);
                },
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(width: 1, color: Colors.grey),
                        color: Theme.of(context).primaryColor),
                    child: Text(
                      "OK",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ),
            ],
          ));
  Future<void> pickDirectoryPath() async {
    directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      print("Path direktori yang dipilih: $directoryPath");
      namaFileDialog();
    } else {}
  }

  void exportDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Apakah Anda ingin melakukan export data ? tekan "Ya" kemudian pilihlah folder yang ingin Anda gunakan untuk menyimpan!',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.black),
                  ),
                  child: Text("TIDAK")),
            ),
            MaterialButton(
              onPressed: () {
                pickDirectoryPath();
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(width: 1, color: Colors.grey),
                      color: Theme.of(context).primaryColor),
                  child: Text(
                    "YA",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
      );

  void toastExportLD() {
    Fluttertoast.showToast(
      msg: "File LD berhasil export",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> importLd() async {
    String text;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      try {
        String? filePath = result.files.single.path;
        final File file = File(filePath!);
        text = await file.readAsString();
        final List<LD> importedLd = LD.decode(text);
        globals.MyLd.addAll(importedLd);
        final prefs = await SharedPreferences.getInstance();
        final String encodedData = LD.encode(globals.MyLd);
        await prefs.setString('lds_data_${globals.userLogin.id}', encodedData);
        print(encodedData);
      } catch (e) {
        print("Couldn't read file");
      }
    } else {}
  }

  //DRAWER DI ALKITAB HARUS DI NAVIGATOR PUSH UNTUK PINDAH PAGE TIDAK BISA NAVIGATOR POP
  Widget myDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
                child: GestureDetector(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                      width: 48,
                      height: 24,
                      image: AssetImage('assets/images/Logo.png')),
                  Text(
                    "Lectio Divina",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  titleHome = "Lectio Divina";
                  globals.currentIndex = 0;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: "Lectio Divina",
                              )));
                });
              },
            )),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('assets/images/blank.jpeg'),
                        // minRadius: 50,
                        radius: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              globals.userLogin.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("ini profile");
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => const MyLogin(),
                                //     ),
                                //   );
                              },
                              child: const Text(
                                "Lihat Profile",
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: ListTile(
              leading: Icon(
                CupertinoIcons.book_fill,
                color: Colors.black,
              ),
              title: Text(
                "Alkitab",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                setState(() {
                  // titleHome = "Alkitab";
                  // globals.currentIndex = 1;
                  globals.namaKitab = 0;
                  globals.bab = 0;
                  globals.ayat = "0";
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Alkitab()));
                });
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.note, color: Colors.black),
            title: Text(
              "My LD",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              setState(() {
                titleHome = "My LD";
                globals.currentIndex = 1;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: titleHome,
                            )));
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.black),
            title: Text(
              "LD Orang",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              print("Ini LD Orang");
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.person_3_fill, color: Colors.black),
            title: Text(
              "Komunitas",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              setState(() {
                titleHome = "Komunitas";
                globals.currentIndex = 2;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: titleHome,
                            )));
              });
            },
          ),
          ListTile(
            leading:
                Icon(CupertinoIcons.cloud_download_fill, color: Colors.black),
            title: Text(
              "Export LD",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              exportDialog();
            },
          ),
          ListTile(
            leading:
                Icon(CupertinoIcons.cloud_download_fill, color: Colors.black),
            title: Text(
              "Import LD",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              importLd();
            },
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Background Music",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SwitchButton()
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Change Background Color",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  child: CircleAvatar(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 1),
                    // minRadius: 50,
                    radius: 20,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 18,
                    ),
                  ),
                  onTap: () {
                    pickColor(context);
                  },
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: Text(
              "Settings",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              setState(() {
                titleHome = "Settings";
                globals.currentIndex = 3;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: titleHome,
                            )));
              });
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.exclamationmark_circle,
                color: Colors.black),
            title: Text(
              "FAQ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              print("Ini FAQ");
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.black),
            title: Text(
              "Sign Out",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('userLogin');
              main();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: globals.ayatDipilih.isEmpty ? myDrawer(context) : Container(),
      appBar: globals.ayatDipilih.isEmpty
          ? AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                titleHome,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            )
          : AppBar(
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    globals.ayatDipilih.clear();
                  });
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    onSelected: (result) {
                      if (result == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TambahLd()),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [PopupMenuItem(value: 0, child: Text("Buat LD"))];
                    }),
              ],
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
                  if (globals.kitab[book].pasal[chapter].ayat[index].title !=
                      "") {
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
                            GestureDetector(
                              child: Container(
                                color: globals.ayatDipilih.contains(globals
                                        .kitab[book].pasal[chapter].ayat[index])
                                    ? Colors.blue
                                    : null,
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
                              ),
                              onTap: () {
                                setState(() {
                                  globals.ayatDipilih.remove(globals
                                      .kitab[book].pasal[chapter].ayat[index]);
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  globals.ayatDipilih.contains(globals
                                          .kitab[book]
                                          .pasal[chapter]
                                          .ayat[index])
                                      ? globals.ayatDipilih.remove(globals
                                          .kitab[book]
                                          .pasal[chapter]
                                          .ayat[index])
                                      : globals.ayatDipilih.add(globals
                                          .kitab[book]
                                          .pasal[chapter]
                                          .ayat[index]);
                                  globals.ayatDipilih
                                      .sort((a, b) => a.id.compareTo(b.id));
                                  for (Ayat ayat in globals.ayatDipilih) {
                                    debugPrint(ayat.id.toString());
                                  }
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
                      highlightColor: Colors.blue,
                      controller: controller,
                      index: index,
                      child: GestureDetector(
                        child: Container(
                          color: globals.ayatDipilih.contains(globals
                                  .kitab[book].pasal[chapter].ayat[index])
                              ? Colors.blue
                              : null,
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
                          setState(() {
                            globals.ayatDipilih.remove(
                                globals.kitab[book].pasal[chapter].ayat[index]);
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            globals.ayatDipilih.contains(globals
                                    .kitab[book].pasal[chapter].ayat[index])
                                ? globals.ayatDipilih.remove(globals
                                    .kitab[book].pasal[chapter].ayat[index])
                                : globals.ayatDipilih.add(globals
                                    .kitab[book].pasal[chapter].ayat[index]);
                            globals.ayatDipilih
                                .sort((a, b) => a.id.compareTo(b.id));
                            for (Ayat ayat in globals.ayatDipilih) {
                              debugPrint(ayat.id.toString());
                            }
                          });
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
                      controller.jumpTo(0);
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
