import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receiptify/widgets.dart';
import 'constants.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<Offset> _offsetAnimation;
  Animation<double> _titleAnimation;
  Animation<double> _messageAnimation;
  Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, -2.25),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.1, 0.5,
        curve: Curves.decelerate,
      ),
    ));
    _titleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.4, 0.8,
        curve: Curves.decelerate,
      ),
    ));
    _messageAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.5, 0.9,
        curve: Curves.decelerate,
      ),
    ));
    _buttonAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.6, 1,
        curve: Curves.decelerate,
      ),
    ));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CupertinoPageScaffold(
          backgroundColor: green,
          navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.transparent,
            border: null,
            automaticallyImplyLeading: false,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 25,
              right: 25,
              top: 25 + MediaQuery.of(context).padding.top,
              bottom: 25 + MediaQuery.of(context).padding.bottom + 15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 175),
                _title(),
                SizedBox(height: 30),
                _welcomeMessage(context),
                SizedBox(height: 30),
                Spacer(flex: 5,),
                _button("Customer"),
                SizedBox(height: 15),
                _button("Business"),
              ],
            ),
          ),
        ),
        _logo(),
      ],
    );
  }

  Widget _title() {
    return FadeTransition(
      opacity: _titleAnimation,
      child: ReceiptifyTitle(inverted: true),
    );
  }

  Widget _button(String text) {
    return FadeTransition(
      opacity: _buttonAnimation,
      child: LargeButton(title: text, onPress: () {}, inverted: true,),
    );
  }

  Widget _logo() {
    return Center(
      child: SlideTransition(
        position: _offsetAnimation,
        child: Image.asset(
          'assets/icons/logo.png',
          fit: BoxFit.contain,
          width: 100.0,
          height: 100.0,
          color: white,
        ),
      ),
    );
  }

  Widget _welcomeMessage(BuildContext context) {
    return FadeTransition(
      opacity: _messageAnimation,
      child: Container(
        width: 400,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            "Digitize your receipts\nand support small businesses.",
            style: TextStyle(color: white,),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}

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