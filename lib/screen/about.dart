import 'package:flutter/cupertino.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AboutState();
  }
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              "Apa itu Lectio Divina ?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Lectio Divina berarti bacaan Ilahi atau bacaan rohani (dari Kitab Suci). Lectio Divina bisa diartika sebagai cara berdoa dengan membaca dan merenungkan Kitab Suci untuk mencapai persatuan dengan Allah Tritunggal Mahakudus. Bukan hanya membaca Kitab Suci saja, tetapi memakai ayat-ayat dalam Kitab Suci untuk mendengarkan suara TUhan. Lectio Divina pertama kali dipraktekkan oleh Origenes pada abad ke-3 dan oleh biarawan kemudian mulai dipopulerkan kembali pada abad 16 oleh Yohanes dari Salib. Pada abad 19 ketika berkembang metode kritik historis, metode lectio divina tidak dipedulikan lagi. Bahkan LEctio Divina lebih populer diluar kalangan biarawan pada saat itu. Hingga pada akhirnya pada tahun 1965, Paus Paulus VI menegaskan agar Lectio Divina dipraktekkan di dalam Gereja khususnya di dalam biara-biara. Dan pada HUT ke-40 konstitusi Dei Verbum tahun 2005, Paus Benediktus XVI menegaskan kembali pentingnya mempraktekkan lectio divina ini, untuk dijalankan pada abad 21 ini.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
            Text(
              "Tentang Aplikasi",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Lectio Divina cocok diterapkan oleh orang awam atau pemula hingga orang yang sudah terbiasa membaca kitab suci. Aplikasi ini ditujukan kepada seluruh umat Katolik bahkan orang awam agar dapat membuat Lectio Divina dimana saja atau kapan saja. Lectio Divina yang dibuat bisa memiliki wahyu pribadi yang dapat dibagikan ke komunitas masing-masing atau disimpan sendiri. Kumpulan Lectio Divina yang telah dibuat dapat dilihat kembali dan dapat dibagikan secara terus menerus. Aplikasi ini juga menyediakan panduan dalam pembuatan Lectio Divina sehingga memudahkan pemula dalam membuat LD.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
            Text(
              "Lectio Divina (Ver 1.0.0)",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "By Cross Network",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
