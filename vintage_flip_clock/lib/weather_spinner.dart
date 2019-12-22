import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/clock_provider.dart';

class WeatherSpinner extends StatefulWidget {
  const WeatherSpinner(this.spinnerHeight);

  final double spinnerHeight;

  @override
  _WeatherSpinnerState createState() => _WeatherSpinnerState();
}

class _WeatherSpinnerState extends State<WeatherSpinner> {
  ValueNotifier<WeatherCondition> _weatherConditionNotifier;
  ScrollController _scrollController;
  WeatherCondition _currentWeatherCondition;
  double _iconSize;
  final _numVisibleIcons = 7;

  @override
  void initState() {
    super.initState();
    _weatherConditionNotifier = (context
            .getElementForInheritedWidgetOfExactType<ClockProvider>()
            ?.widget as ClockProvider)
        .weatherConditionNotifier;
    _weatherConditionNotifier.addListener(_scrollToIcon);

    _iconSize = widget.spinnerHeight / _numVisibleIcons;

    _currentWeatherCondition = _weatherConditionNotifier.value;
    _scrollController = ScrollController(
        initialScrollOffset:
            _getScrollOffsetOfWeatherCondition(_currentWeatherCondition));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIcon() {
    if (_scrollController.hasClients) {
      final offset = _calculateScrollOffset();
      _scrollController.animateTo(offset,
          duration: const Duration(seconds: 3), curve: Curves.easeInOutBack);
      _currentWeatherCondition = _weatherConditionNotifier.value;
    }
  }

  double _calculateScrollOffset() {
    final currentIconIndex =
        this._getIndexOfWeatherCondition(_currentWeatherCondition);
    final newIconIndex =
        this._getIndexOfWeatherCondition(_weatherConditionNotifier.value);
    final diffIndex = (currentIconIndex - newIconIndex).abs();

    if (currentIconIndex > newIconIndex) {
      return _scrollController.offset - diffIndex * _iconSize;
    } else {
      return _scrollController.offset + diffIndex * _iconSize;
    }
  }

  double _getScrollOffsetOfWeatherCondition(WeatherCondition weatherCondition) {
    final index = _getIndexOfWeatherCondition(weatherCondition);
    return (index - (_numVisibleIcons - 1) / 2) * _iconSize;
  }

  final _icons = [
    Icons.brightness_4,
    Icons.pool,
    Icons.looks,
    Icons.brightness_6,
    Icons.cloud_queue, // cloudy
    Icons.grain,
    Icons.dehaze, // foggy
    Icons.opacity, // rainy
    Icons.bubble_chart,
    Icons.ac_unit, // snowy
    Icons.whatshot,
    Icons.wb_sunny, // sunny
    Icons.cloud_off,
    Icons.flash_on, // thunderstorm
    Icons.toys, // windy
    Icons.brightness_3,
    Icons.scatter_plot,
    Icons.beach_access,
    Icons.wb_cloudy
  ];

  int _getIndexOfWeatherCondition(WeatherCondition weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        return 4;
      case WeatherCondition.foggy:
        return 6;
        break;
      case WeatherCondition.rainy:
        return 7;
        break;
      case WeatherCondition.snowy:
        return 9;
        break;
      case WeatherCondition.sunny:
        return 11;
        break;
      case WeatherCondition.thunderstorm:
        return 13;
        break;
      case WeatherCondition.windy:
        return 14;
        break;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: ClockTheme.of(context).cardColor,
              ),
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: _icons.length,
              itemExtent: _iconSize,
              itemBuilder: (BuildContext context, int index) {
                return buildIconContainer(context, _icons[index], _iconSize);
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: CustomPaint(
              size: Size.square(10.0),
              painter: Triangle(ClockTheme.of(context).cursorColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIconContainer(BuildContext context, IconData iconData, double size) {
    return Container(
      color: ClockTheme.of(context).cardColor,
      height: size,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                for (var j = 0; j < 5; j++)
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constrains) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: j == 2
                              ? constrains.biggest.width
                              : constrains.biggest.width * 0.5,
                          height: 1.0,
                          color: ClockTheme.of(context).accentColor,
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Align(
                  alignment: Alignment.center,
                  child: Icon(
                    iconData,
                    color: ClockTheme.of(context).accentColor,
                    size: min(constraints.biggest.height,
                            constraints.biggest.width) *
                        0.75,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Triangle extends CustomPainter {
  Paint _paint;

  Triangle(Color color) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0.0, 0.0);
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height / 2.0);
    path.close();
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
