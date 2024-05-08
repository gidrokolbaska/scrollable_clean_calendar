import 'package:flutter/material.dart';
import 'package:mc_scrollable_calendar/controllers/mc_calendar_controller.dart';
import 'package:mc_scrollable_calendar/utils/extensions.dart';

class WeekdaysWidget extends StatelessWidget {
  final bool showWeekdays;
  final MCCalendarController cleanCalendarController;
  final String locale;

  final Widget Function(BuildContext context, String weekday, int index)?
      weekdayBuilder;
  final double? aspectRatio;

  const WeekdaysWidget({
    Key? key,
    required this.showWeekdays,
    required this.cleanCalendarController,
    required this.locale,
    required this.weekdayBuilder,
    required this.aspectRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showWeekdays) return const SizedBox.shrink();

    return GridView.count(
      crossAxisCount: DateTime.daysPerWeek,
      shrinkWrap: true,
      childAspectRatio: aspectRatio ?? 1.2,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: List.generate(DateTime.daysPerWeek, (index) {
        final weekDay = cleanCalendarController.getDaysOfWeek(locale)[index];

        if (weekdayBuilder != null) {
          return weekdayBuilder!(context, weekDay, index);
        }

        return _beauty(context, weekDay, index);
      }),
    );
  }

  Widget _beauty(BuildContext context, String weekday, int index) {
    return Center(
      child: Text(
        weekday.capitalize(),
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color:
                  Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.4),
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
