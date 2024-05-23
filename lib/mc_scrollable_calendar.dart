library mc_scrollable_calendar;

import 'package:flutter/material.dart';
import 'package:mc_scrollable_calendar/controllers/mc_calendar_controller.dart';
import 'package:mc_scrollable_calendar/models/day_values_model.dart';
import 'package:mc_scrollable_calendar/utils/extensions.dart';
import 'package:mc_scrollable_calendar/widgets/days_widget.dart';
import 'package:mc_scrollable_calendar/widgets/month_widget.dart';
import 'package:mc_scrollable_calendar/widgets/weekdays_widget.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'sliding_sheet/src/sheet.dart';
import 'sliding_sheet/src/specs.dart';

Future<T?> showMCCleanCalendar<T>(
  BuildContext context, {
  required MCCalendarController calendarController,
  double? horizontalPadding,
  double spaceBetweenCalendars = 10,
  double spaceBetweenMonthAndCalendar = 5,
  Color workingDaysColor = Colors.black,
  Color weekendDaysColor = Colors.purple,
  Color currentDayColor = const Color(0xffDFE1E7),
  Color daySelectedBackgroundColor = const Color(0xff32E17D),
  Color monthContainerBackgroundColor = const Color(0xffEEF0F3),
  TextStyle monthTextStyle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
  ),
  TextStyle dayTextStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  ),
  required TextStyle Function(
          Color workingDaysColor, Color weekendDaysColor, int index)
      headerStyle,
  double topCornerRadius = 16,
  List<double> snappings = const [0.7, 1.0],
  required Widget bottomWidget,
}) {
  return showSlidingBottomSheet(
    context,
    useRootNavigator: true,
    builder: (context) {
      return SlidingSheetDialog(
        elevation: 0,
        cornerRadius: topCornerRadius,
        isDismissable: false,
        avoidStatusBar: true,
        duration: const Duration(milliseconds: 300),
        color: Colors.transparent,
        backdropColor: Colors.black38,
        headerBuilder: (context, state) {
          return Material(
            child: GridView.count(
              crossAxisCount: DateTime.daysPerWeek,
              shrinkWrap: true,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal:
                    horizontalPadding != null ? (horizontalPadding + 6) : 6,
              ),
              children: List.generate(DateTime.daysPerWeek, (index) {
                final weekDay = calendarController.getDaysOfWeek('ru')[index];

                return Center(
                  child: Text(
                    index == 6 ? 'Вск' : weekDay.capitalize(),
                    style: headerStyle.call(
                      workingDaysColor,
                      weekendDaysColor,
                      index,
                    ),
                  ),
                );
              }),
            ),
          );
        },
        snapSpec: SnapSpec(
          snap: true,
          snappings: snappings,
          positioning: SnapPositioning.relativeToAvailableSpace,
        ),
        customBuilder: (context, controller, state) {
          return Material(
            child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: [
                MCScrollableCalendar(
                  locale: 'ru',
                  showWeekdays: true,
                  scrollController: controller,
                  calendarController: calendarController,
                  calendarCrossAxisSpacing: 0,
                  spaceBetweenCalendars: spaceBetweenCalendars,
                  spaceBetweenMonthAndCalendar: spaceBetweenMonthAndCalendar,
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding ?? 0,
                    vertical: 16.0,
                  ),
                  workingDaysColor: workingDaysColor,
                  weekendDaysColor: weekendDaysColor,
                  monthContainerBackgroundColor: monthContainerBackgroundColor,
                  monthTextStyle: monthTextStyle,
                  dayTextStyle: dayTextStyle,
                  currentDayColor: currentDayColor,
                  daySelectedBackgroundColor: daySelectedBackgroundColor,
                ),
                Positioned(
                  bottom: 32,
                  width: MediaQuery.sizeOf(context).width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: bottomWidget,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class MCScrollableCalendar extends StatefulWidget {
  /// The language locale
  final String locale;

  /// Scroll controller
  final ScrollController? scrollController;

  /// If is to show or not the weekdays in calendar
  final bool showWeekdays;

  /// The space between month and calendar
  final double spaceBetweenMonthAndCalendar;

  /// The space between calendars
  final double spaceBetweenCalendars;

  /// The horizontal space in the calendar dates
  final double calendarCrossAxisSpacing;

  /// The vertical space in the calendar dates
  final double calendarMainAxisSpacing;

  /// The parent padding
  final EdgeInsets? padding;

  /// The label text style of month
  final TextStyle? monthTextStyle;

  /// The label text align of month
  final TextAlign? monthTextAlign;

  /// The aspect ratio of weekday items
  final double? weekdayAspectRatio;

  /// The label text style of day
  final TextStyle? dayTextStyle;

  /// The aspect ratio of day items
  final double? dayAspectRatio;

  /// The day selected background color
  final Color? daySelectedBackgroundColor;

  ///Цвет рабочего дня
  final Color workingDaysColor;

  ///Цвет выходного дня
  final Color weekendDaysColor;

  /// The day selected background color that is between day selected edges
  final Color? daySelectedBackgroundColorBetween;

  /// The day disable background color
  final Color? dayDisableBackgroundColor;

  /// The day disable color
  final Color? dayDisableColor;

  /// The radius of day items
  final double dayRadius;

  /// A builder to make a customized month
  final Widget Function(BuildContext context, String month)? monthBuilder;

  /// A builder to make a customized weekday
  final Widget Function(BuildContext context, String weekday, int index)?
      weekdayBuilder;
  final Color monthContainerBackgroundColor;
  final Color currentDayColor;

  /// A builder to make a customized day of calendar
  final Widget Function(BuildContext context, DayValues values)? dayBuilder;

  /// The controller of ScrollableCleanCalendar
  final MCCalendarController calendarController;

  const MCScrollableCalendar({
    this.locale = 'en',
    this.scrollController,
    this.showWeekdays = true,
    this.calendarCrossAxisSpacing = 4,
    this.calendarMainAxisSpacing = 4,
    this.spaceBetweenCalendars = 24,
    this.spaceBetweenMonthAndCalendar = 24,
    this.padding,
    this.monthBuilder,
    this.weekdayBuilder,
    this.dayBuilder,
    this.monthTextAlign,
    this.monthTextStyle,
    this.weekdayAspectRatio,
    this.daySelectedBackgroundColor,
    this.workingDaysColor = Colors.black,
    this.weekendDaysColor = Colors.purple,
    this.monthContainerBackgroundColor = const Color(0xffEEF0F3),
    this.currentDayColor = const Color(0xffDFE1E7),
    this.daySelectedBackgroundColorBetween,
    this.dayDisableBackgroundColor,
    this.dayDisableColor,
    this.dayTextStyle,
    this.dayAspectRatio,
    this.dayRadius = 6,
    required this.calendarController,
  });

  @override
  State<MCScrollableCalendar> createState() => _MCScrollableCalendarState();
}

class _MCScrollableCalendarState extends State<MCScrollableCalendar> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final focusDate = widget.calendarController.initialFocusDate;
      if (focusDate != null && widget.scrollController == null) {
        widget.calendarController.jumpToMonth(date: focusDate);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollController != null) {
      return listViewCalendar(
        widget.monthContainerBackgroundColor,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: widget.padding != null
                ? EdgeInsets.symmetric(
                    horizontal: widget.padding!.horizontal / 2 + 6)
                : const EdgeInsets.symmetric(horizontal: 16.0),
            child: WeekdaysWidget(
              showWeekdays: widget.showWeekdays,
              cleanCalendarController: widget.calendarController,
              locale: widget.locale,
              weekdayBuilder: widget.weekdayBuilder,
              aspectRatio: widget.weekdayAspectRatio,
            ),
          ),
          Expanded(
              child: scrollablePositionedListCalendar(
            widget.monthContainerBackgroundColor,
          )),
        ],
      );
    }
  }

  Widget listViewCalendar(Color monthContainerBackgroundColor) {
    return ListView.separated(
      controller: widget.scrollController,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      separatorBuilder: (_, __) =>
          SizedBox(height: widget.spaceBetweenCalendars),
      itemCount: widget.calendarController.months.length,
      itemBuilder: (context, index) {
        final month = widget.calendarController.months[index];

        return childCollumn(month, monthContainerBackgroundColor);
      },
    );
  }

  Widget scrollablePositionedListCalendar(Color monthContainerBackgroundColor) {
    return ScrollablePositionedList.separated(
      itemScrollController: widget.calendarController.itemScrollController,
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      separatorBuilder: (_, __) =>
          SizedBox(height: widget.spaceBetweenCalendars),
      itemCount: widget.calendarController.months.length,
      itemBuilder: (context, index) {
        final month = widget.calendarController.months[index];

        return childCollumn(
          month,
          monthContainerBackgroundColor,
        );
      },
    );
  }

  Widget childCollumn(DateTime month, Color monthContainerBackgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          16,
        ),
        color: monthContainerBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: MonthWidget(
              month: month,
              locale: widget.locale,
              monthBuilder: widget.monthBuilder,
              textAlign: widget.monthTextAlign,
              textStyle: widget.monthTextStyle,
            ),
          ),
          SizedBox(height: widget.spaceBetweenMonthAndCalendar),
          AnimatedBuilder(
            animation: widget.calendarController,
            builder: (_, __) {
              return DaysWidget(
                month: month,
                cleanCalendarController: widget.calendarController,
                calendarCrossAxisSpacing: widget.calendarCrossAxisSpacing,
                calendarMainAxisSpacing: widget.calendarMainAxisSpacing,
                dayBuilder: widget.dayBuilder,
                workingDaysColor: widget.workingDaysColor,
                weekendDaysColor: widget.weekendDaysColor,
                monthContainerBackgroundColor:
                    widget.monthContainerBackgroundColor,
                currentDayColor: widget.currentDayColor,
                selectedBackgroundColor: widget.daySelectedBackgroundColor,
                selectedBackgroundColorBetween:
                    widget.daySelectedBackgroundColorBetween,
                disableBackgroundColor: widget.dayDisableBackgroundColor,
                dayDisableColor: widget.dayDisableColor,
                radius: widget.dayRadius,
                textStyle: widget.dayTextStyle,
                aspectRatio: widget.dayAspectRatio,
              );
            },
          )
        ],
      ),
    );
  }
}
