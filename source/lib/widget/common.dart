import 'package:flutter/material.dart';

class DateTimePicker {
  final BuildContext context;

  const DateTimePicker({this.context});

  Future<DateTime> pick() async {
    final DateTime date = await this._pickDate();
    final TimeOfDay time = await this._pickTime();

    if (date != null && time != null) {
      return date.toUtc().add(Duration(hours: time.hour, minutes: time.minute));
    }

    return null;
  }

  Future<DateTime> _pickDate() {
    return showDatePicker(
      context: this.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2008, 7, 3),
      lastDate: DateTime(99999, 12, 31),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
  }

  Future<TimeOfDay> _pickTime() {
    return showTimePicker(
        context: this.context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child,
          );
        });
  }
}
