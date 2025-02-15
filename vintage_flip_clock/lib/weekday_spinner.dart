import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/enums.dart';
import 'package:vintage_flip_clock/util.dart';

class WeekdaySpinner extends StatefulWidget {
  const WeekdaySpinner({@required this.itemSize});

  final double itemSize;

  @override
  _WeekdaySpinnerState createState() => _WeekdaySpinnerState();
}

class _WeekdaySpinnerState extends State<WeekdaySpinner> {
  ValueNotifier<Weekday> _weekdayNotifier;
  Weekday _currentWeekday;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _weekdayNotifier = (context
            .getElementForInheritedWidgetOfExactType<ClockProvider>()
            ?.widget as ClockProvider)
        .weekdayNotifier;
    _weekdayNotifier.addListener(_scrollToWeekday);
    _currentWeekday = _weekdayNotifier.value;
    _scrollController =
        ScrollController(initialScrollOffset: _getScrollOffsetOfWeekday());
  }

  @override
  void dispose() {
    _weekdayNotifier.removeListener(_scrollToWeekday);
    _scrollController.dispose();
    super.dispose();
  }

  double _getScrollOffsetOfWeekday() {
    return Weekday.values.indexOf(_weekdayNotifier.value) * widget.itemSize;
  }

  double _calculateScrollOffset() {
    final currentWeekdayIndex = Weekday.values.indexOf(_currentWeekday);
    final newWeekdayIndex = Weekday.values.indexOf(_weekdayNotifier.value);
    final diffIndex = (currentWeekdayIndex - newWeekdayIndex).abs();

    if (currentWeekdayIndex > newWeekdayIndex) {
      return _scrollController.offset - diffIndex * widget.itemSize;
    } else {
      return _scrollController.offset + diffIndex * widget.itemSize;
    }
  }

  void _scrollToWeekday() {
    if (_scrollController.hasClients) {
      final offset = _calculateScrollOffset();
      _scrollController.animateTo(offset,
          duration: const Duration(seconds: 3), curve: Curves.easeInOut);
      _currentWeekday = _weekdayNotifier.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      ClockTheme.of(context).textTheme.display1.color,
      ClockTheme.of(context).textTheme.display2.color,
      ClockTheme.of(context).textTheme.display3.color,
      ClockTheme.of(context).textTheme.display4.color,
    ];
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: Weekday.values.length,
      itemExtent: widget.itemSize,
      itemBuilder: (BuildContext context, int index) {
        return FittedBox(
          fit: BoxFit.contain,
          child: Text(
            Util.enumToString(Weekday.values[index].toString()),
            style: TextStyle(
                fontWeight: FontWeight.bold, color: colors[index % 4]),
          ),
        );
      },
    );
  }
}
