import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// class Welcome extends StatefulWidget {
//   @override
//   _WelcomeState createState() => _WelcomeState();
// }
//
// class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
//
//   AnimationController _controller;
//   Animation<Offset> _offsetAnimation;
//   Animation<double> _titleAnimation;
//   Animation<double> _messageAnimation;
//   Animation<double> _buttonAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: Duration(seconds: 2),
//       vsync: this,
//     );
//     _offsetAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: Offset(0.0, -2.25),
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Interval(
//         0.1, 0.5,
//         curve: Curves.decelerate,
//       ),
//     ));
//     _titleAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Interval(
//         0.4, 0.8,
//         curve: Curves.decelerate,
//       ),
//     ));
//     _messageAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Interval(
//         0.5, 0.9,
//         curve: Curves.decelerate,
//       ),
//     ));
//     _buttonAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Interval(
//         0.6, 1,
//         curve: Curves.decelerate,
//       ),
//     ));
//     _controller.forward();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Layout(
//           backgroundColor: green,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 175),
//               _title(),
//               SizedBox(height: 30),
//               _welcomeMessage(context),
//               SizedBox(height: 30),
//               Spacer(flex: 5,),
//               _button(),
//             ],
//           ),
//         ),
//         _logo(),
//       ],
//     );
//   }
//
//   Widget _title() {
//     return FadeTransition(
//       opacity: _titleAnimation,
//       child: GradeWayTitle(inverted: true),
//     );
//   }
//
//   Widget _button({bool tablet = false}) {
//     return FadeTransition(
//       opacity: _buttonAnimation,
//       child: LargeButton(title: "Get Started", onPress: () {}, context, root: true), inverted: true,),
//     );
//   }
//
//   Widget _logo() {
//     return Center(
//       child: SlideTransition(
//         position: _offsetAnimation,
//         child: Image.asset(
//           'assets/logo.png',
//           fit: BoxFit.contain,
//           width: 100.0,
//           height: 100.0,
//         ),
//       ),
//     );
//   }
//
//   Widget _welcomeMessage(BuildContext context) {
//     return FadeTransition(
//       opacity: _messageAnimation,
//       child: DynamicContainer(
//         width: 400,
//         child: FittedBox(
//           fit: BoxFit.contain,
//           child: Text(
//             "Digitize your receipts\nand support small businesses.",
//             style: TextStyle(color: white,),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
// }
