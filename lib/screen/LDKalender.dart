import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lectio_divina/class/ld.dart';

import 'package:lectio_divina/globals.dart' as globals;
import 'package:lectio_divina/main.dart';
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
  late final ValueNotifier<List<LD>> _selectedLD;

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
      focusedDay = focusedDay;
      _selectedLD.value = _getLDForDay(selectedDay);
      debugPrint(selectedDay.toString());
    });
  }

  DateTime _removeTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  Future<void> loadLd() async {
    final prefs = await SharedPreferences.getInstance();
    final String ldsstring = await prefs.getString('lds_key') ?? "";
    if (ldsstring != "") {
      final List<LD> ldList = LD.decode(ldsstring);
      globals.MyLd = ldList;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDay = _removeTime(DateTime.now());
    loadLd();
    // debugPrint(selectedDay.toString());
    debugPrint(globals.MyLd.isEmpty.toString());
    !globals.MyLd.isEmpty
        ? debugPrint(globals.MyLd[1].tanggal)
        : debugPrint("");
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
    debugPrint(lds[selectedDay].toString());
    debugPrint(lds.isEmpty.toString());
    _selectedLD = ValueNotifier(_getLDForDay(selectedDay!));
  }

  List<LD> _getLDForDay(DateTime day) {
    return lds[day] ?? [];
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
                          title: "Lectio Divina",
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
                    selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5)),
                      selectedDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
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
            Expanded(
              child: Padding(
                  padding: EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Container(
                      child: ValueListenableBuilder<List<LD>>(
                          valueListenable: _selectedLD,
                          builder: (context, value, _) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                controller: ScrollController(),
                                itemCount: value.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Text(format.format(
                                              DateTime.parse(
                                                  value[index].tanggal))),
                                        ),
                                        Card(
                                          color: Colors.white,
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            child: Row(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Container(
                                                      height: 88,
                                                      width: 6.0,
                                                      color: Color(int.parse(
                                                          value[index]
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        value[index].judul,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(value[index].ayat),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8,
                                                                bottom: 8),
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
                                  );
                                });
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
