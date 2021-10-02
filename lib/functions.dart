import 'package:flutter/cupertino.dart';

List<Widget> verticalSpace(double gap, List<Widget> children) {
  children.removeWhere((element) => element == null);
  for (int i = 1; i < children.length; i+= 2) {
    children.insert(i, SizedBox(height: gap,));
  }
  return children;
}

List<Widget> horizontalSpace(double gap, List<Widget> children) {
  children.removeWhere((element) => element == null);
  for (int i = 1; i < children.length; i+= 2) {
    children.insert(i, SizedBox(width: gap,));
  }
  return children;
}

Future<T> push<T>(Widget page, BuildContext context, {bool fade = false}) async {
  return Navigator.of(context).push(fade ? PageRouteBuilder(
    transitionDuration: Duration(milliseconds: 200),
    pageBuilder: (context, animation1, animation2) => page,
    transitionsBuilder: (context, animation1, animation2, child) => FadeTransition(opacity: animation1, child: child,),
  ) : CupertinoPageRoute(
    builder: (context) => page,
  ),);
}

Future<T> showCustomDialog<T>(BuildContext context, Widget dialog, {bool barrierDismissible = true}) {
  barrierDismissible = true;
  return showCupertinoDialog<T>(context: context, builder: (context) => dialog, barrierDismissible: barrierDismissible);
}

String currentDateString() {
  final now = DateTime.now();
  return "${now.month}/0${now.day}/${now.year}";
}