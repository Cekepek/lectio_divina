import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/pasal.dart';

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
    }
  }

  Future<void> readJson() async {
    String kitab = "0";
    int index_kitab = -1;
    String pasal = "0";
    int index_pasal = -1;
    String ayat = "0";
    String title = "";
    final String response = await rootBundle.loadString('assets/json/ayt.json');
    final data = await json.decode(response);
    setState(() {
      for (var i in data) {
        if (i["book"] != kitab) {
          kitab = i["book"];
          index_kitab += 1;
          pasal = "0";
          index_pasal = -1;
          Kitab temp_kitab = new Kitab(
              id: index_kitab, singkatan: i["abbr"], nama: "", pasal: []);
          globals.kitab.add(temp_kitab);
        }
        if (i["chapter"] != pasal) {
          pasal = i["chapter"];
          index_pasal += 1;
          Pasal temp_pasal = new Pasal(
              id: index_pasal, nomor: pasal, id_kitab: index_kitab, ayat: []);
          globals.kitab[index_kitab].pasal.add(temp_pasal);
        }

        if (i["verse"] != ayat) {
          ayat = i["verse"];
          // COBA SETIAP AYAT NYIMPEN JUDUL
          if (i["title"] != "") {
            title = i["title"];
          }
          Ayat temp_ayat = new Ayat(
              nomor: i["verse"],
              nomorPasal: pasal,
              text: i["text"],
              kitab: globals.kitab[index_kitab].singkatan,
              title: i["title"],
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
              image: AssetImage('assets/images/Logo.png'),
              fit: BoxFit.fill),
          Text(
            "Selamat Datang di Aplikasi Lectio Divina",
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
