import 'dart:ffi';

import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingsState();
  }
}

class _SettingsState extends State<Settings> {
  bool showExportSetting = false;
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
                  onPressed: () {},
                  child: Container(
                      width: 150,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "OFF",
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
                  onPressed: () {},
                  child: Container(
                      width: 150,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "OFF",
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
                                          onPressed: () {},
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
                                                "Bold",
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
                                          onPressed: () {},
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
                                                "Normal",
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
                                          onPressed: () {},
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
                                                "Normal",
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
                                          onPressed: () {},
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
                                                "Normal",
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
                                          onPressed: () {},
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
                                                "Normal",
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
                                          onPressed: () {},
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
                                                "Normal",
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
