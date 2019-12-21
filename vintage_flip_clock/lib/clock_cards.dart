import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'flip_card.dart';

enum Mode { hour, minute }

class ClockCards extends StatefulWidget {
  const ClockCards(this._dateTimeNotifier, this._is24HourFormat);

  final ValueNotifier<DateTime> _dateTimeNotifier;
  final bool _is24HourFormat;

  @override
  _ClockCardsState createState() => _ClockCardsState();
}

class _ClockCardsState extends State<ClockCards> {
  ValueNotifier<String> _hourNotifier;
  ValueNotifier<String> _minuteNotifier;

  @override
  void initState() {
    super.initState();
    _hourNotifier = ValueNotifier<String>(_getHours(widget._dateTimeNotifier.value));
    _minuteNotifier = ValueNotifier<String>(_getMinutes(widget._dateTimeNotifier.value));
    widget._dateTimeNotifier.addListener(_updateTime);
  }

  String _getHours(DateTime dateTime) {
    return DateFormat(widget._is24HourFormat ? 'HH' : 'hh').format(dateTime);
  }

  String _getMinutes(DateTime dateTime) {
    return DateFormat('mm').format(dateTime);
  }

  void _updateTime() {
    if (_hourNotifier.value != _getHours(widget._dateTimeNotifier.value)) {
      _updateHour();
    }
    if (_minuteNotifier.value != _getMinutes(widget._dateTimeNotifier.value)) {
      _updateMinute();
    }
  }

  void _updateHour() {
    _hourNotifier.value = _getHours(widget._dateTimeNotifier.value);
  }

  void _updateMinute() {
    _minuteNotifier.value = _getMinutes(widget._dateTimeNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.biggest.height * 0.9,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2.5,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                const BoxShadow(
                  color: Colors.black,
                  offset: const Offset(0.0, 0.0),
                ),
                const BoxShadow(
                  color: Color(0xFF202020),
                  offset: const Offset(0.0, 0.0),
                  spreadRadius: -2.5,
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 10,
                    child: FlipCard(_hourNotifier, Mode.hour),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 10,
                    child: FlipCard(_minuteNotifier, Mode.minute),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
