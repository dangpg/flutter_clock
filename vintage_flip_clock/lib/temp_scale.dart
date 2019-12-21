import 'package:flutter/material.dart';

class TempScale extends StatefulWidget {
  const TempScale(this.tempNotifier);

  final ValueNotifier<num> tempNotifier;

  @override
  _TempScaleState createState() => _TempScaleState();
}

class _TempScaleState extends State<TempScale> {
  final List<int> colorCodes = <int>[600, 500, 100];
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
//      decoration: BoxDecoration(
//        color: Colors.transparent,
//        boxShadow: [
//          const BoxShadow(
//            color: Colors.white,
//            offset: const Offset(0.0, 0.0),
//          ),
//          const BoxShadow(
//            color: Color(0xFF202020),
//            offset: const Offset(0.0, 0.0),
//            spreadRadius: -2.0,
//            blurRadius: 10.0,
//          ),
//        ],
//      ),
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
              color: Colors.black,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('°C', style: TextStyle(color: Colors.white)),
                      Text('°F', style: TextStyle(color: Colors.white))
                    ],
                  ),
                  Container(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            for (var i = 0; i < celsiusTemps.length; i++)
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      this.celsiusTemps[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: <Widget>[
                                            for (var j = 0; j < 5; j++)
                                              LayoutBuilder(
                                                builder: (BuildContext context,
                                                    BoxConstraints constrains) {
                                                  return Container(
                                                    height: j == 2
                                                        ? constrains
                                                            .biggest.height
                                                        : constrains.biggest
                                                                .height *
                                                            0.5,
                                                    width: 1.0,
                                                    color: Colors.white,
                                                  );
                                                },
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Text(
                                      this.fahrenheitTemps[i],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Positioned.fill(
                          child: LayoutBuilder(
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return ValueListenableBuilder(
                                valueListenable: widget.tempNotifier,
                                builder: (BuildContext context, num value,
                                    Widget child) {
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
                                child: _buildSlider(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Container(
          width: 4.0,
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(2.5),
            color: Colors.red,
            boxShadow: [
              new BoxShadow(
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
