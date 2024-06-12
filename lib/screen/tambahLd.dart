import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ayat.dart';
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
  DateFormat format = new DateFormat("dd MMMM yyyy", "id_ID");
  TextEditingController controller = TextEditingController(text: "");
  TextEditingController controllerSabda = TextEditingController(text: "");

  Color _selectedColor = Color.fromRGBO(255, 0, 0, 1);
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

  void colorPicker(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Pick Your Color'),
            content: TextButton(
              child: Column(
                children: [
                  BlockPicker(
                      pickerColor: _selectedColor,
                      availableColors: _colors,
                      onColorChanged: (color) => setState(() {
                            _selectedColor = color;
                            warna = _selectedColor.toString();
                          })),
                  Text(
                    'SELECT',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ));

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: globals.tanggalTerpilih,
            firstDate: DateTime.utc(2020, 5, 15),
            lastDate: DateTime.utc(2030, 5, 15))
        .then((value) => setState(() {
              globals.tanggalTerpilih = value!;
            }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    judul = "";
    ayat = "";
    sabda = "";
    if (globals.ayatDipilih.isEmpty) {
      ayat = "";
    } else {
      for (Ayat ayatTerpilih in globals.ayatDipilih) {
        ayat += ayatTerpilih.kitab +
            " " +
            ayatTerpilih.nomorPasal +
            ":" +
            ayatTerpilih.nomor;
        controller = TextEditingController(text: ayat);
        sabda += ayatTerpilih.nomor +
            " " +
            convertUnicode(convertSpecialString(ayatTerpilih.text));
        controllerSabda = TextEditingController(text: sabda);
      }
    }
    tanggapan = "";
    tindakan = "";
    catatan = "";
    hashtag = "";
    warna = Color.fromRGBO(255, 0, 0, 1).toString();
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
    globals.MyLd.add(ld);
    await saveLd(lds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () {
            LD ldBaru = LD(
                id: globals.MyLd.isEmpty ? 0 : globals.MyLd.length - 1,
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          title: "Lectio Divina",
                        )));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: _showDatePicker,
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey, width: 1)),
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_month_outlined),
                      Text(
                        "   Tanggal : " +
                            format.format(globals.tanggalTerpilih),
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ),
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
                controller: controller,
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
                    controller: controllerSabda,
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

                        GestureDetector(
                          onTap: () {
                            colorPicker(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: Row(children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _selectedColor),
                                width: 24,
                                height: 24,
                              ),
                              Icon(
                                Icons.arrow_drop_down,
                                size: 24.0,
                              ),
                            ]),
                          ),
                        )
                        // BlockPicker(
                        //     pickerColor: _selectedColor,
                        //     availableColors: _colors,
                        //     onColorChanged: (color) => setState(() {
                        //           _selectedColor = color;
                        //           warna = _selectedColor.toString();
                        //         }))
                        // SizedBox(
                        //   width: 150,
                        //   height: 48,
                        //   child: DropdownButtonFormField<Color>(
                        //     decoration: InputDecoration(
                        //       border: OutlineInputBorder(
                        //           borderRadius: BorderRadius.circular(10)),
                        //     ),
                        //     hint: Text('Select a color'),
                        //     value: _selectedColor,
                        //     items: _colors.map((Color color) {
                        //       return DropdownMenuItem<Color>(
                        //         value: color,
                        //         child: Center(
                        //           child: Container(
                        //             decoration: BoxDecoration(
                        //                 shape: BoxShape.circle, color: color),
                        //             width: 32,
                        //             height: 32,
                        //           ),
                        //         ),
                        //       );
                        //     }).toList(),
                        //     onChanged: (Color? newValue) {
                        //       setState(() {
                        //         _selectedColor = newValue;
                        //         warna = _selectedColor.toString();
                        //       });
                        //     },
                        //   ),
                        // ),
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
      ),
    );
  }
}
