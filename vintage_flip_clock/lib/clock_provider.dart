import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vintage_flip_clock/enums.dart';

class ClockProvider extends InheritedWidget {
  final ValueNotifier<bool> is24HourFormatNotifier;
  final ValueNotifier<HourMode> hourModeNotifier;
  final ValueNotifier<num> temperatureNotifier;
  final ValueNotifier<WeatherCondition> weatherConditionNotifier;
  final ValueNotifier<Weekday> weekdayNotifier;
  final ValueNotifier<String> hourNotifier;
  final ValueNotifier<String> minuteNotifier;

  ClockProvider({
    Key key,
    @required this.is24HourFormatNotifier,
    @required this.hourModeNotifier,
    @required this.temperatureNotifier,
    @required this.weatherConditionNotifier,
    @required this.weekdayNotifier,
    @required this.hourNotifier,
    @required this.minuteNotifier,
    @required Widget child,
  })  : assert(is24HourFormatNotifier != null),
        assert(hourModeNotifier != null),
        assert(temperatureNotifier != null),
        assert(weatherConditionNotifier != null),
        assert(weekdayNotifier != null),
        assert(hourNotifier != null),
        assert(minuteNotifier != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(ClockProvider oldWidget) {
    return is24HourFormatNotifier.value !=
            oldWidget.is24HourFormatNotifier.value ||
        hourModeNotifier.value != oldWidget.hourModeNotifier.value ||
        temperatureNotifier.value != oldWidget.temperatureNotifier.value ||
        weatherConditionNotifier.value !=
            oldWidget.weatherConditionNotifier.value ||
        weekdayNotifier.value != oldWidget.weekdayNotifier.value ||
        hourNotifier.value != oldWidget.hourNotifier.value ||
        minuteNotifier.value != oldWidget.minuteNotifier.value;
  }

  static ClockProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClockProvider>();
  }
}
