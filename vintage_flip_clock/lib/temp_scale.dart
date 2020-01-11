import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/clock_provider.dart';

class TempScale extends StatelessWidget {
  final double _min = -35.0;
  final double _max = 55;

  final List<String> _celsiusTemps = <String>[
    '-30',
    '-20',
    '-10',
    '0',
    '10',
    '20',
    '30',
    '40',
    '50'
  ];
  final List<String> _fahrenheitTemps = <String>[
    '-22',
    '-4',
    '14',
    '32',
    '50',
    '68',
    '86',
    '104',
    '122'
  ];

  double _getCelsiusPercentage(num value) {
    if (value <= _min) return 0.0;
    if (value >= _max) return 1.0;
    return (value - _min) / (_max - _min);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    '°C',
                    style: ClockTheme.of(context).textTheme.headline,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Text(
                    '°F',
                    style: ClockTheme.of(context).textTheme.headline,
                  ),
                ),
              ),
              Spacer(
                flex: 2,
              )
            ],
          ),
        ),
        Expanded(
          flex: 30,
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (var i = 0; i < _celsiusTemps.length; i++)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                this._celsiusTemps[i],
                                style: ClockTheme.of(context).textTheme.subhead,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                this._fahrenheitTemps[i],
                                style: ClockTheme.of(context).textTheme.subhead,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  for (var j = 0; j < 5; j++)
                                    LayoutBuilder(
                                      builder: (BuildContext context,
                                          BoxConstraints constrains) {
                                        return Container(
                                          height: j == 2
                                              ? constrains.biggest.height
                                              : constrains.biggest.height * 0.4,
                                          width: 1.0,
                                          color: ClockTheme.of(context)
                                              .accentColor,
                                        );
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return ValueListenableBuilder(
                      valueListenable:
                          ClockProvider.of(context).temperatureNotifier,
                      builder: (BuildContext context, num value, Widget child) {
                        return AnimatedPadding(
                          padding: EdgeInsets.only(
                            left: constraints.biggest.width *
                                this._getCelsiusPercentage(value),
                          ),
                          duration: const Duration(seconds: 3),
                          curve: Curves.easeInOut,
                          child: child,
                        );
                      },
                      child: _buildSlider(context),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Container(
          width: 4.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(2.5),
              topRight: Radius.circular(2.5),
            ),
            color: ClockTheme.of(context).cursorColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 2.0,
                offset: Offset(3.0, 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
