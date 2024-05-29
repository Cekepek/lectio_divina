import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/core.dart';
import 'package:flutter/material.dart';
import 'package:lectio_divina/screen/LDKalender.dart';
import 'package:lectio_divina/screen/alkitab.dart';
import 'package:lectio_divina/screen/home.dart';
import 'package:lectio_divina/screen/tambahLd.dart';
import 'package:lectio_divina/switch_button.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> getLD() async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final prefs = await SharedPreferences.getInstance();

  // final String encodedData = LD.encode([
  //   LD(
  //       id: 1,
  //       tanggal: "2024-05-23 00:00:00.000Z",
  //       judul: "test",
  //       ayat: "Kej 1:1",
  //       sabda: "test",
  //       tanggapan: "test",
  //       tindakan: "test",
  //       catatan: "test",
  //       hashtag: "test",
  //       warna: Color.fromRGBO(255, 0, 0, 1).toString()),
  //   LD(
  //       id: 2,
  //       tanggal: "2024-05-23 00:00:00.000Z",
  //       judul: "test",
  //       ayat: "Kel 1:1",
  //       sabda: "test",
  //       tanggapan: "test",
  //       tindakan: "test",
  //       catatan: "test",
  //       hashtag: "test",
  //       warna: Color.fromRGBO(0, 255, 0, 1).toString()),
  //   LD(
  //       id: 3,
  //       tanggal: "2024-05-24 00:00:00.000Z",
  //       judul: "test",
  //       ayat: "Kel 1:1",
  //       sabda: "test",
  //       tanggapan: "test",
  //       tindakan: "test",
  //       catatan: "test",
  //       hashtag: "test",
  //       warna: Color.fromRGBO(0, 255, 0, 1).toString()),
  //   LD(
  //       id: 4,
  //       tanggal: "2024-05-25 00:00:00.000Z",
  //       judul: "test",
  //       ayat: "Ams 1:1",
  //       sabda: "test",
  //       tanggapan: "test",
  //       tindakan: "test",
  //       catatan: "test",
  //       hashtag: "test",
  //       warna: Color.fromRGBO(0, 255, 0, 1).toString()),
  // ]);

  // await prefs.setString('lds_key', encodedData);

  // final String ldsstring = await prefs.getString('lds_key') ?? "";

  // final List<LD> lds = LD.decode(ldsstring);

  // globals.MyLd = lds;
  await initializeDateFormatting('id_ID', null).then((_) => runApp(MyApp()));
}

Color themeColor = Color.fromRGBO(255, 141, 116, 1);
String titleHome = "Lectio Divina";

final List<Widget> _screens = [Home(), Alkitab(), LDKalender(), TambahLd()];

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: Get.navigatorKey,
      theme: ThemeData(
        fontFamily: "Poppins",
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(245, 141, 116, 1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Lectio Divina"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // final int kitab;
  // final int bab;
  // final String ayat;
  // final int screenIndex;

  // const MyHomePage({Key? key, required this.title, required this.screenIndex, required this.kitab, required this.bab, required this.ayat}) : super(key: key);
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    loadLd();
  }

  Future<void> loadLd() async {
    final prefs = await SharedPreferences.getInstance();
    final String ldsstring = await prefs.getString('lds_key') ?? "";
    if (ldsstring != "") {
      final List<LD> ldList = LD.decode(ldsstring);
      setState(() {
        globals.MyLd = ldList;
      });
    }
  }

  Color color = Color.fromRGBO(255, 141, 116, 1);
  Widget buildColorPicker() {
    return ColorPicker(
      enableAlpha: false,
      showLabel: false,
      pickerColor: color,
      onColorChanged: (color) {
        setState(() {
          this.color = color;
          themeColor = this.color;
        });
      },
    );
  }

  void pickColor(BuildContext context) {
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ));
  }

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
                  const Image(
                      width: 48,
                      height: 24,
                      image: AssetImage('assets/images/Logo.png')),
                  const Text(
                    "Lectio Divina",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  titleHome = "Lectio Divina";
                  globals.currentIndex = 0;
                  Navigator.pop(context);
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
                        backgroundImage: AssetImage('assets/images/User.jpg'),
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
                              "Christopher Kelvin",
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
                  titleHome = "Alkitab";
                  globals.currentIndex = 1;
                  globals.namaKitab = 0;
                  globals.bab = 0;
                  globals.ayat = "0";
                  Navigator.pop(context);
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
                globals.currentIndex = 2;
                Navigator.pop(context);
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
              print("Ini Komunitas");
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
                  "Change Color",
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
                      backgroundColor: color,
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
              print("Ini Settings");
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: myDrawer(context),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            titleHome,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: _screens[globals.currentIndex]);
  }
}
