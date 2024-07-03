import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/pasal.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/main.dart';
import 'package:lectio_divina/screen/tambahLd.dart';
import 'package:lectio_divina/switch_button.dart';

class DetailBacaan extends StatefulWidget {
  const DetailBacaan({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailBacaan();
  }
}

class _DetailBacaan extends State<DetailBacaan> {
  List<Ayat> ayatBacaan = [];
  Color color = Color.fromRGBO(255, 141, 116, 1);

  List<Ayat> parseReferences(String input) {
    List<Ayat> references = [];
    List<String> parts = input.split(';');

    for (String part in parts) {
      part = part.trim();
      RegExp regExp =
          RegExp(r'(\D+)\s(\d+):(\d+(-\d+)?(,\d+(-\d+)?)*)([a-z]*)');
      Iterable<Match> matches = regExp.allMatches(part);

      for (Match match in matches) {
        String nama = match.group(1)!.trim();
        int bab = int.parse(match.group(2)!);
        List<int> ayat = [];

        String ayatStr = match.group(3)!;
        List<String> ayatParts = ayatStr.split(',');

        for (String ayatPart in ayatParts) {
          if (ayatPart.contains('-')) {
            List<String> range = ayatPart.split('-');
            int start = int.parse(range[0]);
            int end = int.parse(range[1]);
            ayat.addAll(
                List.generate(end - start + 1, (index) => start + index));
          } else {
            ayat.add(int.parse(ayatPart));
          }
        }
        for (int nomorAyat in ayat) {
          references.add(Ayat(
            id: 0,
            nomor: nomorAyat.toString(),
            nomorPasal: bab.toString(),
            text: "",
            kitab: nama,
            title: "",
            titleIncluded: "",
          ));
        }
      }
    }

    return references;
  }

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

  List<Ayat> getBacaan(String ayat) {
    List<Ayat> bacaanHariIni = parseReferences(ayat);
    List<Ayat> isiBacaan = [];
    int indexKitab = 0;
    int indexPasal = 0;
    for (Ayat ayatBacaan in bacaanHariIni) {
      for (Kitab kitab in globals.kitab) {
        if (ayatBacaan.kitab == kitab.singkatan) {
          indexKitab = kitab.id;
          for (Pasal pasal in globals.kitab[indexKitab].pasal) {
            if (ayatBacaan.nomorPasal == pasal.nomor) {
              indexPasal = pasal.id;
              for (Ayat ayatAlkitab
                  in globals.kitab[indexKitab].pasal[indexPasal].ayat) {
                if (ayatBacaan.nomor == ayatAlkitab.nomor) {
                  isiBacaan.add(ayatAlkitab);
                }
              }
            }
          }
        }
      }
    }
    return isiBacaan;
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
              onTap: () {},
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
                globals.currentIndex = 1;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: "Lectio Divina",
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
                globals.currentIndex = 2;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: "Komunitas",
                            )));
              });
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
  void initState() {
    // TODO: implement initState
    super.initState();
    ayatBacaan = getBacaan(globals.bacaanTerpilih.bacaan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: globals.ayatDipilih.isEmpty ? myDrawer(context) : Container(),
      appBar: globals.ayatDipilih.isEmpty
          ? AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
                      return [
                        PopupMenuItem(value: 0, child: Text("Tambah LD"))
                      ];
                    }),
              ],
            ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        globals.bacaanTerpilih.judulBacaan,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                      child: Text(
                        "Ayat : " + globals.bacaanTerpilih.bacaan,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Isi Bacaan :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          controller: ScrollController(),
                          itemCount: ayatBacaan.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              child: Container(
                                color: globals.ayatDipilih
                                        .contains(ayatBacaan[index])
                                    ? Colors.blue
                                    : null,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        ayatBacaan[index].nomor,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        ayatBacaan[index].text,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onLongPress: () {
                                setState(() {
                                  globals.ayatDipilih
                                          .contains(ayatBacaan[index])
                                      ? globals.ayatDipilih
                                          .remove(ayatBacaan[index])
                                      : globals.ayatDipilih
                                          .add(ayatBacaan[index]);
                                  globals.ayatDipilih
                                      .sort((a, b) => a.id.compareTo(b.id));
                                  for (Ayat ayat in globals.ayatDipilih) {
                                    debugPrint(ayat.id.toString());
                                  }
                                });
                              },
                            );
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
