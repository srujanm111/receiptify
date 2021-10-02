import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:receiptify/constants.dart';
import 'package:receiptify/onboarding.dart';

bool get isSystemDark =>
    SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

void main() {
  runApp(ReceiptifyApplication());
}

class ReceiptifyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child,
      ),
      home: Welcome(),
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        barBackgroundColor: canvas,
        scaffoldBackgroundColor: background,
        primaryColor: green,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: "Avenir",
          ),
          tabLabelTextStyle: TextStyle(
            fontFamily: "Avenir",
            fontSize: 11,
          ),
          navTitleTextStyle: TextStyle(
            fontFamily: "Avenir",
            color: white,
            fontSize: 20,
          ),
          navLargeTitleTextStyle: TextStyle(
            fontFamily: "Avenir",
            color: white,
            fontSize: 40,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
