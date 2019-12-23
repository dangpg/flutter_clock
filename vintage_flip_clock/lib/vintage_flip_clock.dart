import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/am_pm_widget.dart';
import 'package:vintage_flip_clock/clock_cards.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/weekday_spinner.dart';
import 'package:vintage_flip_clock/enums.dart';
import 'package:vintage_flip_clock/temp_scale.dart';
import 'package:vintage_flip_clock/weather_spinner.dart';

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
  ValueNotifier<Weekday> _weekdayNotifier;
  ValueNotifier<String> _hourNotifier;
  ValueNotifier<String> _minuteNotifier;
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
        ValueNotifier<DateTime>(DateTime.parse("2019-12-22 23:55:00Z"));
    _weatherConditionNotifier =
        ValueNotifier<WeatherCondition>(widget.model.weatherCondition);
    _is24HourFormatNotifier = ValueNotifier<bool>(widget.model.is24HourFormat);

    _hourModeNotifier = ValueNotifier<HourMode>(_getHourMode());
    _weekdayNotifier = ValueNotifier<Weekday>(_getWeekDay());
    _hourNotifier = ValueNotifier<String>(_getHours());
    _minuteNotifier = ValueNotifier<String>(_getMinutes());

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
    _weekdayNotifier.value = _getWeekDay();
    _hourNotifier.value = _getHours();
    _minuteNotifier.value = _getMinutes();
  }

  HourMode _getHourMode() {
    return (_dateTimeNotifier.value.hour > 12) ? HourMode.PM : HourMode.AM;
  }

  Weekday _getWeekDay() {
    return Weekday.values[_dateTimeNotifier.value.weekday - 1];
  }

  String _getHours() {
    return DateFormat('HH').format(_dateTimeNotifier.value);
  }

  String _getMinutes() {
    return DateFormat('mm').format(_dateTimeNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return ClockProvider(
      is24HourFormatNotifier: _is24HourFormatNotifier,
      hourModeNotifier: _hourModeNotifier,
      temperatureNotifier: _temperatureNotifier,
      weatherConditionNotifier: _weatherConditionNotifier,
      weekdayNotifier: _weekdayNotifier,
      hourNotifier: _hourNotifier,
      minuteNotifier: _minuteNotifier,
      child: Container(
        color: ClockTheme.of(context).backgroundColor,
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
                            flex: 5,
                            child: _buildTextModelAndLocation(context),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 5,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildModuleBorder(
                                context: context,
                                child: LayoutBuilder(
                                  builder: (BuildContext context,
                                      BoxConstraints constraints) {
                                    return WeekdaySpinner(
                                      itemSize: constraints.biggest.height,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Expanded(
                            flex: 5,
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
                                                  context: context,
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (BuildContext context,
                                                            BoxConstraints
                                                                constraints) {
                                                      return AmPmWidget(
                                                        iconSize: constraints
                                                            .biggest.width,
                                                      );
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
                      context: context,
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
                      context: context,
                      innerColor: Colors.transparent,
                      innerPadding: const EdgeInsets.all(0.0),
                      child: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          return WeatherSpinner(
                            height: constraints.biggest.height,
                            numVisibleIcons: 7,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 5,
              child: _buildModuleBorder(
                context: context,
                innerPadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
                child: TempScale(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextModelAndLocation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: <Widget>[
          Text(
            'DASHTIME',
            style: ClockTheme.of(context).textTheme.title,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Made in\n${widget.model.location}',
                textAlign: TextAlign.center,
                style: ClockTheme.of(context).textTheme.subtitle,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildModuleBorder(
      {@required BuildContext context,
      @required Widget child,
      Color innerColor,
      EdgeInsetsGeometry innerPadding = const EdgeInsets.all(6.0)}) {
    if (innerColor == null) {
      innerColor = ClockTheme.of(context).cardColor;
    }
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: ClockTheme.of(context).dividerColor,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: ClockTheme.of(context).canvasColor,
              offset: const Offset(0.0, 0.0),
            ),
            BoxShadow(
              color: ClockTheme.of(context).highlightColor,
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
