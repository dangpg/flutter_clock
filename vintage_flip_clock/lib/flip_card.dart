import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'clock_cards.dart';

enum CardPosition { top, bottom }
enum AnimationDirection { visibleToHide, hideToVisible, none }

class FlipCard extends StatefulWidget {
  const FlipCard(this._valueNotifier, this._mode);

  final ValueNotifier<String> _valueNotifier;
  final Mode _mode;

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  ValueNotifier<String> _currValueNotifier;
  ValueNotifier<String> _nextValueNotifier;

  final _dividerHeight = 6.0;
  final _dividerColor = Color(0xFF202020);
  final _cardColor = Colors.black;

  AnimationController _upperCardAnimationController;
  Animation<double> _upperCardAnimation;
  AnimationController _lowerCardAnimationController;
  Animation<double> _lowerCardAnimation;

  @override
  void initState() {
    super.initState();
    _currValueNotifier = ValueNotifier<String>(widget._valueNotifier.value);
    _nextValueNotifier =
        ValueNotifier<String>(_getNextValue(widget._valueNotifier.value));

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

    widget._valueNotifier.addListener(_animateTransition);
  }

  void _animateTransition() {
    _upperCardAnimationController.forward();
  }

  void _updateValues() {
    _upperCardAnimationController.reset();
    _lowerCardAnimationController.reset();
    _currValueNotifier.value = widget._valueNotifier.value;
    _nextValueNotifier.value = _getNextValue(widget._valueNotifier.value);
  }

  String _getNextValue(String value) {
    final numValue = num.parse(value);
    if (widget._mode == Mode.hour) {
      return ((numValue + 1) % 24).toString().padLeft(2, '0');
    } else {
      return ((numValue + 1) % 60).toString().padLeft(2, '0');
    }
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
                valueListenable: _nextValueNotifier,
                cardPosition: CardPosition.top,
                animationDirection: AnimationDirection.none),
            _buildFlipCardWrapper(
                valueListenable: _currValueNotifier,
                cardPosition: CardPosition.top,
                animationDirection: AnimationDirection.visibleToHide),
            _buildFlipCardWrapper(
                valueListenable: _currValueNotifier,
                cardPosition: CardPosition.bottom,
                animationDirection: AnimationDirection.none),
            _buildFlipCardWrapper(
                valueListenable: _nextValueNotifier,
                cardPosition: CardPosition.bottom,
                animationDirection: AnimationDirection.hideToVisible),
          ],
        ),
      ),
    );
  }

  Widget _buildFlipCardWrapper(
      {ValueListenable<String> valueListenable,
      CardPosition cardPosition,
      AnimationDirection animationDirection = AnimationDirection.none}) {
    final child = _buildFlipCard(
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
      {ValueListenable<String> valueListenable,
      CardPosition cardPosition,
      AnimationDirection animationDirection = AnimationDirection.none}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: cardPosition == CardPosition.top
            ? Border(
                bottom: BorderSide(
                  width: _dividerHeight / 2.0,
                  color: _dividerColor,
                ),
              )
            : Border(
                top: BorderSide(
                  width: _dividerHeight / 2.0,
                  color: _dividerColor,
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
              color: _cardColor,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: ValueListenableBuilder(
                  valueListenable: valueListenable,
                  builder: (BuildContext context, String value, Widget child) {
                    return Text(
                      value,
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
