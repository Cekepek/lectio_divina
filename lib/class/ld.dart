import 'dart:convert';

class LD {
  int id;
  DateTime tanggal;
  String judul = "";
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

  LD(
      {required this.id,
      required this.tanggal,
      required this.judul,
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
      required this.user_id});

  factory LD.fromJson(Map<String, dynamic> jsonData) {
    return LD(
        id: jsonData['id'],
        tanggal: DateTime.parse(jsonData['tanggal']),
        judul: jsonData['judul'],
        ayat: jsonData['ayat'],
        sabda: jsonData['sabda'],
        sabdaBagiSaya: jsonData['sabdaBagiSaya'],
        tanggapan: jsonData['tanggapan'],
        tindakan: jsonData['tindakan'],
        catatan: jsonData['catatan'],
        hashtag: jsonData['hashtag'],
        warna: jsonData['warna'],
        shareable: jsonData['shareable'],
        selesai: jsonData['selesai'],
        user_id: jsonData['user_id']);
  }

  static Map<String, dynamic> toMap(LD ld) => {
        'id': ld.id,
        'tanggal': ld.tanggal.toString(),
        'judul': ld.judul,
        'ayat': ld.ayat,
        'sabda': ld.sabda,
        'sabdaBagiSaya': ld.sabdaBagiSaya,
        'tanggapan': ld.tanggapan,
        'tindakan': ld.tindakan,
        'catatan': ld.catatan,
        'hashtag': ld.hashtag,
        'warna': ld.warna,
        'shareable': ld.shareable,
        'selesai': ld.selesai,
        'user_id': ld.user_id
      };

  static String encode(List<LD> lds) => json.encode(
        lds.map<Map<String, dynamic>>((ld) => LD.toMap(ld)).toList(),
      );

  static List<LD> decode(String lds) => (json.decode(lds) as List<dynamic>)
      .map<LD>((item) => LD.fromJson(item))
      .toList();
}

class ResponseRequest {
  int status = 0;
  String message = "";
  dynamic data = [];
}
