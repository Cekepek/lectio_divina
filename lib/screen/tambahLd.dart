import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/main.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lectio_divina/globals.dart' as globals;

class TambahLd extends StatefulWidget {
  const TambahLd({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TambahLdState();
  }
}

class _TambahLdState extends State<TambahLd>
    with SingleTickerProviderStateMixin {
  DateFormat format = new DateFormat("dd MMMM yyyy", "id_ID");
  TextEditingController controller = TextEditingController(text: "");
  TextEditingController controllerSabda = TextEditingController(text: "");
  TextEditingController controllerJudul = TextEditingController(text: "");
  late AnimationController animationController;

  Color _selectedColor = Color.fromRGBO(255, 0, 0, 1);
  late String judul;
  late String ayat;
  late String sabda;
  late String tanggapan;
  late String tindakan;
  late String catatan;
  late String hashtag;
  late String warna;
  late String headerSabda;
  late String tempSabda;
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
                mainAxisSize: MainAxisSize.min,
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

  bool isCompleted() {
    if (judul != "" &&
        ayat != "" &&
        sabda != "" &&
        tanggapan != "" &&
        tindakan != "" &&
        catatan != "" &&
        hashtag != "") {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
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
            warna: warna,
            selesai: isCompleted());
        TambahLd(ldBaru);
        globals.ayatDipilih.clear();
        globals.currentIndex = 1;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: "Lectio Divina",
                    )));
      }
    });
    judul = "";
    ayat = "";
    headerSabda = "";
    tempSabda = "";
    sabda = "";
    if (globals.ayatDipilih.isEmpty) {
      ayat = "";
      sabda = "";
      headerSabda = "";
      tempSabda = "";
      judul = "";
    } else {
      judul = globals.ayatDipilih[0].titleIncluded;
      controllerJudul = TextEditingController(text: judul);
      int index = 0;
      for (Ayat ayatTerpilih in globals.ayatDipilih) {
        if (ayat == "") {
          ayat += ayatTerpilih.kitab +
              " " +
              ayatTerpilih.nomorPasal +
              ":" +
              ayatTerpilih.nomor;
          headerSabda = ayat;
          tempSabda += ayatTerpilih.nomor + "." + ayatTerpilih.text + " ";
        } else {
          if (ayatTerpilih.kitab != globals.ayatDipilih[index - 1].kitab) {
            ayat += "; " +
                ayatTerpilih.kitab +
                " " +
                ayatTerpilih.nomorPasal +
                ":" +
                ayatTerpilih.nomor;
            sabda += headerSabda +
                "\n\n" +
                convertUnicode(convertSpecialString(tempSabda)) +
                "\n\n";
            headerSabda = ayatTerpilih.kitab +
                " " +
                ayatTerpilih.nomorPasal +
                ":" +
                ayatTerpilih.nomor;
            tempSabda = ayatTerpilih.nomor + "." + ayatTerpilih.text + " ";
          } else {
            if (ayatTerpilih.nomorPasal !=
                globals.ayatDipilih[index - 1].nomorPasal) {
              ayat += "." + ayatTerpilih.nomorPasal + ":" + ayatTerpilih.nomor;
              sabda += headerSabda +
                  "\n\n" +
                  convertUnicode(convertSpecialString(tempSabda)) +
                  "\n\n";
              headerSabda = ayatTerpilih.kitab +
                  " " +
                  ayatTerpilih.nomorPasal +
                  ":" +
                  ayatTerpilih.nomor;
              tempSabda = ayatTerpilih.nomor + "." + ayatTerpilih.text + " ";
            } else {
              if (int.parse(ayatTerpilih.nomor) -
                      int.parse(globals.ayatDipilih[index - 1].nomor) ==
                  1) {
                if ((globals.ayatDipilih[index + 1].kitab ==
                            ayatTerpilih.kitab &&
                        globals.ayatDipilih[index + 1].nomorPasal ==
                            ayatTerpilih.nomorPasal) ||
                    index == globals.ayatDipilih.length - 1) {
                  if (int.parse(ayatTerpilih.nomor) + 1 !=
                      int.parse(globals.ayatDipilih[index + 1].nomor)) {
                    ayat += "-" + ayatTerpilih.nomor;
                    headerSabda += "-" + ayatTerpilih.nomor;
                  }
                } else {
                  ayat += "-" + ayatTerpilih.nomor;
                  headerSabda += "-" + ayatTerpilih.nomor;
                }
              } else {
                ayat += "," + ayatTerpilih.nomor;
                headerSabda += "," + ayatTerpilih.nomor;
              }
              tempSabda += ayatTerpilih.nomor + "." + ayatTerpilih.text + " ";
            }
          }
        }
        if (index == globals.ayatDipilih.length - 1) {
          sabda += headerSabda +
              "\n\n" +
              convertUnicode(convertSpecialString(tempSabda));
        }
        index += 1;
      }
      controllerSabda = TextEditingController(text: sabda);
      controller = TextEditingController(text: ayat);
    }
    tanggapan = "";
    tindakan = "";
    catatan = "";
    hashtag = "";
    warna = Color.fromRGBO(255, 0, 0, 1).toString();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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

  void ldTersimpan() => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/animations/done.json',
                  repeat: false,
                  controller: animationController, onLoaded: (composition) {
                animationController.forward();
              }),
              Text(
                "LD Tersimpan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      );
  void backDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Data Belum Tersimpan",
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Data LD belum tersimpan, apakah Anda ingin menyimpan LD ?",
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            MaterialButton(
              onPressed: () {
                globals.ayatDipilih.clear();
                globals.currentIndex = 1;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(
                              title: "Lectio Divina",
                            )));
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
                Navigator.pop(context);
                ldTersimpan();
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(width: 1, color: Colors.grey),
                      color: Theme.of(context).colorScheme.inversePrimary),
                  child: Text(
                    "SIMPAN",
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tambah LD",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          onPressed: () {
            backDialog();
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
                controller: controllerJudul,
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
                      ],
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       LD ldBaru = LD(
                  //           id: globals.MyLd.isEmpty
                  //               ? 0
                  //               : globals.MyLd.length - 1,
                  //           tanggal: globals.tanggalTerpilih.toString(),
                  //           judul: judul,
                  //           ayat: ayat,
                  //           sabda: sabda,
                  //           tanggapan: tanggapan,
                  //           tindakan: tindakan,
                  //           catatan: catatan,
                  //           hashtag: hashtag,
                  //           warna: warna);
                  //       TambahLd(ldBaru);
                  //       globals.currentIndex = 2;
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => MyHomePage(
                  //                     title: "Lectio Divina",
                  //                   )));
                  //     });
                  //   },
                  //   child: Container(
                  //     height: 40,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         color: Theme.of(context).colorScheme.inversePrimary,
                  //         borderRadius: BorderRadius.circular(5)),
                  //     child: Center(
                  //       child: Text(
                  //         'Simpan LD',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     print("p");
                  //   },
                  //   child: Container(
                  //     height: 40,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         border: Border.all(
                  //             color:
                  //                 Theme.of(context).colorScheme.inversePrimary),
                  //         color: Colors.transparent,
                  //         borderRadius: BorderRadius.circular(5)),
                  //     child: Center(
                  //       child: Text(
                  //         'Bagikan LD',
                  //         style: TextStyle(
                  //           color: Theme.of(context).colorScheme.inversePrimary,
                  //           fontSize: 15,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
