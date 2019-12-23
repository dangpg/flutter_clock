import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/flip_card.dart';

class ClockCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Spacer(),
        Expanded(
          flex: 30,
          child: ValueListenableBuilder(
            valueListenable: ClockProvider.of(context).is24HourFormatNotifier,
            builder: (BuildContext context, bool is24HourFormat, Widget child) {
              return FlipCard(
                valueNotifier: ClockProvider.of(context).hourNotifier,
                modulo: is24HourFormat ? 24 : 12,
              );
            },
          ),
        ),
        Spacer(),
        Expanded(
          flex: 30,
          child: FlipCard(
            valueNotifier: ClockProvider.of(context).minuteNotifier,
            modulo: 60,
          ),
        ),
        Spacer(),
      ],
    );
  }
}
