import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailLd extends StatefulWidget {
  const DetailLd({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DetailLdState();
  }
}

class _DetailLdState extends State<DetailLd> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Container(
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            bottom: BorderSide(color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/User.jpg'),
                              // minRadius: 50,
                              radius: 30,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.25,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Christopher Kelvin",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Ditulis Pada tanggal 3 Juni 2024",
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Judul LD",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Kejadian 1:1"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sabda Tuhan Bagi Saya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi ullam-corper velit nisi, et eleifend nisi pulvinar vitae. Phasellus cursus rhon-cus est ac hendrerit. Proin vulputate gravida metus, eget condimen-tum neque suscipit ut. Nam est tellus, congue eucongue non, posuerevitae leo. Quisque elementum, turpis vitae tempus bibendum, justo felis tincidunt felis, nec egestas ex erat et neque."),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggapan Saya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "In ornare ultrices diam, ac aliquet eros. Aliquam erat volutpat. Duis a tellus purus. In finibus ac erat sit amet malesuada. Sed commodo nisl non elit finibus consectetur. Etiam aliquet blandit justo sed commodo."),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tindakan Saya",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "Duis hendrerit turpis nec tortor pretium elementum. Sed bibendum semper purus et dignissim. Duis placerat, mi in dictum dapibus, risus magna pellentesque metus, ac facilisis sem augue eget purus. Aliquam ut nisi et mauris commodo venenatis vitae et elit."),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Catatan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "Donec ligula enim, gravida in ante quis, consequat molestie nunc. Praesent vel sapien ac orci venenatis rhoncus. Donec eget fermentum arcu. Integer a sapien condimentum, facilisis enim vitae, feugiat nisi."),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hashtag",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              "Donec ligula enim, gravida in ante quis, consequat molestie nunc."),
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
