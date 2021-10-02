import 'package:flutter/cupertino.dart';

import 'constants.dart';

class LargeButton extends StatelessWidget {

  final String title;
  final VoidCallback onPress;
  final double width;
  final bool inverted;

  LargeButton({this.title, this.onPress, this.width, this.inverted = false});

  @override
  Widget build(BuildContext context) {
    return RoundButton(
      height: 52,
      width: width,
      text: title,
      inverted: inverted,
      fontSize: ButtonTextSize.large,
      onPress: onPress,
    );
  }

}

enum ButtonTextSize {
  small, medium, large
}

class RoundButton extends StatefulWidget {

  final double height;
  final double width;
  final String text;
  final ButtonTextSize fontSize;
  final VoidCallback onPress;
  final bool inverted;

  RoundButton({this.height, this.width, this.text, this.fontSize, this.onPress, this.inverted = false});

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {

  bool isPressedDown = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => setState(() => isPressedDown = true),
      onPointerUp: (event) => setState(() => isPressedDown = false),
      onPointerCancel: (event) => setState(() => isPressedDown = false),
      child: GestureDetector(
        onTap: widget.onPress,
        child: AnimatedOpacity(
          opacity: isPressedDown ? 0.6 : 1,
          duration: Duration(milliseconds: isPressedDown ? 10 : 100),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: widget.inverted ? white : CupertinoTheme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Text(
                widget.text,
                style: TextStyle(
                  color: widget.inverted ? CupertinoTheme.of(context).primaryColor : white,
                  fontSize: _fontSize(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _fontSize() {
    switch (widget.fontSize) {
      case ButtonTextSize.small:
        return 16;
      case ButtonTextSize.medium:
        return 18;
      case ButtonTextSize.large:
        return 20;
    }
    return 18;
  }
}

enum ArrowDirection {
  left, right
}

class ArrowButton extends StatelessWidget {

  final ArrowDirection direction;
  final VoidCallback onPress;
  final Color color;
  final double size;
  final bool pad;

  ArrowButton({this.direction = ArrowDirection.right, this.onPress, this.color, this.size, this.pad = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: pad ? 40 : (direction == ArrowDirection.left && color == null ? 40 : null),
        child: Align(
          alignment: direction == ArrowDirection.left ? Alignment.centerLeft : Alignment.centerRight,
          child: RotatedBox(
            quarterTurns: direction == ArrowDirection.left ? 2 : 0,
            child: Container(
              child: Icon(
                RightArrow.right_arrow,
                color: color ?? (direction == ArrowDirection.left ? white : subtitle),
                size: size ?? (direction == ArrowDirection.left ? 21 : 18.5),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
