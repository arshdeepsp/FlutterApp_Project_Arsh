import 'package:flutter/material.dart';
import 'package:tripd_travel_app/theme/resources/colors.dart';

Future<DateTimeRange?> showCustomDateRange(
    {required BuildContext context,
    required DateTimeRange? initialDateRange,
    required DateTimeRange? dateRange}) {
  return showDateRangePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year),
    lastDate: DateTime(DateTime.now().year + 2),
    initialDateRange: dateRange ?? initialDateRange,
    builder: (context, child) {
      return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: color1,
              onPrimary: Colors.white,
              surface: color1,
            ),
          ),
          child: child!);
    },
  );
}
