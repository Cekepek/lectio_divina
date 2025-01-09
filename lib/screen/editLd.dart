import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/main.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lectio_divina/model/api.dart' as api;

class EditLd extends StatefulWidget {
  const EditLd({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EditLdState();
  }
}

class _EditLdState extends State<EditLd> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  DateFormat format = new DateFormat("dd MMMM yyyy", "id_ID");
  late LD editedLd;
  LD editLd = LD(
      id: 0,
      tanggal: DateTime.now(),
      judul: "",
      judul2: "",
      ayat: "",
      sabda: "",
      sabdaBagiSaya: "",
      tanggapan: "",
      tindakan: "",
      catatan: "",
      hashtag: "",
      warna: "",
      shareable: false,
      selesai: false,
      user_id: 0,
      statusUpload: false);
  late DateTime tanggalLd;
  final TextEditingController judul = TextEditingController();
  final TextEditingController judul2 = TextEditingController();
  final TextEditingController ayat = TextEditingController();
  final TextEditingController sabda = TextEditingController();
  final TextEditingController sabdaBagiSaya = TextEditingController();
  final TextEditingController tanggapan = TextEditingController();
  final TextEditingController tindakan = TextEditingController();
  final TextEditingController catatan = TextEditingController();
  final TextEditingController hashtag = TextEditingController();
  late Color warna;
  bool selesai = false;
  bool simpanClicked = false;
  bool shareable = false;
  bool keyboardUsed = false;
  bool statusUpload = false;
  FocusNode myFocusNodeJudul = FocusNode();
  FocusNode myFocusNodeJudul2 = FocusNode();
  FocusNode myFocusNodeAyat = FocusNode();
  FocusNode myFocusNodeSabda = FocusNode();
  FocusNode myFocusNodeSabdaBagiSaya = FocusNode();
  FocusNode myFocusNodeTanggapan = FocusNode();
  FocusNode myFocusNodeTindakan = FocusNode();
  FocusNode myFocusNodeCatatan = FocusNode();
  FocusNode myFocusNodeHashtag = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLdToEdit();

    print(editLd.id);
    tanggalLd = editLd.tanggal;
    print(editLd.judul);
    judul.text = editLd.judul;
    judul2.text = editLd.judul2;
    print(judul.text);
    ayat.text = editLd.ayat;
    sabda.text = editLd.sabda;
    sabdaBagiSaya.text = editLd.sabdaBagiSaya;
    tanggapan.text = editLd.tanggapan;
    tindakan.text = editLd.tindakan;
    catatan.text = editLd.catatan;
    hashtag.text = editLd.hashtag;
    shareable = editLd.shareable;
    warna = Color(int.parse(editLd.warna));
    selesai = editLd.selesai;
    editedLd = LD(
        id: editLd.id,
        tanggal: tanggalLd,
        judul: judul.text,
        judul2: judul2.text,
        ayat: ayat.text,
        sabda: sabda.text,
        sabdaBagiSaya: sabdaBagiSaya.text,
        tanggapan: tanggapan.text,
        tindakan: tindakan.text,
        catatan: catatan.text,
        hashtag: hashtag.text,
        warna: warna.toString(),
        shareable: shareable,
        selesai: selesai,
        user_id: globals.userLogin.id,
        statusUpload: statusUpload);
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        editLd.selesai = selesai;
        EditLd(editedLd);
        globals.ayatDipilih.clear();
        Fluttertoast.showToast(
            msg: "LD berhasil di update",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
        globals.currentIndex = 1;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: "Lectio Divina",
                    )));
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _getLdToEdit() {
    for (LD ld in globals.MyLd) {
      if (ld.id == globals.idLdEdit) {
        print(globals.idLdEdit);
        editLd = ld;
      }
    }
  }

  Future<List<LD>> loadLd() async {
    final prefs = await SharedPreferences.getInstance();
    final String ldsstring =
        await prefs.getString('lds_data_${globals.userLogin.id}') ?? "";
    if (ldsstring != "") {
      final List<LD> ldList = LD.decode(ldsstring);
      return ldList;
    }
    return [];
  }

  void uploadLd(LD ld) async {
    final body = jsonEncode({
      'id': ld.id,
      'tanggal': DateFormat('yyyy-MM-dd HH:mm:ss').format(ld.tanggal),
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
      'id_user': ld.user_id,
      'statusUpload': 1,
    });
    // final response = await http.post(
    //     Uri.parse("http://sw.crossnet.co.id:5868/lectio_divina"),
    //     body: body);
    final response = await api.connectApi("/updateLectioDivina", "put", body);
    if (response.status == 200) {
      if (response.message == "berhasil") {
        print("UPLOADED");
        setState(() {
          statusUpload = true;
        });
      }
    } else {
      throw Exception('Failed to read API');
    }
  }

  Future<void> saveLd(List<LD> lds) async {
    setState(() {
      globals.MyLd = lds;
    });
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = LD.encode(lds);
    await prefs.setString('lds_data_${globals.userLogin.id}', encodedData);
  }

  Future<void> EditLd(LD ld) async {
    final lds = await loadLd();
    int indexLd = 0;
    for (LD savedLd in lds) {
      if (savedLd.id == ld.id) {
        print(savedLd.id);
        lds[indexLd] = ld;
        await saveLd(lds);
        break;
      }
      indexLd += 1;
    }
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
  void backDialog() {
    if (keyboardUsed) {
      showDialog(
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
                uploadLd(editedLd);
                ldTersimpan();
              },
              child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(width: 1, color: Colors.grey),
                      color: Theme.of(context).primaryColor),
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
    } else {
      setState(() {
        globals.ayatDipilih.clear();
        globals.currentIndex = 1;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      title: "Lectio Divina",
                    )));
      });
    }
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: tanggalLd,
            firstDate: DateTime.utc(2020, 5, 15),
            lastDate: DateTime.utc(2030, 5, 15))
        .then((value) => setState(() {
              keyboardUsed = true;
              tanggalLd = value!;
              editLd.tanggal = DateTime.utc(
                  value.year,
                  value.month,
                  value.day,
                  DateTime.now().hour,
                  DateTime.now().minute,
                  DateTime.now().second);
            }));
  }

  final List<Color> _colors = [
    Color.fromRGBO(255, 0, 0, 1),
    Color.fromRGBO(255, 255, 0, 1),
    Color.fromRGBO(0, 255, 0, 1),
    Color.fromRGBO(0, 0, 255, 1),
    // Colors.orange,
    // Colors.purple,
  ];
  void colorPicker(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text('Pick Your Color'),
            content: TextButton(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlockPicker(
                      pickerColor: warna,
                      availableColors: _colors,
                      onColorChanged: (color) => setState(() {
                            warna = color;
                            editedLd.warna = color.toString();
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
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if (keyboardUsed) {
          backDialog();
        } else {
          globals.currentIndex = 1;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        title: "Lectio Divina",
                      )));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit LD",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
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
                          "   Tanggal : " + format.format(tanggalLd),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  focusNode: myFocusNodeJudul,
                  controller: judul,
                  onChanged: (value) {
                    setState(() {
                      if (myFocusNodeJudul.hasFocus) {
                        keyboardUsed = true;
                      } else {
                        keyboardUsed = false;
                      }
                      print(keyboardUsed);
                    });
                    judul.text = value;
                    editedLd.judul = value;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Judul atau Topik Bacaan',
                      hintText: 'Judul Bacaan'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    TextField(
                      focusNode: myFocusNodeJudul2,
                      controller: judul2,
                      onChanged: (value) {
                        setState(() {
                          if (myFocusNodeJudul2.hasFocus) {
                            keyboardUsed = true;
                          } else {
                            keyboardUsed = false;
                          }
                          print(keyboardUsed);
                        });
                        judul2.text = value;
                        editedLd.judul2 = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Topik',
                          hintText: 'Masukkan topik yang dibahas'),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: TextField(
                  focusNode: myFocusNodeAyat,
                  controller: ayat,
                  onChanged: (value) {
                    setState(() {
                      if (myFocusNodeAyat.hasFocus) {
                        keyboardUsed = true;
                      } else {
                        keyboardUsed = false;
                      }
                    });
                    ayat.text = value;
                    editedLd.ayat = value;
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
                      focusNode: myFocusNodeSabda,
                      controller: sabda,
                      onChanged: (value) {
                        setState(() {
                          if (myFocusNodeSabda.hasFocus) {
                            keyboardUsed = true;
                          } else {
                            keyboardUsed = false;
                          }
                        });
                        sabda.text = value;
                        editedLd.sabda = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Sabda Tuhan',
                          hintText: 'Masukkan isi sabda Tuhan'),
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
                      focusNode: myFocusNodeSabdaBagiSaya,
                      controller: sabdaBagiSaya,
                      onChanged: (value) {
                        setState(() {
                          if (myFocusNodeSabdaBagiSaya.hasFocus) {
                            keyboardUsed = true;
                          } else {
                            keyboardUsed = false;
                          }
                        });
                        sabdaBagiSaya.text = value;
                        editedLd.sabdaBagiSaya = value;
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
                      focusNode: myFocusNodeTanggapan,
                      controller: tanggapan,
                      onChanged: (value) {
                        setState(() {
                          if (myFocusNodeTanggapan.hasFocus) {
                            keyboardUsed = true;
                          } else {
                            keyboardUsed = false;
                          }
                        });
                        tanggapan.text = value;
                        editedLd.tanggapan = value;
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
                      focusNode: myFocusNodeTindakan,
                      controller: tindakan,
                      onChanged: (value) {
                        setState(() {
                          if (myFocusNodeTindakan.hasFocus) {
                            keyboardUsed = true;
                          } else {
                            keyboardUsed = false;
                          }
                        });
                        tindakan.text = value;
                        editedLd.tindakan = value;
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
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              keyboardUsed = true;
                              shareable ? shareable = false : shareable = true;
                              editedLd.shareable = shareable;
                            });
                          },
                          child: Icon(
                            shareable
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 24.0,
                          ),
                        ),
                        Text("Share Catatan"),
                      ],
                    ),
                    TextField(
                      focusNode: myFocusNodeCatatan,
                      controller: catatan,
                      onChanged: (value) {
                        setState(() {
                          if (myFocusNodeCatatan.hasFocus) {
                            keyboardUsed = true;
                          } else {
                            keyboardUsed = false;
                          }
                        });
                        catatan.text = value;
                        editedLd.catatan = value;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Catatan',
                          hintText:
                              'Masukkan catatan yang ingin anda sampaikan'),
                    ),
                    TextField(
                      focusNode: myFocusNodeHashtag,
                      controller: hashtag,
                      onChanged: (value) {
                        setState(() {
                          if (myFocusNodeHashtag.hasFocus) {
                            keyboardUsed = true;
                          } else {
                            keyboardUsed = false;
                          }
                        });
                        hashtag.text = value;
                        editedLd.hashtag = value;
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Hashtag',
                          hintText: 'Masukkan hashtag'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Warna Tagline"),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              keyboardUsed = true;
                            });
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
                                    shape: BoxShape.circle, color: warna),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sudah Selesai ? "),
                        Checkbox(
                          value: selesai,
                          onChanged: (bool? value) {
                            setState(() {
                              keyboardUsed = true;
                              selesai = value!;
                              editedLd.selesai = selesai;
                            });
                          },
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              simpanClicked == true;
                              uploadLd(editLd);
                              ldTersimpan();
                            },
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(
                                child: Text(
                                  'Simpan',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
