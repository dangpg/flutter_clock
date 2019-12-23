import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/clock_provider.dart';
import 'package:vintage_flip_clock/enums.dart';
import 'package:vintage_flip_clock/util.dart';

class AmPmWidget extends StatefulWidget {
  const AmPmWidget({@required this.iconSize});

  final double iconSize;

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
            _hourModeNotifier.value == HourMode.AM ? 0.0 : widget.iconSize);
  }

  @override
  void dispose() {
    _hourModeNotifier.removeListener(_scrollToMode);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToMode() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset +
          (_hourModeNotifier.value == HourMode.AM
              ? -widget.iconSize
              : widget.iconSize);
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
      itemExtent: widget.iconSize,
      itemBuilder: (BuildContext context, int index) {
        return FittedBox(
          fit: BoxFit.contain,
          child: Text(
            Util.enumToString(HourMode.values[index]),
            style: TextStyle(
              color: ClockTheme.of(context).accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
