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
    globals.autoJudul = prefs.getBool("autoJudul") ?? true;
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
  }

  Future<void> importLd() async {
    bool validation = await importDialog();
    int jumlahSama = 0;
    int jumlahLd = 0;
    String text;
    bool validationFileLama = false;
    ValueNotifier<int> ldTerimport = ValueNotifier<int>(0);
    if (validation) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        try {
          String? filePath = result.files.single.path;
          final File file = File(filePath!);
          text = await file.readAsString();
          String cekVersi = LD.cekVersi(text);
          final List<LD> importedLd = LD.decodeImport(text);
          jumlahLd = importedLd.length;
          if (cekVersi == "Lama") {
            validationFileLama = await importDialogFileLama();
          }
          if (validationFileLama || cekVersi == "Baru") {
            String action = "";
            bool sama = false;
            for (LD ldImport in importedLd) {
              for (LD ldTersimpan in globals.MyLd) {
                if (ldImport.sabdaBagiSaya == ldTersimpan.sabdaBagiSaya &&
                    ldImport.catatan == ldTersimpan.catatan &&
                    ldImport.ayat == ldTersimpan.ayat) {
                  jumlahSama += 1;
                  print(jumlahSama);
                  sama = true;
                  break;
                }
              }
            }
            if (sama == true && action == "") {
              action = await importSamaDialog(jumlahSama, jumlahLd);
            }
            if (!sama) {
              progressDialog(context, ldTerimport, jumlahLd);
              for (LD ld in importedLd) {
                final body = jsonEncode(LD.toMap(ld));
                final response2 =
                    await api.connectApi("/lectio_divina", "post", body);
                if (response2.status == 200) {
                  ld.id = response2.data['id'];
                }
                ldTerimport.value++;
              }
              globals.MyLd.addAll(importedLd);
              final prefs = await SharedPreferences.getInstance();
              final String encodedData = LD.encode(globals.MyLd);
              await prefs.setString(
                  'lds_data_${globals.userLogin.id}', encodedData);

              if (ldTerimport.value == jumlahLd) {
                Navigator.of(context).pop();
              }
              toastImportLD();
            } else {
              if (action == "tambah") {
                ValueNotifier<int> ldTerimport = ValueNotifier<int>(0);
                progressDialog(context, ldTerimport, jumlahLd);
                for (LD ld in importedLd) {
                  final body = jsonEncode(LD.toMap(ld));
                  final response2 =
                      await api.connectApi("/lectio_divina", "post", body);
                  if (response2.status == 200) {
                    ld.id = response2.data['id'];
                  }
                  ldTerimport.value += 1;
                  if (ldTerimport.value == jumlahLd) {
                    Navigator.of(context).pop();
                  }
                }
                globals.MyLd.addAll(importedLd);
                final prefs = await SharedPreferences.getInstance();
                final String encodedData = LD.encode(globals.MyLd);
                await prefs.setString(
                    'lds_data_${globals.userLogin.id}', encodedData);

                toastImportLD();
              } else if (action == "tidak") {
                List<LD> ldUpload = [];

                ValueNotifier<int> ldTerimport = ValueNotifier<int>(0);

                progressDialog(context, ldTerimport, jumlahLd - jumlahSama);
                for (LD ld in importedLd) {
                  bool ldSama = false;
                  for (LD ldTersimpan in globals.MyLd) {
                    if (ld.sabdaBagiSaya == ldTersimpan.sabdaBagiSaya &&
                        ld.catatan == ldTersimpan.catatan &&
                        ld.ayat == ldTersimpan.ayat) {
                      ldSama = true;
                      break;
                    }
                  }
                  if (!ldSama) {
                    final body = jsonEncode(LD.toMap(ld));
                    final response2 =
                        await api.connectApi("/lectio_divina", "post", body);
                    if (response2.status == 200) {
                      ld.id = response2.data['id'];
                    }
                    ldUpload.add(ld);
                    ldTerimport.value++;
                  }
                }
                globals.MyLd.addAll(ldUpload);
                final prefs = await SharedPreferences.getInstance();
                final String encodedData = LD.encode(globals.MyLd);
                await prefs.setString(
                    'lds_data_${globals.userLogin.id}', encodedData);
                if (ldTerimport.value == jumlahLd - jumlahSama) {
                  Navigator.of(context).pop();
                }
                toastImportLD();
              }
            }
          }
          setState(() {
            globals.currentIndex = 0;
          });
        } catch (e) {
          print("Couldn't read file");
        }
      } else {}
    }
  }

  Future<void> progressDialog(BuildContext context,
      ValueNotifier<int> jumlahImport, int totalImport) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sedang mengimport data LD", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
            ValueListenableBuilder<int>(
              valueListenable: jumlahImport,
              builder: (context, value, child) {
                return Text("$value/$totalImport");
              },
            ),
          ],
        ),
      ),
    );
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

  void toastImportLD() {
    Fluttertoast.showToast(
        msg: "LD berhasil di Import",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
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

  Future<String> importSamaDialog(int jumlahSama, int jumlahLd) async {
    String tambah = "tidak";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terdapat $jumlahSama dari $jumlahLd LD yang ingin diimport sama, apakah Anda ingin tetap menambahkan LD tersebut ?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          MaterialButton(
            onPressed: () {
              tambah = "tidak";
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
              tambah = "tambah";
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
    return tambah;
  }

  Future<bool> importDialog() async {
    bool validation = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Apakah Anda ingin melakukan import data ? tekan "Ya" kemudian pilihlah file yang ingin Anda import!',
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
              validation = true;
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
    return validation;
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

  Future<bool> importDialogFileLama() async {
    bool validation = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'File LD merupakan file dari aplikasi versi lama, apakah Anda ingin mengimport ?',
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
              validation = true;
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
    return validation;
  }

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
              setState(() {
                titleHome = "Komunitas";
                globals.currentIndex = 2;
                Navigator.pop(context);
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
            body: _screens[globals.currentIndex]));
  }
}
