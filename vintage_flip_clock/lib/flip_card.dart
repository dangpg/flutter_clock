import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vintage_flip_clock/clock_theme.dart';
import 'package:vintage_flip_clock/enums.dart';

class FlipCard extends StatefulWidget {
  const FlipCard(
      {@required this.valueNotifier,
      @required this.modulo,
      this.dividerHeight = 2.0});

  final ValueNotifier<String> valueNotifier;
  final num modulo;
  final double dividerHeight;

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  ValueNotifier<String> _currValueNotifier;
  ValueNotifier<String> _nextValueNotifier;

  AnimationController _upperCardAnimationController;
  Animation<double> _upperCardAnimation;
  AnimationController _lowerCardAnimationController;
  Animation<double> _lowerCardAnimation;

  @override
  void initState() {
    super.initState();
    _currValueNotifier = ValueNotifier<String>(_getValue());
    _nextValueNotifier = ValueNotifier<String>(_getNextValue());

    _upperCardAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _upperCardAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _upperCardAnimationController,
        curve: Curves.easeInQuad,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _lowerCardAnimationController.forward();
          }
        },
      );
    _lowerCardAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _lowerCardAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _lowerCardAnimationController,
        curve: Curves.easeInQuad.flipped,
      ),
    )..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _updateValues();
          }
        },
      );

    widget.valueNotifier.addListener(_animateTransition);
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(_animateTransition);
    super.dispose();
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.modulo != widget.modulo) {
      oldWidget.valueNotifier.removeListener(_animateTransition);
      widget.valueNotifier.addListener(_animateTransition);
      _updateValues();
    }
  }

  void _animateTransition() {
    _upperCardAnimationController.forward();
  }

  void _updateValues() {
    _upperCardAnimationController.reset();
    _lowerCardAnimationController.reset();
    _currValueNotifier.value = _getValue();
    _nextValueNotifier.value = _getNextValue();
  }

  String _getValue() {
    return _handleSpecialCase(
            num.parse(widget.valueNotifier.value) % widget.modulo)
        .toString()
        .padLeft(2, '0');
  }

  String _getNextValue() {
    return _handleSpecialCase(
            (num.parse(widget.valueNotifier.value) + 1) % widget.modulo)
        .toString()
        .padLeft(2, '0');
  }

  // Handles special case since zero does not exist when using AM/PM
  num _handleSpecialCase(num value) {
    return (value == 0 && widget.modulo == 12) ? 12 : value;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Stack(
          children: <Widget>[
            _buildFlipCardWrapper(
                context: context,
                valueListenable: _nextValueNotifier,
                cardPosition: CardPosition.top,
                animationDirection: AnimationDirection.none),
            _buildFlipCardWrapper(
                context: context,
                valueListenable: _currValueNotifier,
                cardPosition: CardPosition.top,
                animationDirection: AnimationDirection.visibleToHide),
            _buildFlipCardWrapper(
                context: context,
                valueListenable: _currValueNotifier,
                cardPosition: CardPosition.bottom,
                animationDirection: AnimationDirection.none),
            _buildFlipCardWrapper(
                context: context,
                valueListenable: _nextValueNotifier,
                cardPosition: CardPosition.bottom,
                animationDirection: AnimationDirection.hideToVisible),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipCardWrapper(
      {BuildContext context,
      ValueListenable<String> valueListenable,
      CardPosition cardPosition,
      AnimationDirection animationDirection = AnimationDirection.none}) {
    final child = _buildFlipCard(
        context: context,
        valueListenable: valueListenable,
        cardPosition: cardPosition,
        animationDirection: animationDirection);

    return Align(
      alignment: cardPosition == CardPosition.top
          ? Alignment.topCenter
          : Alignment.bottomCenter,
      child: animationDirection == AnimationDirection.none
          ? child
          : AnimatedBuilder(
              animation: animationDirection == AnimationDirection.visibleToHide
                  ? _upperCardAnimation
                  : _lowerCardAnimation,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.003)
                    ..rotateX(
                      pi *
                          (animationDirection ==
                                  AnimationDirection.visibleToHide
                              ? _upperCardAnimation.value
                              : -_lowerCardAnimation.value),
                    ),
                  alignment:
                      animationDirection == AnimationDirection.visibleToHide
                          ? FractionalOffset.bottomCenter
                          : FractionalOffset.topCenter,
                  child: child,
                );
              },
              child: child,
            ),
    );
  }

  Widget _buildFlipCard(
      {BuildContext context,
      ValueListenable<String> valueListenable,
      CardPosition cardPosition,
      AnimationDirection animationDirection = AnimationDirection.none}) {
    return Container(
      decoration: BoxDecoration(
        border: cardPosition == CardPosition.top
            ? Border(
                bottom: BorderSide(
                  width: widget.dividerHeight / 2.0,
                  color: ClockTheme.of(context).highlightColor,
                ),
              )
            : Border(
                top: BorderSide(
                  width: widget.dividerHeight / 2.0,
                  color: ClockTheme.of(context).highlightColor,
                ),
              ),
      ),
      child: ClipRect(
        child: Align(
          alignment: cardPosition == CardPosition.top
              ? Alignment.topCenter
              : Alignment.bottomCenter,
          heightFactor: 0.5,
          child: SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: cardPosition == CardPosition.top
                    ? BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                      )
                    : BorderRadius.only(
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                color: ClockTheme.of(context).cardColor,
              ),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: ValueListenableBuilder(
                  valueListenable: valueListenable,
                  builder: (BuildContext context, String value, Widget child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          value.substring(0, 1),
                          style: widget.modulo == 60 ? ClockTheme.of(context).textTheme.display3 : ClockTheme.of(context).textTheme.display1,
                        ),
                        Text(
                          value.substring(1, 2),
                          style: widget.modulo == 60 ? ClockTheme.of(context).textTheme.display4 : ClockTheme.of(context).textTheme.display2,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
