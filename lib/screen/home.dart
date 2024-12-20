import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ayat.dart';
import 'package:lectio_divina/class/kitab.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/class/pasal.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lectio_divina/model/api.dart' as api;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  Future<void> loadLd() async {
    int id = globals.userLogin.id;
    print("ID USER : " + globals.userLogin.id.toString());

    final prefs = await SharedPreferences.getInstance();
    final String ldsstring =
        await prefs.getString('lds_data_${globals.userLogin.id}') ?? "";
    final body = jsonEncode({"id_user": id});
    print(body);
    final response =
        await api.connectApi('/sinkronasi?id_user=$id', 'post', null);
    if (response.status == 200) {
      print("MASUK");
      print(response.data);
      if (response.message == 'berhasil') {
        if (ldsstring != "") {
          final List<LD> ldList = LD.decode(ldsstring);
          ldList.sort((a, b) => a.tanggal.compareTo(b.tanggal));
          Map<String, dynamic> tanggalSinkron = {
            "tanggalAkhirDb": DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(DateTime.parse(response.data[0]["first_date"])),
            "tanggalAkhirApp":
                DateFormat("yyyy-MM-dd HH:mm:ss").format(ldList.last.tanggal),
          };
          print("CEK TANGGAL APP: " + ldList.last.tanggal.toString());
          if (DateTime.parse(tanggalSinkron["tanggalAkhirDb"])
              .isBefore(DateTime.parse(tanggalSinkron["tanggalAkhirApp"]))) {
            for (LD ld in ldList) {
              print("BANDINGKAN TANGGAL : " +
                  ld.tanggal.toString() +
                  ":" +
                  tanggalSinkron["tanggalAkhirDb"]);
              if (DateTime.parse(
                      DateFormat("yyyy-MM-dd HH:mm:ss").format(ld.tanggal))
                  .isAfter(DateTime.parse(tanggalSinkron["tanggalAkhirDb"]))) {
                final body = jsonEncode({
                  'id': 0,
                  'tanggal':
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(ld.tanggal),
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
                  'id_user': globals.userLogin.id,
                  'statusUpload': ld.statusUpload ? 1 : 0,
                });
                final response2 =
                    await api.connectApi("/lectio_divina", "post", body);
                if (response2.status == 200) {
                  print("KEUPLOAD ");

                  print(response2.data['id']);
                  ld.id = response2.data['id'];
                  setState(() {
                    globals.sinkronasiSelesai = true;
                  });
                } else {
                  throw Exception('Failed to read API');
                }
              }
            }
          } else if (DateTime.parse(tanggalSinkron["tanggalAkhirDb"])
              .isAfter(DateTime.parse(tanggalSinkron["tanggalAkhirApp"]))) {
            String tanggalAwal = tanggalSinkron["tanggalAkhirDb"];
            String tanggalAkhir = tanggalSinkron["tanggalAkhirApp"];
            final response2 = await api.connectApi(
                '/lectio_divina/$tanggalAkhir/$tanggalAwal/$id', 'get', null);
            print('CEK API : /lectio_divina/$tanggalAkhir/$tanggalAwal/$id');
            final List<LD> listDb = LD.decode(jsonEncode(response2.data));
            ldList.addAll(listDb);
            if (response2.status == 200) {
              if (response2.data != null) {
                final prefs = await SharedPreferences.getInstance();
                final String encodedData = LD.encode(ldList);
                await prefs.setString(
                    'lds_data_${globals.userLogin.id}', encodedData);

                setState(() {
                  globals.MyLd = ldList;
                });
              }

              setState(() {
                globals.sinkronasiSelesai = true;
              });
            } else {
              throw Exception('Failed to read API');
            }
          }
        } else {
          //Error KALAU APP DAN DB TIDAK ADA ISI
          String tanggalAwal = DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.parse(response.data[0]["first_date"]));
          String tanggalAkhir = DateFormat("yyyy-MM-dd HH:mm:ss")
              .format(DateTime.parse(response.data[0]["last_date"]));

          print("CEK API : '/lectio_divina/$tanggalAkhir/$tanggalAwal/$id'");
          final response3 = await api.connectApi(
              '/lectio_divina/$tanggalAkhir/$tanggalAwal/$id', 'get', null);

          response3.data == null ? print("IYA NULL") : print("GAK NULL");
          if (response3.status == 200) {
            if (response3.data != null) {
              final List<LD> lds = LD.decode(jsonEncode(response3.data));
              final prefs = await SharedPreferences.getInstance();
              final String encodedData = LD.encode(lds);
              await prefs.setString(
                  'lds_data_${globals.userLogin.id}', encodedData);
              setState(() {
                globals.MyLd = lds;
              });
            }
            setState(() {
              globals.sinkronasiSelesai = true;
            });
          } else {
            throw Exception('Failed to read API');
          }
        }
      } else {
        throw Exception('Failed to read API');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (globals.kitab.isEmpty) {
      readJson();
      FlutterNativeSplash.remove();
    }
    globals.sinkronasiSelesai = false;
    loadLd();
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
          globals.sinkronasiSelesai ? Container() : CircularProgressIndicator(),
          Text(
            globals.sinkronasiSelesai
                ? "Selamat Datang di Aplikasi Lectio Divina"
                : "Sedang Memuat Data",
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
