import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mc_scrollable_calendar/controllers/mc_calendar_controller.dart';
import 'package:mc_scrollable_calendar/mc_scrollable_calendar.dart';

void main() {
  initializeDateFormatting();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? selectedDate;
  late final MCCalendarController calendarController;
  @override
  void initState() {
    calendarController = MCCalendarController(
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 90)),
      onDayTapped: (date) {
        selectedDate = date;
      },
      // readOnly: true,
      weekdayStart: DateTime.monday,
      initialFocusDate: DateTime.now(),
      initialDateSelected: DateTime.now(),
      // endDateSelected: DateTime(2022, 3, 20),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrollable Clean Calendar'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       calendarController.clearSelectedDates();
        //     },
        //     icon: const Icon(Icons.clear),
        //   )
        // ],
      ),
      body: TestButton(
          calendarController: calendarController, selectedDate: selectedDate),
    );
  }
}

class TestButton extends StatelessWidget {
  const TestButton({
    Key? key,
    required this.calendarController,
    required this.selectedDate,
  }) : super(key: key);

  final MCCalendarController calendarController;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          color: Colors.red,
        ),
        ElevatedButton(
          onPressed: () async {
            await MCScrollableCalendar.showMCCleanCalendar(
              context,
              horizontalPadding: 11.5,
              calendarController: calendarController,
              headerStyle:
                  (Color workingDaysColor, Color weekendDaysColor, int index) {
                return TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: index <= 4 ? workingDaysColor : weekendDaysColor,
                );
              },
              bottomWidget: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Выбрать дату')),
            );
            if (selectedDate == null) {
              print('initial date: ${calendarController.initialDateSelected}');
            } else {
              print('hello:$selectedDate');
            }
          },
          child: Text('Открыть календарь'),
        ),
      ],
    );
  }
}
