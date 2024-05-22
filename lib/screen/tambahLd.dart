import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TambahLd extends StatefulWidget {
  const TambahLd({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TambahLdState();
  }
}

class _TambahLdState extends State<TambahLd> {
  Color? _selectedColor;

  // Daftar warna yang akan ditampilkan dalam dropdown
  final List<Color> _colors = [
    Color.fromRGBO(255, 0, 0, 1),
    Color.fromRGBO(255, 255, 0, 1),
    Color.fromRGBO(0, 255, 0, 1),
    Color.fromRGBO(0, 0, 255, 1),
    // Colors.orange,
    // Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Judul atau Topik Bacaan',
                  hintText: 'Judul Bacaan'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
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
                      DropdownButton<Color>(
                        hint: Text('Select a color'),
                        value: _selectedColor,
                        items: _colors.map((Color color) {
                          return DropdownMenuItem<Color>(
                            value: color,
                            child: Center(
                              child: Container(
                                width: 24,
                                height: 24,
                                color: color,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (Color? newValue) {
                          setState(() {
                            _selectedColor = newValue;
                          });
                        },
                      ),
                    ],
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
    );
  }
}
