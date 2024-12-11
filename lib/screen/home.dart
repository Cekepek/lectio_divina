import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/pasal.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lectio_divina/globals.dart' as globals;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (globals.kitab.isEmpty) {
      readJson();
      FlutterNativeSplash.remove();
    }
  }

  Future<void> readJson() async {
    int idAyat = 0;
    int kitab = 0;
    int index_kitab = -1;
    int pasal = 0;
    int index_pasal = -1;
    int ayat = -1;
    String title = "";
    final String response =
        await rootBundle.loadString('assets/json/Alkitab.json');
    final data = await json.decode(response);
    setState(() {
      for (var i in data) {
        if (i["bookID"] != kitab) {
          kitab = i["bookID"];
          index_kitab += 1;
          pasal = 0;
          index_pasal = -1;
          Kitab temp_kitab = new Kitab(
              id: index_kitab,
              singkatan: i["abbreviation"],
              nama: i["book"],
              pasal: []);
          globals.kitab.add(temp_kitab);
        }
        if (i["chapter"] != pasal) {
          pasal = i["chapter"];
          index_pasal += 1;
          Pasal temp_pasal = new Pasal(
              id: index_pasal,
              nomor: pasal.toString(),
              id_kitab: index_kitab,
              ayat: []);
          globals.kitab[index_kitab].pasal.add(temp_pasal);
        }

        if (i["verse"] != ayat) {
          ayat = i["verse"];
          // COBA SETIAP AYAT NYIMPEN JUDUL
          if (i["type"] == "t") {
            title = i["content"];
          }
          idAyat += 1;
          Ayat temp_ayat = new Ayat(
              id: idAyat,
              nomor: i["verse"].toString(),
              nomorPasal: pasal.toString(),
              tipe: i["type"],
              text: i["content"],
              kitab: globals.kitab[index_kitab].singkatan,
              title: title,
              titleIncluded: title);
          globals.kitab[index_kitab].pasal[index_pasal].ayat.add(temp_ayat);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(
              width: MediaQuery.of(context).size.width / 2,
              image: AssetImage('assets/images/new_logo.png'),
              fit: BoxFit.fill),
          globals.sinkronasiSelesai?Container():CircularProgressIndicator(),
          Text(
            globals.sinkronasiSelesai?"Selamat Datang di Aplikasi Lectio Divina":"Sedang Memuat Data",
            style: TextStyle(
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
