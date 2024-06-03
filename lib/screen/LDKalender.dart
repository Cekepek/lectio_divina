import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ld.dart';

import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/main.dart';
import 'package:lectio_divina/screen/detailLd.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  late final ValueNotifier<List<LD>> _selectedLD;
  List<LD> monthLd = [];

  void _onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      selectedDay = day;
      focusedDay = focusDay;
      _selectedLD.value = _getLDForDay(selectedDay);
      debugPrint(selectedDay.toString());
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
    // debugPrint(selectedDay.toString());
    debugPrint(globals.MyLd.isEmpty.toString());
    // !globals.MyLd.isEmpty
    //     ? debugPrint(globals.MyLd[1].tanggal)
    //     : debugPrint("");
    for (LD ld in globals.MyLd) {
      if (lds[DateTime.parse(ld.tanggal)] != null) {
        lds[DateTime.parse(ld.tanggal)]!.add(ld);
      } else {
        lds[DateTime.parse(ld.tanggal)!] = [ld];
      }
      // lds.addAll({
      //   DateTime.parse(ld.tanggal)!: [ld]
      // });
    }

    _selectedLD = ValueNotifier(_getLDForDay(selectedDay!));
    debugPrint(lds[selectedDay].toString());
    debugPrint(lds.isEmpty.toString());
  }

  List<LD> _getLDForDay(DateTime day) {
    return lds[_removeTime(day)] ?? [];
  }

  List<LD> _getLDForMonth(int year, int month) {
    return globals.MyLd.where((ld) =>
        DateTime.parse(ld.tanggal).year == year &&
        DateTime.parse(ld.tanggal).month == month).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            globals.currentIndex = 3;
            globals.tanggalTerpilih = _removeTime(selectedDay);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyHomePage(
                          title: "My LD",
                        )));
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
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child:
                                                  // Card(
                                                  //   surfaceTintColor:
                                                  //       Colors.transparent,
                                                  //   elevation: 5,
                                                  //   shape: RoundedRectangleBorder(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             15.0),
                                                  //   ),
                                                  //   child:
                                                  Container(
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
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: IntrinsicHeight(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0),
                                                            bottomLeft:
                                                                Radius.circular(
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
                                                              EdgeInsets.all(8),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                value[index]
                                                                    .judul,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(value[index]
                                                                  .ayat),
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top: 8,
                                                                        bottom:
                                                                            8),
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .person,
                                                                      size:
                                                                          24.0,
                                                                    ),
                                                                    Text(
                                                                        "Pribadi")
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child:
                                                              PopupMenuButton(
                                                                  icon: Icon(Icons
                                                                      .more_horiz),
                                                                  onSelected:
                                                                      (result) {
                                                                    if (result ==
                                                                        0) {
                                                                      setState(
                                                                          () {
                                                                        globals.currentIndex =
                                                                            4;
                                                                      });
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              MyHomePage(
                                                                            title:
                                                                                "My LD",
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return [
                                                                      PopupMenuItem(
                                                                          value:
                                                                              0,
                                                                          child:
                                                                              Text("Detail"))
                                                                    ];
                                                                  }),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // ),
                                            );
                                          });
                                    }),
                              ],
                            )
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              controller: ScrollController(),
                              itemCount: monthLd.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Card(
                                    // color: Colors.white,
                                    surfaceTintColor: Colors.transparent,
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Row(
                                        children: [
                                          Align(
                                              alignment: Alignment.centerLeft,
                                              child: Container(
                                                height: 100,
                                                width: 10.0,
                                                color: Color(int.parse(
                                                    monthLd[index]
                                                        .warna
                                                        .split('(0x')[1]
                                                        .split(')')[0],
                                                    radix: 16)),
                                              )),
                                          Expanded(
                                              child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  monthLd[index].judul,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(monthLd[index].ayat),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 8, bottom: 8),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.person,
                                                        size: 24.0,
                                                      ),
                                                      Text("Pribadi")
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
