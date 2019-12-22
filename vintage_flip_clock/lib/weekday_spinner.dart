import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/enums.dart';

class WeekdaySpinner extends StatefulWidget {
  const WeekdaySpinner(this._itemSize);

  final double _itemSize;

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

  double _getScrollOffsetOfWeekday() {
    return Weekday.values.indexOf(_weekdayNotifier.value) * widget._itemSize;
  }

  double _calculateScrollOffset() {
    final currentWeekdayIndex = Weekday.values.indexOf(_currentWeekday);
    final newWeekdayIndex = Weekday.values.indexOf(_weekdayNotifier.value);
    final diffIndex = (currentWeekdayIndex - newWeekdayIndex).abs();

    if (currentWeekdayIndex > newWeekdayIndex) {
      return _scrollController.offset - diffIndex * widget._itemSize;
    } else {
      return _scrollController.offset + diffIndex * widget._itemSize;
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
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: Weekday.values.length,
      itemExtent: widget._itemSize,
      itemBuilder: (BuildContext context, int index) {
        return FittedBox(
          fit: BoxFit.contain,
          child: Text(
            _enumToString(Weekday.values[index].toString()),
            style: TextStyle(
              color: ClockTheme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  String _enumToString(Object e) => e.toString().split('.').last;
}
