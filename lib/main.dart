import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/model/themeModel.dart';
import 'package:lectio_divina/screen/about.dart';
import 'package:lectio_divina/screen/faq.dart';
import 'package:lectio_divina/screen/login.dart';
import 'package:lectio_divina/screen/profile.dart';
import 'package:lectio_divina/screen/settings.dart';
import 'package:lectio_divina/state_util.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/core.dart';
import 'package:flutter/material.dart';
import 'package:lectio_divina/screen/LDKalender.dart';
import 'package:lectio_divina/screen/alkitab.dart';
import 'package:lectio_divina/screen/home.dart';
import 'package:lectio_divina/screen/komunitas.dart';
import 'package:lectio_divina/switch_button.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lectio_divina/model/api.dart' as api;

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String userLogin = prefs.getString("userLogin") ?? "";
  globals.colorTheme = Color(prefs.getInt("color") ?? globals.colorTheme.value);
  if (userLogin != "") {
    globals.userLogin = User.fromJson(jsonDecode(userLogin));
  }
  return userLogin;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) async {
    if (result == "") {
      runApp(MyLogin());
    } else {
      WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
      FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
      await initializeDateFormatting('id_ID', null).then((_) => runApp(
            ChangeNotifierProvider(
              create: (_) => ThemeModel(),
              child: MyApp(),
            ),
          ));
    }
  });
}

Color themeColor = Color.fromRGBO(255, 141, 116, 1);
String titleHome = "Lectio Divina";

final List<Widget> _screens = [
  Home(),
  LDKalender(),
  Komunitas(),
  Settings(),
  Profile(),
  About(),
  Faq()
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeModel>(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: Get.navigatorKey,
      theme: theme.currentTheme,
      home: const MyHomePage(title: "Lectio Divina"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String namaFile = "";
  String? directoryPath;

  Future<void> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    globals.colorTheme = Color(prefs.getInt('color') ?? themeColor.value);
    globals.backgroundMusic = prefs.getBool('backgroundMusic') ?? false;
    globals.backgroundMusic
        ? FlameAudio.bgm
            .play('Kumasuk Ruang Maha Kudus (Instrumental).mp3', volume: 1)
        : FlameAudio.bgm.stop();
    globals.autoJudul = prefs.getBool("autoJudul") ?? false;
    globals.header = prefs.getBool("header") ?? true;
    globals.ayatBacaan = prefs.getBool("ayatBacaan") ?? false;
    globals.isiAyat = prefs.getBool("isiAyat") ?? false;
    globals.isiSabda = prefs.getBool("isiSabda") ?? false;
    globals.isiTanggapan = prefs.getBool("isiTanggapan") ?? false;
    globals.isiTindakan = prefs.getBool("isiTindakan") ?? false;
  }

  @override
  void initState() {
    super.initState();
    FlameAudio.bgm.initialize();
    getSettings();
    loadLd();
  }

  Future<void> importLd() async {
    String text;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      try {
        String? filePath = result.files.single.path;
        final File file = File(filePath!);
        text = await file.readAsString();
        final List<LD> importedLd = LD.decodeImport(text);
        for (LD ld in importedLd) {
          final body = jsonEncode(LD.toMap(ld));
          final response2 =
              await api.connectApi("/lectio_divina", "post", body);
          if (response2.status == 200) {
            ld.id = response2.data['id'];
          }
        }
        globals.MyLd.addAll(importedLd);
        final prefs = await SharedPreferences.getInstance();
        final String encodedData = LD.encode(globals.MyLd);
        await prefs.setString('lds_data_${globals.userLogin.id}', encodedData);
        Fluttertoast.showToast(
            msg: "LD berhasil di Import",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          globals.currentIndex = 0;
        });
        print(encodedData);
      } catch (e) {
        print("Couldn't read file");
      }
    } else {}
  }

  Future<void> pickDirectoryPath() async {
    directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      print("Path direktori yang dipilih: $directoryPath");
      namaFileDialog();
    } else {}
  }

  Future<void> exportFile(String namaFile) async {
    final File file = File('$directoryPath/$namaFile.txt');
    String text = LD.encode(globals.MyLd);
    print(text);
    await file.writeAsString(text);
    toastExportLD();
  }

  Future<void> loadLd() async {
    int id = globals.userLogin.id;
    print("ID USER : " + globals.userLogin.id.toString());

    final prefs = await SharedPreferences.getInstance();
    final String ldsstring =
        await prefs.getString('lds_data_${globals.userLogin.id}') ?? "";
    final body = jsonEncode({"id_user": id});
    print(body);
    final response =
        await api.connectApi('/sinkronasi?id_user=$id', 'post', null);
    if (response.status == 200) {
      print("MASUK");
      print(response.data);
      if (response.message == 'berhasil') {
        if (ldsstring != "") {
          final List<LD> ldList = LD.decode(ldsstring);
          ldList.sort((a, b) => a.tanggal.compareTo(b.tanggal));
          Map<String, dynamic> tanggalSinkron = {
            "tanggalAkhirDb": DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(DateTime.parse(response.data[0]["first_date"])),
            "tanggalAkhirApp":
                DateFormat("yyyy-MM-dd HH:mm:ss").format(ldList.last.tanggal),
          };
          print(tanggalSinkron);
          if (DateTime.parse(tanggalSinkron["tanggalAkhirDb"])
              .isBefore(DateTime.parse(tanggalSinkron["tanggalAkhirApp"]))) {
            for (LD ld in ldList) {
              print("BANDINGKAN TANGGAL : " +
                  ld.tanggal.toString() +
                  ":" +
                  tanggalSinkron["tanggalAkhirDb"]);
              if (DateTime.parse(
                      DateFormat("yyyy-MM-dd HH:mm:ss").format(ld.tanggal))
                  .isAfter(DateTime.parse(tanggalSinkron["tanggalAkhirDb"]))) {
                final body = jsonEncode({
                  'id': 0,
                  'tanggal':
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(ld.tanggal),
                  'judul1': ld.judul,
                  'judul2': ld.judul2,
                  'ayat': ld.ayat,
                  'isi_ayat': ld.sabda,
                  'sabda_tuhan': ld.sabdaBagiSaya,
                  'tanggapan': ld.tanggapan,
                  'tindakan': ld.tindakan,
                  'hashtag': ld.hashtag,
                  'catatan': ld.catatan,
                  'warna_tagline': ld.warna,
                  'shareable': ld.shareable ? 1 : 0,
                  'status': ld.selesai ? 1 : 0,
                  'id_user': globals.userLogin.id,
                  'statusUpload': ld.statusUpload ? 1 : 0,
                });
                final response2 =
                    await api.connectApi("/lectio_divina", "post", body);
                if (response2.status == 200) {
                  print("KEUPLOAD ");

                  print(response2.data['id']);
                  ld.id = response2.data['id'];
                } else {
                  throw Exception('Failed to read API');
                }
              }
            }
          } else if (DateTime.parse(tanggalSinkron["tanggalAkhirDb"])
              .isAfter(DateTime.parse(tanggalSinkron["tanggalAkhirApp"]))) {
            String tanggalAwal = tanggalSinkron["tanggalAkhirDb"];
            String tanggalAkhir = tanggalSinkron["tanggalAkhirApp"];
            final response2 = await api.connectApi(
                '/lectio_divina/$tanggalAkhir/$tanggalAwal/$id', 'get', null);
            final List<LD> listDb = LD.decode(jsonEncode(response2.data));
            ldList.addAll(listDb);
            final prefs = await SharedPreferences.getInstance();
            final String encodedData = LD.encode(ldList);
            await prefs.setString(
                'lds_data_${globals.userLogin.id}', encodedData);
          }

          setState(() {
            globals.MyLd = ldList;
          });
        } else {
          String tanggalAwal = DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.parse(response.data[0]["first_date"]));
          String tanggalAkhir = DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.parse(response.data[0]["last_date"]));
          final response3 = await api.connectApi(
              '/lectio_divina/$tanggalAkhir/$tanggalAwal/$id', 'get', null);
          if (response3.status == 200) {
            if (response3.data != null) {
              final List<LD> lds = LD.decode(jsonEncode(response3.data));
              final prefs = await SharedPreferences.getInstance();
              final String encodedData = LD.encode(lds);
              await prefs.setString(
                  'lds_data_${globals.userLogin.id}', encodedData);
              setState(() {
                globals.MyLd = lds;
              });
            }
          }
        }
      } else {
        throw Exception('Failed to read API');
      }
    }
  }

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

  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('color', globals.colorTheme.value);
  }

  Widget buildColorPicker() {
    return ColorPicker(
      enableAlpha: false,
      showLabel: false,
      pickerColor: globals.colorTheme,
      onColorChanged: (color) {
        setState(() {
          themeColor = color;
          globals.colorTheme = color;
          saveTheme();
        });
      },
    );
  }

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
                      image: AssetImage('assets/images/new_logo.png')),
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
                                setState(() {
                                  titleHome = "Profile";
                                  globals.currentIndex = 4;
                                  Navigator.pop(context);
                                });
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
              // setState(() {
              //   titleHome = "Komunitas";
              //   globals.currentIndex = 2;
              //   Navigator.pop(context);
              // });
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
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.exclamationmark_circle,
                color: Colors.black),
            title: Text(
              "About",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              setState(() {
                titleHome = "About";
                globals.currentIndex = 5;
                Navigator.pop(context);
              });
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.chat_bubble_2, color: Colors.black),
            title: Text(
              "FAQ",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              setState(() {
                titleHome = "FAQ";
                globals.currentIndex = 6;
                Navigator.pop(context);
              });
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

  void backDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Apakah Anda yakin ingin keluar dari Aplikasi ?",
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
                SystemNavigator.pop();
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(width: 1, color: Colors.grey),
                      color: Theme.of(context).primaryColor),
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: ((didPop) {
        if (didPop) {
          return;
        }
        backDialog();
      }),
      child: Scaffold(
          drawer: myDrawer(context),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              titleHome,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          body: _screens[globals.currentIndex]),
    );
  }
}
