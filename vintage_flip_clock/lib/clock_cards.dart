import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/flip_card.dart';

class ClockCards extends StatefulWidget {
  @override
  _ClockCardsState createState() => _ClockCardsState();
}

class _ClockCardsState extends State<ClockCards> {
  ValueNotifier<DateTime> _dateTimeNotifier;
  ValueNotifier<String> _hourNotifier;
  ValueNotifier<String> _minuteNotifier;
  ValueNotifier<bool> _is24HourFormatNotifier;

  @override
  void initState() {
    super.initState();
    _dateTimeNotifier = (context
            .getElementForInheritedWidgetOfExactType<ClockProvider>()
            ?.widget as ClockProvider)
        .dateTimeNotifier;
    _dateTimeNotifier.addListener(_updateTime);

    _is24HourFormatNotifier = (context
            .getElementForInheritedWidgetOfExactType<ClockProvider>()
            ?.widget as ClockProvider)
        .is24HourFormatNotifier;

    _hourNotifier = ValueNotifier<String>(_getHours());
    _minuteNotifier = ValueNotifier<String>(_getMinutes());
  }

  String _getHours() {
    return DateFormat('HH').format(_dateTimeNotifier.value);
  }

  String _getMinutes() {
    return DateFormat('mm').format(_dateTimeNotifier.value);
  }

  void _updateTime() {
    if (_hourNotifier.value != _getHours()) {
      _hourNotifier.value = _getHours();
    }
    if (_minuteNotifier.value != _getMinutes()) {
      _minuteNotifier.value = _getMinutes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Spacer(),
        Expanded(
          flex: 20,
          child: ValueListenableBuilder(
            valueListenable: _is24HourFormatNotifier,
            builder: (BuildContext context, bool is24HourFormat, Widget child) {
              return FlipCard(_hourNotifier, is24HourFormat ? 24 : 12);
            },
          ),
        ),
        Spacer(),
        Expanded(
          flex: 20,
          child: FlipCard(_minuteNotifier, 60),
        ),
        Spacer(),
      ],
    );
  }
}
