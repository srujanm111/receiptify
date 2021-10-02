import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'base_layout.dart';

bool get isSystemDark =>
    SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

void main() {
  runApp(ReceiptifyApplication());
}

class ReceiptifyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseLayout();
  }
}
