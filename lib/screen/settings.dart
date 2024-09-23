import 'package:flutter/material.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  bool showExportSetting = false;

  Future<void> changeSettings(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Background Music",
                  style: TextStyle(fontSize: 16),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      globals.backgroundMusic
                          ? globals.backgroundMusic = false
                          : globals.backgroundMusic = true;
                      changeSettings(
                          "backgroundMusic", globals.backgroundMusic);
                    });
                  },
                  child: Container(
                      width: 150,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        globals.backgroundMusic ? "ON" : "OFF",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Auto Judul LD",
                  style: TextStyle(fontSize: 16),
                ),
                MaterialButton(
                  onPressed: () {
                    setState(() {
                      globals.autoJudul
                          ? globals.autoJudul = false
                          : globals.autoJudul = true;
                      changeSettings("autoJudul", globals.autoJudul);
                    });
                  },
                  child: Container(
                      width: 150,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        globals.autoJudul ? "ON" : "OFF",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  showExportSetting
                      ? showExportSetting = false
                      : showExportSetting = true;
                });
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    )),
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Format Export to WA",
                            style: TextStyle(fontSize: 16),
                          ),
                          showExportSetting
                              ? Icon(Icons.arrow_drop_up)
                              : Icon(Icons.arrow_drop_down),
                        ],
                      ),
                      showExportSetting
                          ? Container(
                              padding: EdgeInsets.only(top: 16),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Header",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              globals.header
                                                  ? globals.header = false
                                                  : globals.header = true;
                                              changeSettings(
                                                  "header", globals.header);
                                            });
                                          },
                                          child: Container(
                                              width: 120,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text(
                                                globals.header
                                                    ? "Bold"
                                                    : "Normal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Ayat Bacaan",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              globals.ayatBacaan
                                                  ? globals.ayatBacaan = false
                                                  : globals.ayatBacaan = true;

                                              changeSettings("ayatBacaan",
                                                  globals.ayatBacaan);
                                            });
                                          },
                                          child: Container(
                                              width: 120,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text(
                                                globals.ayatBacaan
                                                    ? "Bold"
                                                    : "Normal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Isi Ayat",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              globals.isiAyat
                                                  ? globals.isiAyat = false
                                                  : globals.isiAyat = true;
                                              changeSettings(
                                                  "isiAyat", globals.isiAyat);
                                            });
                                          },
                                          child: Container(
                                              width: 120,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text(
                                                globals.isiAyat
                                                    ? "Bold"
                                                    : "Normal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Isi Sabda",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              globals.isiSabda
                                                  ? globals.isiSabda = false
                                                  : globals.isiSabda = true;
                                              changeSettings(
                                                  "isiSabda", globals.isiSabda);
                                            });
                                          },
                                          child: Container(
                                              width: 120,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text(
                                                globals.isiSabda
                                                    ? "Bold"
                                                    : "Normal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Isi Tanggapan",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              globals.isiTanggapan
                                                  ? globals.isiTanggapan = false
                                                  : globals.isiTanggapan = true;
                                              changeSettings("isiTanggapan",
                                                  globals.isiTanggapan);
                                            });
                                          },
                                          child: Container(
                                              width: 120,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text(
                                                globals.isiTanggapan
                                                    ? "Bold"
                                                    : "Normal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, right: 8, left: 8, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Isi Tindakan",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              globals.isiTindakan
                                                  ? globals.isiTindakan = false
                                                  : globals.isiTindakan = true;
                                              changeSettings("isiTindakan",
                                                  globals.isiTindakan);
                                            });
                                          },
                                          child: Container(
                                              width: 120,
                                              padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Text(
                                                globals.isiTindakan
                                                    ? "Bold"
                                                    : "Normal",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ))
                          : Row(
                              children: [],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
