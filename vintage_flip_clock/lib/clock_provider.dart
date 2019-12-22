import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vintage_flip_clock/enums.dart';

class ClockProvider extends InheritedWidget {
  final ValueNotifier<DateTime> dateTimeNotifier;
  final ValueNotifier<bool> is24HourFormatNotifier;
  final ValueNotifier<HourMode> hourModeNotifier;
  final ValueNotifier<num> temperatureNotifier;
  final ValueNotifier<WeatherCondition> weatherConditionNotifier;

  ClockProvider({
    Key key,
    @required this.dateTimeNotifier,
    @required this.is24HourFormatNotifier,
    @required this.hourModeNotifier,
    @required this.temperatureNotifier,
    @required this.weatherConditionNotifier,
    @required Widget child,
  })  : assert(dateTimeNotifier != null),
        assert(is24HourFormatNotifier != null),
        assert(hourModeNotifier != null),
        assert(temperatureNotifier != null),
        assert(weatherConditionNotifier != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(ClockProvider oldWidget) {
    return dateTimeNotifier.value != oldWidget.dateTimeNotifier.value ||
        is24HourFormatNotifier.value !=
            oldWidget.is24HourFormatNotifier.value ||
        hourModeNotifier.value != oldWidget.hourModeNotifier.value ||
        temperatureNotifier.value != oldWidget.temperatureNotifier.value ||
        weatherConditionNotifier.value !=
            oldWidget.weatherConditionNotifier.value;
  }

  static ClockProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ClockProvider>();
  }
}
