import 'package:flutter/cupertino.dart';
import 'package:receiptify/constants.dart';

class ReceiptifyTitle extends StatelessWidget {

  final bool inverted;

  ReceiptifyTitle({this.inverted = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          "Receiptify",
          style: TextStyle(
            color: inverted ? white : green,
          ),
        ),
      ),
    );
  }
}

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

class TextFieldController extends TextEditingController {

  _LargeTextFieldState _state;

  TextFieldController({String text}) : super(text: text);

  void attachState(_LargeTextFieldState state) => _state = state;

  void showError(String message) => _state.showError(message);

  void clearError() => _state.clearError();

}

class LargeTextField extends StatefulWidget {

  final TextFieldController controller;
  final String placeholder;

  LargeTextField({this.controller, this.placeholder});

  @override
  _LargeTextFieldState createState() => _LargeTextFieldState();
}

class _LargeTextFieldState extends State<LargeTextField> {

  var isError = false;
  var errorMessage = "";

  @override
  void initState() {
    super.initState();
    widget.controller.attachState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CupertinoTextField(
          cursorColor: CupertinoTheme.of(context).primaryColor,
          controller: widget.controller,
          style: TextStyle(
            color: title,
            fontSize: 20,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isError ? red : subtitle,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(11),
          ),
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          placeholder: widget.placeholder,
          placeholderStyle: TextStyle(
            color: subtitle,
            fontSize: 20,
          ),
        ),
        isError ? Padding(
          padding: EdgeInsets.only(left: 16, top: 2),
          child: Text(
            errorMessage,
            style: TextStyle(
              fontSize: 16,
              color: red,
            ),
          ),
        ) : Container(),
      ],
    );
  }

  void showError(String message) {
    setState(() {
      isError = true;
      errorMessage = message;
    });
  }

  void clearError() {
    setState(() {
      isError = false;
      errorMessage = "";
    });
  }

}
