import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vintage_flip_clock/clock_cards.dart';
import 'package:vintage_flip_clock/temp_scale.dart';
import 'package:vintage_flip_clock/weather_spinner.dart';

enum _Element {
  background,
}

final _Theme = {
  _Element.background: Color(0xFF202020),
};

class VintageFlipClock extends StatefulWidget {
  const VintageFlipClock(this.model);

  final ClockModel model;

  @override
  _VintageFlipClockState createState() => _VintageFlipClockState();
}

class _VintageFlipClockState extends State<VintageFlipClock> {
  ValueNotifier<num> _tempNotifier = ValueNotifier<num>(0);
  ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  ValueNotifier<WeatherCondition> _weatherConditionNotifier =
      ValueNotifier<WeatherCondition>(WeatherCondition.sunny);
  Timer _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(VintageFlipClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    _tempNotifier.value = widget.model.temperature;
    _weatherConditionNotifier.value = widget.model.weatherCondition;
  }

  void _updateTime() {
//    _dateTimeNotifier.value = DateTime.now();
//    _timer = Timer(
//      Duration(minutes: 1) -
//          Duration(seconds: _dateTimeNotifier.value.second) -
//          Duration(milliseconds: _dateTimeNotifier.value.millisecond),
//      _updateTime,
//    );
    // Debug timer
    _dateTimeNotifier.value = _dateTimeNotifier.value.add(
      Duration(minutes: 1),
    );
    _timer = Timer(
      Duration(seconds: 3),
      _updateTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xEE000000),
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: ClockCards(
                        _dateTimeNotifier, widget.model.is24HourFormat),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: WeatherSpinner(_weatherConditionNotifier),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: TempScale(_tempNotifier),
          ),
        ],
      ),
    );
  }
}
