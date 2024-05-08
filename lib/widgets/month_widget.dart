import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mc_scrollable_calendar/utils/extensions.dart';

class MonthWidget extends StatelessWidget {
  final DateTime month;
  final String locale;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Widget Function(BuildContext context, String month)? monthBuilder;

  const MonthWidget({
    Key? key,
    required this.month,
    required this.locale,
    required this.monthBuilder,
    required this.textStyle,
    required this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text =
        '${DateFormat('MMMM', locale).format(DateTime(month.year, month.month)).capitalize()} ${DateFormat('yyyy', locale).format(DateTime(month.year, month.month))}';

    if (monthBuilder != null) {
      return monthBuilder!(context, text);
    }

    return _beauty(context, text);
  }

  Widget _beauty(BuildContext context, String text) {
    return Text(
      text.capitalize(),
      textAlign: textAlign ?? TextAlign.center,
      style: textStyle ?? Theme.of(context).textTheme.titleLarge!,
    );
  }
}
