import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class WeatherSpinner extends StatefulWidget {
  const WeatherSpinner(this._weatherConditionNotifier);

  final ValueNotifier<WeatherCondition> _weatherConditionNotifier;

  @override
  _WeatherSpinnerState createState() => _WeatherSpinnerState();
}

class _WeatherSpinnerState extends State<WeatherSpinner> {
  ScrollController _scrollController;
  WeatherCondition _currentWeatherCondition;
  double _iconSize;

  @override
  void initState() {
    super.initState();
    _currentWeatherCondition = widget._weatherConditionNotifier.value;
    widget._weatherConditionNotifier.addListener(this._scrollToIcon);
    WidgetsBinding.instance.addPostFrameCallback((_) => {
          _scrollController = ScrollController(
              initialScrollOffset:
                  _getScrollOffsetOfWeatherCondition(_currentWeatherCondition))
        });
  }

  void _scrollToIcon() {
    final offset =
        this._calculateScrollOffset(widget._weatherConditionNotifier.value);
    _scrollController.animateTo(offset,
        duration: const Duration(seconds: 3), curve: Curves.easeInOut);

    _currentWeatherCondition = widget._weatherConditionNotifier.value;
  }

  double _calculateScrollOffset(WeatherCondition newWeatherCondition) {
    int currentIconIndex =
        this._getIndexOfWeatherCondition(_currentWeatherCondition);
    int newIconIndex = this._getIndexOfWeatherCondition(newWeatherCondition);
    int diffIndex = (currentIconIndex - newIconIndex).abs();

    if (currentIconIndex > newIconIndex) {
      return _scrollController.offset - diffIndex * _iconSize;
    } else {
      return _scrollController.offset + diffIndex * _iconSize;
    }
  }

  double _getScrollOffsetOfWeatherCondition(WeatherCondition weatherCondition) {
    final index = _getIndexOfWeatherCondition(weatherCondition);
    return (index - 1) * _iconSize;
  }

  final _icons = [
    Icons.toys,
    Icons.cloud_queue,
    Icons.dehaze,
    Icons.opacity,
    Icons.grain,
    Icons.wb_sunny,
    Icons.flash_on,
    Icons.toys,
    Icons.cloud_queue
  ];

  int _getIndexOfWeatherCondition(WeatherCondition weatherCondition) {
    switch (weatherCondition) {
      case WeatherCondition.cloudy:
        return 1;
      case WeatherCondition.foggy:
        return 2;
        break;
      case WeatherCondition.rainy:
        return 3;
        break;
      case WeatherCondition.snowy:
        return 4;
        break;
      case WeatherCondition.sunny:
        return 5;
        break;
      case WeatherCondition.thunderstorm:
        return 6;
        break;
      case WeatherCondition.windy:
        return 7;
        break;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.biggest.height * 0.4,
          child: AspectRatio(
            aspectRatio: 1 / 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
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
                    blurRadius: 2.5,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          )
                        ),
                        child: LayoutBuilder(
                          builder:
                              (BuildContext context, BoxConstraints constraints) {
                            _iconSize = constraints.biggest.height / 3.0;
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemCount: _icons.length,
                              itemExtent: _iconSize,
                              itemBuilder: (BuildContext context, int index) {
                                return buildIconContainer(_icons[index], _iconSize);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: CustomPaint(
                          size: Size.square(10.0),
                          painter: Triangle(Colors.red),
                        ),
                      ),
                    ),
                    buildOverlay(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildOverlay() {
    return Container(
    );
  }

  Widget buildIconContainer(IconData iconData, double size) {
    return Container(
      color: Colors.black,
      height: size,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                for (var j = 0; j < 5; j++)
                  LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints constrains) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: j == 2
                              ? constrains.biggest.width
                              : constrains.biggest.width * 0.5,
                          height: 1.0,
                          color: Colors.white,
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
                    color: Colors.white,
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