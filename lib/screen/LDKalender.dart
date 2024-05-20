import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:lectio_divina/globals.dart' as globals;
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
  DateTime today = DateTime.now();
  DateFormat format = new DateFormat("dd MMMM yyyy", "id_ID");

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: const Text(
                          "Mei 2024",
                          style: TextStyle(fontSize: 17),
                        ),
                        onTap: () {},
                      ),
                      GestureDetector(
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                          size: 24.0,
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                )
              : TableCalendar(
                  locale: 'id_ID',
                  headerVisible: true,
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  daysOfWeekVisible: false,
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        // borderRadius: BorderRadius.all(
                        //   Radius.circular(15.0),
                        // ),
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        // borderRadius: BorderRadius.all(
                        //   Radius.circular(15.0),
                        // ),
                      )),
                  focusedDay: today,
                  firstDay: DateTime.utc(2020, 5, 15),
                  lastDay: DateTime.utc(2030, 5, 15),
                  // onDaySelected: _onDaySelected,
                ),
          TextButton(
            onPressed: () {
              setState(() {
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
                      ),
                      Text("Tampilkan Kalender")
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_up,
                        size: 24.0,
                      ),
                      Text("Tampilkan Lebih Sedikit")
                    ],
                  ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              //ganti ke list view builder
              controller: ScrollController(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(format.format(today)),
                  ),
                  Card(
                    color: Colors.white,
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
                                height: 88,
                                width: 6.0,
                                color: Colors.blue,
                              )),
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Judul/Topik LD",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Kejadian 1:1"),
                                Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
