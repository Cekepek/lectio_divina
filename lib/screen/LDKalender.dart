import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
        // crossAxisAlignment: CrossAxisAlignment.center,
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
          )
        ],
      ),
    );
  }
}
