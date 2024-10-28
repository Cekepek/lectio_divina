import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ld.dart';
import 'package:lectio_divina/core.dart';
import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/screen/detailLd.dart';
import 'package:lectio_divina/screen/editLd.dart';
import 'package:lectio_divina/screen/tambahLd.dart';
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';

class LDKalender extends StatefulWidget {
  const LDKalender({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LDKalenderState();
  }
}

class _LDKalenderState extends State<LDKalender> {
  bool showLess = false;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  Map<DateTime, List<LD>> lds = {};
  DateFormat format = new DateFormat("dd MMMM yyyy", "id_ID");
  DateFormat formatMonth = new DateFormat("MMMM yyyy", "id_ID");
  DateFormat formatBagikan = new DateFormat("EEEE dd MMMM yyyy", "id_ID");
  late final ValueNotifier<List<LD>> _selectedLD;
  List<LD> monthLd = [];
  List<DateTime> listTanggalLd = [];
  String header = "";
  String ayat = "";
  String isiAyat = "";
  String isiSabda = "";
  String isiTanggapan = "";
  String isiTindakan = "";
  String isiCatatan = "";

  String potongKataTopik(String topik) {
    int startIndex = 0, indexOfSpace = 0;

    for (int i = 0; i < 5; i++) {
      indexOfSpace = topik.indexOf(' ', startIndex);
      if (indexOfSpace == -1) {
        //-1 is when character is not found
        return topik;
      }
      startIndex = indexOfSpace + 1;
    }

    return topik.substring(0, indexOfSpace) + '...';
  }

  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      selectedDay = day;
      focusedDay = focusDay;
      _selectedLD.value = _getLDForDay(selectedDay);
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      focusedDay = DateTime(
        focusedDay.year,
        focusedDay.month - 1,
        1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      focusedDay = DateTime(
        focusedDay.year,
        focusedDay.month + 1,
        1,
      );
    });
  }

  DateTime _removeTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDay = _removeTime(DateTime.now());
    focusedDay = selectedDay;
    for (LD ld in globals.MyLd) {
      if (lds[_removeTime(ld.tanggal)] != null) {
        lds[_removeTime(ld.tanggal)]!.add(ld);
      } else {
        lds[_removeTime(ld.tanggal)] = [ld];
      }
    }

    _selectedLD = ValueNotifier(_getLDForDay(selectedDay));
  }

  List<LD> _getLDForDay(DateTime day) {
    return lds[_removeTime(day)] ?? [];
  }

  List<LD> _getLDForMonth(int year, int month) {
    return globals.MyLd.where(
        (ld) => ld.tanggal.year == year && ld.tanggal.month == month).toList();
  }

  List<DateTime> getTanggalLd(List<LD> listLd) {
    List<DateTime> listTanggal = [];
    for (LD ld in listLd) {
      if (!listTanggal.contains(_removeTime(ld.tanggal))) {
        listTanggal.add(_removeTime(ld.tanggal));
      }
    }
    listTanggal.sort((a, b) => b.compareTo(a));
    return listTanggal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            globals.ayatDipilih.clear();
            globals.tanggalTerpilih = DateTime.utc(
                selectedDay.year,
                selectedDay.month,
                selectedDay.day,
                DateTime.now().hour,
                DateTime.now().minute,
                DateTime.now().second);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TambahLd()));
          });
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            showLess
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 24.0,
                          ),
                          onTap: () {
                            _goToPreviousMonth();
                            selectedDay = focusedDay;
                            monthLd = _getLDForMonth(
                                focusedDay.year, focusedDay.month);
                            listTanggalLd = getTanggalLd(monthLd);
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            formatMonth.format(focusedDay),
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        GestureDetector(
                          child: const Icon(
                            Icons.keyboard_arrow_right,
                            size: 24.0,
                          ),
                          onTap: () {
                            _goToNextMonth();
                            selectedDay = focusedDay;
                            monthLd = _getLDForMonth(
                                focusedDay.year, focusedDay.month);
                            listTanggalLd = getTanggalLd(monthLd);
                          },
                        ),
                      ],
                    ),
                  )
                : TableCalendar(
                    locale: 'id_ID',
                    headerVisible: true,
                    headerStyle: HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    daysOfWeekVisible: true,
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekendStyle: TextStyle(color: Colors.red)),
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5)),
                      selectedDecoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5)),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    focusedDay: focusedDay,
                    firstDay: DateTime.utc(2020, 5, 15),
                    lastDay: DateTime.utc(2030, 5, 15),
                    onDaySelected: _onDaySelected,
                    eventLoader: _getLDForDay,
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                    border:
                        BorderDirectional(top: BorderSide(color: Colors.grey))),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      focusedDay = selectedDay;
                      monthLd =
                          _getLDForMonth(focusedDay.year, focusedDay.month);
                      listTanggalLd = getTanggalLd(monthLd);
                      showLess ? showLess = false : showLess = true;
                    });
                  },
                  child: showLess
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 24.0,
                              color: Colors.grey,
                            ),
                            Text(
                              "Tampilkan Kalender",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.keyboard_arrow_up,
                              size: 24.0,
                              color: Colors.grey,
                            ),
                            Text(
                              "Tampilkan Lebih Sedikit",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                        child: !showLess
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(format.format(selectedDay)),
                                  ),
                                  ValueListenableBuilder<List<LD>>(
                                      valueListenable: _selectedLD,
                                      builder: (context, value, _) {
                                        return ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            controller: ScrollController(),
                                            itemCount: value.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    globals.idLdDetail =
                                                        value[index].id;
                                                    globals.idLdEdit =
                                                        value[index].id;
                                                  });
                                                  value[index].selesai
                                                      ? Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    DetailLd(),
                                                          ))
                                                      : Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    EditLd(),
                                                          ));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 4.0,
                                                          spreadRadius: 2.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: IntrinsicHeight(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        8.0),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        8.0),
                                                              ),
                                                              child: Container(
                                                                width: 10.0,
                                                                color: Color(int.parse(
                                                                    value[index]
                                                                        .warna
                                                                        .split('(0x')[
                                                                            1]
                                                                        .split(
                                                                            ')')[0],
                                                                    radix: 16)),
                                                              ),
                                                            ),
                                                            Expanded(
                                                                child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    value[index].judul !=
                                                                            ""
                                                                        ? value[index]
                                                                            .judul
                                                                        : potongKataTopik(
                                                                            value[index].judul2),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    value[index]
                                                                        .ayat,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            10),
                                                                child: Column(
                                                                  children: [
                                                                    PopupMenuButton(
                                                                        icon: Icon(Icons
                                                                            .more_horiz),
                                                                        onSelected:
                                                                            (result) {
                                                                          if (result ==
                                                                              0) {
                                                                            setState(() {
                                                                              globals.idLdDetail = value[index].id;
                                                                            });
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => DetailLd()),
                                                                            );
                                                                          }
                                                                          if (result ==
                                                                              1) {
                                                                            setState(() {
                                                                              globals.idLdEdit = value[index].id;
                                                                            });
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => EditLd()),
                                                                            );
                                                                          }
                                                                          if (result ==
                                                                              2) {
                                                                            setState(() {
                                                                              header = globals.header ? "*" + value[index].judul + "*" : value[index].judul;
                                                                              ayat = globals.ayatBacaan ? "*" + value[index].ayat + "*" : value[index].ayat;
                                                                              isiAyat = globals.isiAyat ? "*" + value[index].sabda + "*" : value[index].sabda;
                                                                              isiSabda = globals.isiSabda ? "*" + value[index].sabdaBagiSaya + "*" : value[index].sabdaBagiSaya;
                                                                              isiTanggapan = globals.isiTanggapan ? "*" + value[index].tanggapan + "*" : value[index].tanggapan;
                                                                              isiTindakan = globals.isiTindakan ? "*" + value[index].tindakan + "*" : value[index].tindakan;
                                                                              isiCatatan = value[index].shareable ? "\n\n*Catatan :*\n" + value[index].catatan : "";
                                                                            });
                                                                            Share.share(header +
                                                                                "\n\n" +
                                                                                "*" +
                                                                                formatBagikan.format(value[index].tanggal) +
                                                                                "*\n\n" +
                                                                                "*Ayat yang berkesan,*\n" +
                                                                                ayat +
                                                                                "\n\n" +
                                                                                isiAyat +
                                                                                "\n\n*Sabda Tuhan Bagi Saya,*\n" +
                                                                                isiSabda +
                                                                                "\n\n*Tanggapan Saya,*\n" +
                                                                                isiTanggapan +
                                                                                "\n\n*Tindakan Nyata,*\n" +
                                                                                isiTindakan +
                                                                                isiCatatan);
                                                                          }
                                                                        },
                                                                        itemBuilder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return [
                                                                            PopupMenuItem(
                                                                              value: 0,
                                                                              child: Text("Detail"),
                                                                            ),
                                                                            PopupMenuItem(
                                                                              value: 1,
                                                                              child: Text("Edit"),
                                                                            ),
                                                                            PopupMenuItem(
                                                                              value: 2,
                                                                              child: Text("Bagikan"),
                                                                            )
                                                                          ];
                                                                        }),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            10.0,
                                                                        height:
                                                                            10.0,
                                                                        decoration: BoxDecoration(
                                                                            shape: BoxShape
                                                                                .circle,
                                                                            color: value[index].selesai
                                                                                ? Colors.green
                                                                                : Colors.red),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // ),
                                                ),
                                              );
                                            });
                                      }),
                                ],
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                controller: ScrollController(),
                                itemCount: listTanggalLd.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(format.format(listTanggalLd[index])),
                                      ListViewLdBulanan(
                                          ldHariIni: _getLDForDay(
                                              listTanggalLd[index])),
                                    ],
                                  );
                                })),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewLdBulanan extends StatefulWidget {
  final List<LD> ldHariIni;

  const ListViewLdBulanan({required this.ldHariIni});

  @override
  State<StatefulWidget> createState() {
    return _ListViewLdBulananState();
  }
}

class _ListViewLdBulananState extends State<ListViewLdBulanan> {
  late List<LD> ldHariIni;
  DateFormat formatBagikan = new DateFormat("EEEE dd MMMM yyyy", "id_ID");
  String header = "";
  String ayat = "";
  String isiAyat = "";
  String isiSabda = "";
  String isiTanggapan = "";
  String isiTindakan = "";
  String isiCatatan = "";

  String potongKataTopik(String topik) {
    int startIndex = 0, indexOfSpace = 0;

    for (int i = 0; i < 5; i++) {
      indexOfSpace = topik.indexOf(' ', startIndex);
      if (indexOfSpace == -1) {
        //-1 is when character is not found
        return topik;
      }
      startIndex = indexOfSpace + 1;
    }

    return topik.substring(0, indexOfSpace) + '...';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ldHariIni = widget.ldHariIni;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: ScrollController(),
        itemCount: ldHariIni.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                globals.idLdDetail = ldHariIni[index].id;
                globals.idLdEdit = ldHariIni[index].id;
              });
              ldHariIni[index].selesai
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailLd(),
                      ))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditLd(),
                      ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                          child: Container(
                            width: 10.0,
                            color: Color(int.parse(
                                ldHariIni[index]
                                    .warna
                                    .split('(0x')[1]
                                    .split(')')[0],
                                radix: 16)),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ldHariIni[index].judul != ""
                                    ? ldHariIni[index].judul
                                    : potongKataTopik(ldHariIni[index].judul2),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ldHariIni[index].ayat,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                PopupMenuButton(
                                    icon: Icon(Icons.more_horiz),
                                    onSelected: (result) {
                                      if (result == 0) {
                                        setState(() {
                                          globals.idLdDetail =
                                              ldHariIni[index].id;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailLd()),
                                        );
                                      }
                                      if (result == 1) {
                                        setState(() {
                                          globals.idLdEdit =
                                              ldHariIni[index].id;
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EditLd()),
                                        );
                                      }
                                      if (result == 2) {
                                        setState(() {
                                          header = globals.header
                                              ? "*" +
                                                  ldHariIni[index].judul +
                                                  "*"
                                              : ldHariIni[index].judul;
                                          ayat = globals.ayatBacaan
                                              ? "*" +
                                                  ldHariIni[index].ayat +
                                                  "*"
                                              : ldHariIni[index].ayat;
                                          isiAyat = globals.isiAyat
                                              ? "*" +
                                                  ldHariIni[index].sabda +
                                                  "*"
                                              : ldHariIni[index].sabda;
                                          isiSabda = globals.isiSabda
                                              ? "*" +
                                                  ldHariIni[index]
                                                      .sabdaBagiSaya +
                                                  "*"
                                              : ldHariIni[index].sabdaBagiSaya;
                                          isiTanggapan = globals.isiTanggapan
                                              ? "*" +
                                                  ldHariIni[index].tanggapan +
                                                  "*"
                                              : ldHariIni[index].tanggapan;
                                          isiTindakan = globals.isiTindakan
                                              ? "*" +
                                                  ldHariIni[index].tindakan +
                                                  "*"
                                              : ldHariIni[index].tindakan;
                                          isiCatatan =
                                              ldHariIni[index].shareable
                                                  ? "\n\n*Catatan :*\n" +
                                                      ldHariIni[index].catatan
                                                  : "";
                                        });
                                        Share.share(header +
                                            "\n\n" +
                                            "*" +
                                            formatBagikan.format(
                                                ldHariIni[index].tanggal) +
                                            "*\n\n" +
                                            "*Ayat,*\n" +
                                            ayat +
                                            "\n\n" +
                                            isiAyat +
                                            "\n\n*Sabda Tuhan Bagi Saya,*\n" +
                                            isiSabda +
                                            "\n\n*Tanggapan,*\n" +
                                            isiTanggapan +
                                            "\n\n*Tindakan,*\n" +
                                            isiTindakan +
                                            isiCatatan);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return [
                                        PopupMenuItem(
                                          value: 0,
                                          child: Text("Detail"),
                                        ),
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text("Edit"),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Text("Bagikan"),
                                        )
                                      ];
                                    }),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 10.0,
                                    height: 10.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ldHariIni[index].selesai
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
