import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vintage_flip_clock/am_pm_widget.dart';
import 'package:vintage_flip_clock/clock_cards.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/day_spinner.dart';
import 'package:vintage_flip_clock/enums.dart';
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
  ValueNotifier<num> _temperatureNotifier;
  ValueNotifier<DateTime> _dateTimeNotifier;
  ValueNotifier<WeatherCondition> _weatherConditionNotifier;
  ValueNotifier<bool> _is24HourFormatNotifier;
  ValueNotifier<HourMode> _hourModeNotifier;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    _temperatureNotifier = ValueNotifier<num>(widget.model.temperature);
//    _dateTimeNotifier = ValueNotifier<DateTime>(DateTime.now());
    _dateTimeNotifier =
        ValueNotifier<DateTime>(DateTime.parse("1969-07-20 23:57:00Z"));
    _weatherConditionNotifier =
        ValueNotifier<WeatherCondition>(widget.model.weatherCondition);
    _is24HourFormatNotifier = ValueNotifier<bool>(widget.model.is24HourFormat);
    _hourModeNotifier = ValueNotifier<HourMode>(_getHourMode());

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
    _temperatureNotifier.value = widget.model.temperature;
    _weatherConditionNotifier.value = widget.model.weatherCondition;
    _is24HourFormatNotifier.value = widget.model.is24HourFormat;
    _hourModeNotifier.value = _getHourMode();
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

    if (!_is24HourFormatNotifier.value) {
      _hourModeNotifier.value = _getHourMode();
    }
  }

  HourMode _getHourMode() {
    return (_dateTimeNotifier.value.hour > 12) ? HourMode.PM : HourMode.AM;
  }

  @override
  Widget build(BuildContext context) {
    return ClockProvider(
      dateTimeNotifier: _dateTimeNotifier,
      is24HourFormatNotifier: _is24HourFormatNotifier,
      hourModeNotifier: _hourModeNotifier,
      temperatureNotifier: _temperatureNotifier,
      weatherConditionNotifier: _weatherConditionNotifier,
      child: Container(
        color: Color(0xEE000000),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: _buildTextModelAndLocation(),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildModuleBorder(
                                child: DaySpinner(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: ValueListenableBuilder(
                                valueListenable: _is24HourFormatNotifier,
                                builder: (BuildContext context,
                                    bool is24HourFormat, Widget child) {
                                  return is24HourFormat
                                      ? Container()
                                      : LayoutBuilder(
                                          builder: (BuildContext context,
                                              BoxConstraints constraints) {
                                            return Container(
                                              width: constraints.biggest.width *
                                                  (2 / 3),
                                              child: AspectRatio(
                                                aspectRatio: 1 / 1,
                                                child: _buildModuleBorder(
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            BoxConstraints
                                                                constraints) {
                                                      return AmPmWidget(
                                                          constraints
                                                              .biggest.width);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Expanded(
                    flex: 24,
                    child: _buildModuleBorder(
                      child: ClockCards(),
                      innerColor: Colors.transparent,
                      innerPadding: const EdgeInsets.all(0.0),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildModuleBorder(
                      innerColor: Colors.transparent,
                      innerPadding: const EdgeInsets.all(0.0),
                      child: WeatherSpinner(),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 5,
              child: _buildModuleBorder(
                innerPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: TempScale(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextModelAndLocation() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            'DASHTIME',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Made in\n${widget.model.location}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModuleBorder(
      {@required Widget child,
      Color innerColor = Colors.black,
      EdgeInsetsGeometry innerPadding = const EdgeInsets.all(6.0)}) {
    return Container(
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
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: innerColor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: innerPadding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
