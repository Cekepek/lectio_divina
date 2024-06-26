import 'package:flutter/material.dart';

class DetailBacaan extends StatefulWidget {
  const DetailBacaan({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailBacaan();
  }
}

class _DetailBacaan extends State<DetailBacaan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Bacaan"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
