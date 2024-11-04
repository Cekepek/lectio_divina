import 'dart:convert';
import 'dart:ui';
import 'package:lectio_divina/globals.dart' as globals;

class LD {
  int id;
  DateTime tanggal;
  String judul = "";
  String judul2 = "";
  String ayat = "";
  String sabda = "";
  String sabdaBagiSaya = "";
  String tanggapan = "";
  String tindakan = "";
  String catatan = "";
  String hashtag = "";
  String warna = "";
  bool shareable = false;
  bool selesai = false;
  int user_id = 0;
  bool statusUpload = false;

  LD(
      {required this.id,
      required this.tanggal,
      required this.judul,
      required this.judul2,
      required this.ayat,
      required this.sabda,
      required this.sabdaBagiSaya,
      required this.tanggapan,
      required this.tindakan,
      required this.catatan,
      required this.hashtag,
      required this.warna,
      required this.shareable,
      required this.selesai,
      required this.user_id,
      required this.statusUpload});

  factory LD.fromJson(Map<String, dynamic> jsonData) {
    return LD(
        id: jsonData['id'],
        tanggal: DateTime.parse(jsonData['tanggal']),
        judul: jsonData['judul1'],
        judul2: jsonData['judul2'],
        ayat: jsonData['ayat'],
        sabda: jsonData['isi_ayat'],
        sabdaBagiSaya: jsonData['sabda_tuhan'],
        tanggapan: jsonData['tanggapan'],
        tindakan: jsonData['tindakan'],
        catatan: jsonData['catatan'],
        hashtag: jsonData['hashtag'],
        warna: jsonData['warna_tagline'],
        shareable: jsonData['shareable'] == 1 ? true : false,
        selesai: jsonData['status'] == 1 ? true : false,
        user_id: jsonData['id_user'],
        statusUpload: jsonData['status_upload'] == 1 ? true : false);
  }

  static Map<String, dynamic> toMap(LD ld) => {
        'version': '1.0.0',
        'id': ld.id,
        'tanggal': ld.tanggal.toString(),
        'judul1': ld.judul,
        'judul2': ld.judul2,
        'ayat': ld.ayat,
        'isi_ayat': ld.sabda,
        'sabda_tuhan': ld.sabdaBagiSaya,
        'tanggapan': ld.tanggapan,
        'tindakan': ld.tindakan,
        'catatan': ld.catatan,
        'hashtag': ld.hashtag,
        'warna_tagline': ld.warna,
        'shareable': ld.shareable ? 1 : 0,
        'status': ld.selesai ? 1 : 0,
        'id_user': ld.user_id,
        'status_upload': ld.statusUpload ? 1 : 0,
      };

  static String encode(List<LD> lds) => json.encode(
        lds.map<Map<String, dynamic>>((ld) => LD.toMap(ld)).toList(),
      );

  static List<LD> decode(String lds) => (json.decode(lds) as List<dynamic>)
      .map<LD>((item) => LD.fromJson(item))
      .toList();

  factory LD.fromJsonImportVersiLama(Map<String, dynamic> jsonData) {
    return LD(
        id: -1,
        tanggal: DateTime.parse(jsonData['Tanggal']),
        judul: jsonData['Judul'],
        judul2: '',
        ayat: jsonData['Bacaan'],
        sabda: jsonData['Ayat'],
        sabdaBagiSaya: jsonData['Sabda'],
        tanggapan: jsonData['Tanggapan'],
        tindakan: jsonData['Tindakan'],
        catatan: jsonData['Catatan'],
        hashtag: jsonData['Tagline'],
        warna: "Color(" + jsonData['Color'] + ")",
        shareable: false,
        selesai: false,
        user_id: globals.userLogin.id,
        statusUpload: false);
  }
  factory LD.fromJsonImport(Map<String, dynamic> jsonData) {
    if (jsonData.containsKey('version')) {
      return LD.fromJson(jsonData);
    } else {
      return LD.fromJsonImportVersiLama(jsonData);
    }
  }
  static List<LD> decodeImport(String lds) =>
      (json.decode(lds) as List<dynamic>)
          .map<LD>((item) => LD.fromJsonImport(item))
          .toList();
}
