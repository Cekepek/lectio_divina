import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lectio_divina/globals.dart' as globals;

class TambahLd extends StatefulWidget {
  const TambahLd({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TambahLdState();
  }
}

class _TambahLdState extends State<TambahLd> {
  Color? _selectedColor;
  late String judul;
  late String ayat;
  late String sabda;
  late String tanggapan;
  late String tindakan;
  late String catatan;
  late String hashtag;
  late String warna;
  // Daftar warna yang akan ditampilkan dalam dropdown
  final List<Color> _colors = [
    Color.fromRGBO(255, 0, 0, 1),
    Color.fromRGBO(255, 255, 0, 1),
    Color.fromRGBO(0, 255, 0, 1),
    Color.fromRGBO(0, 0, 255, 1),
    // Colors.orange,
    // Colors.purple,
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    judul = "";
    ayat = "";
    sabda = "";
    tanggapan = "";
    tindakan = "";
    catatan = "";
    hashtag = "";
    warna = "";
  }

  Future<void> saveLd(List<LD> lds) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = LD.encode(lds);
    await prefs.setString('lds_key', encodedData);
  }

  // Ambil daftar event dari SharedPreferences
  Future<List<LD>> loadLd() async {
    final prefs = await SharedPreferences.getInstance();
    final String ldsstring = await prefs.getString('lds_key') ?? "";
    if (ldsstring != "") {
      final List<LD> ldList = LD.decode(ldsstring);
      return ldList;
    }
    return [];
  }

  // Tambahkan satu event ke daftar di SharedPreferences
  Future<void> TambahLd(LD ld) async {
    final lds = await loadLd();
    lds.add(ld);
    await saveLd(lds);
  }

  // Future<void> tambahLD() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   LD ldBaru = LD(
  //       id: globals.MyLd.isEmpty ? 0 : globals.MyLd.length - 1,
  //       tanggal: globals.tanggalTerpilih.toString(),
  //       judul: judul,
  //       ayat: ayat,
  //       sabda: sabda,
  //       tanggapan: tanggapan,
  //       tindakan: tindakan,
  //       catatan: catatan,
  //       hashtag: hashtag,
  //       warna: warna);
  //   final String encodedData = LD.encode([ldBaru]);
  //   await prefs.setString('lds_key', encodedData);
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                judul = value;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Judul atau Topik Bacaan',
                  hintText: 'Judul Bacaan'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                ayat = value;
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Ayat yang berkesan',
                  hintText: 'Masukkan Ayat'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                TextField(
                  onChanged: (value) {
                    sabda = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Sabda Tuhan bagi saya',
                      hintText: 'Masukkan sabda Tuhan yang anda rasakan'),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                TextField(
                  onChanged: (value) {
                    tanggapan = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tanggapan Saya',
                      hintText: 'Masukkan tanggapan pribadi'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                TextField(
                  onChanged: (value) {
                    tindakan = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tindakan saya',
                      hintText: 'Masukkan tindakan yang akan saya lakukan'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                TextField(
                  onChanged: (value) {
                    catatan = value;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: 4,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Catatan',
                      hintText: 'Masukkan catatan yang ingin anda sampaikan'),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    onChanged: (value) {
                      hashtag = value;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Hashtag',
                        hintText: 'Masukkan hashtag'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Warna Tagline"),
                      DropdownButton<Color>(
                        hint: Text('Select a color'),
                        value: _selectedColor,
                        items: _colors.map((Color color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Center(
                              child: Container(
                                width: 24,
                                height: 24,
                                color: color,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (Color? newValue) {
                          setState(() {
                            _selectedColor = newValue;
                            warna = _selectedColor.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      LD ldBaru = LD(
                          id: globals.MyLd.isEmpty
                              ? 0
                              : globals.MyLd.length - 1,
                          tanggal: globals.tanggalTerpilih.toString(),
                          judul: judul,
                          ayat: ayat,
                          sabda: sabda,
                          tanggapan: tanggapan,
                          tindakan: tindakan,
                          catatan: catatan,
                          hashtag: hashtag,
                          warna: warna);
                      TambahLd(ldBaru);
                      globals.currentIndex = 2;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    title: "Lectio Divina",
                                  )));
                    });
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        'Simpan LD',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("p");
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        'Bagikan LD',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
