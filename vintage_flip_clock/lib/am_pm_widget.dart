import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/enums.dart';

class AmPmWidget extends StatefulWidget {
  const AmPmWidget(this._iconSize);

  final double _iconSize;

  @override
  _AmPmWidgetState createState() => _AmPmWidgetState();
}

class _AmPmWidgetState extends State<AmPmWidget> {
  ValueNotifier<HourMode> _hourModeNotifier;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _hourModeNotifier = (context
            .getElementForInheritedWidgetOfExactType<ClockProvider>()
            ?.widget as ClockProvider)
        .hourModeNotifier;
    _hourModeNotifier.addListener(_scrollToMode);
    _scrollController = ScrollController(
        initialScrollOffset:
            _hourModeNotifier.value == HourMode.AM ? 0.0 : widget._iconSize);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToMode() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset +
          (_hourModeNotifier.value == HourMode.AM
              ? -widget._iconSize
              : widget._iconSize);
      _scrollController.animateTo(offset,
          duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      itemCount: 2,
      itemExtent: widget._iconSize,
      itemBuilder: (BuildContext context, int index) {
        return FittedBox(
          fit: BoxFit.contain,
          child: Text(
            _enumToString(HourMode.values[index]),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  String _enumToString(Object e) => e.toString().split('.').last;
}
