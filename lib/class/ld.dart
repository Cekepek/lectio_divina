import 'dart:convert';

class LD {
  int id;
  String tanggal;
  String judul = "";
  String ayat = "";
  String sabda = "";
  String tanggapan = "";
  String tindakan = "";
  String catatan = "";
  String hashtag = "";
  String warna = "";
  bool selesai = false;

  LD({
    required this.id,
    required this.tanggal,
    required this.judul,
    required this.ayat,
    required this.sabda,
    required this.tanggapan,
    required this.tindakan,
    required this.catatan,
    required this.hashtag,
    required this.warna,
    required this.selesai,
  });

  factory LD.fromJson(Map<String, dynamic> jsonData) {
    return LD(
        id: jsonData['id'],
        tanggal: jsonData['tanggal'],
        judul: jsonData['judul'],
        ayat: jsonData['ayat'],
        sabda: jsonData['sabda'],
        tanggapan: jsonData['tanggapan'],
        tindakan: jsonData['tindakan'],
        catatan: jsonData['catatan'],
        hashtag: jsonData['hashtag'],
        warna: jsonData['warna'],
        selesai: jsonData['selesai']);
  }

  static Map<String, dynamic> toMap(LD ld) => {
        'id': ld.id,
        'tanggal': ld.tanggal,
        'judul': ld.judul,
        'ayat': ld.ayat,
        'sabda': ld.sabda,
        'tanggapan': ld.tanggapan,
        'tindakan': ld.tindakan,
        'catatan': ld.catatan,
        'hashtag': ld.hashtag,
        'warna': ld.warna,
        'selesai': ld.selesai
      };

  static String encode(List<LD> lds) => json.encode(
        lds.map<Map<String, dynamic>>((ld) => LD.toMap(ld)).toList(),
      );

  static List<LD> decode(String lds) => (json.decode(lds) as List<dynamic>)
      .map<LD>((item) => LD.fromJson(item))
      .toList();
}
