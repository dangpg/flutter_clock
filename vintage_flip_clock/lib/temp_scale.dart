import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/clock_provider.dart';

class TempScale extends StatefulWidget {
  @override
  _TempScaleState createState() => _TempScaleState();
}

class _TempScaleState extends State<TempScale> {
  final List<String> celsiusTemps = <String>[
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
  final List<String> fahrenheitTemps = <String>[
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

  double getCelsiusPercentage(num value) {
    const double min = -35.0;
    const double max = 55;

    if (value <= min) return 0.0;
    if (value >= max) return 1.0;

    return (value - min) / (max - min);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Spacer(),
        Column(
          children: <Widget>[
            Text(
              '°C',
              style: ClockTheme.of(context).textTheme.headline,
            ),
            Text(
              '°F',
              style: ClockTheme.of(context).textTheme.headline,
            )
          ],
        ),
        Expanded(
          flex: 30,
          child: Stack(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  for (var i = 0; i < celsiusTemps.length; i++)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            this.celsiusTemps[i],
                            style: ClockTheme.of(context).textTheme.subhead,
                          ),
                          Text(
                            this.fahrenheitTemps[i],
                            style: ClockTheme.of(context).textTheme.subhead,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
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
                                          color: ClockTheme.of(context).accentColor,
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
                                this.getCelsiusPercentage(value),
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
