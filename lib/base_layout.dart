import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:receiptify/customer_pages.dart';

import 'constants.dart';

class BaseLayout extends StatefulWidget {

  final bool customer;

  BaseLayout(this.customer);

  @override
  _BaseLayoutState createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {

  int currentIndex = 0;
  List<GlobalKey<NavigatorState>> keys;
  CupertinoTabController controller;

  @override
  void initState() {
    super.initState();
    keys = List.generate(3, (index) => GlobalKey<NavigatorState>());
    controller = CupertinoTabController();
  }

  @override
  Widget build(BuildContext context) {
    return widget.customer ? CustomerLayout(
      controller: controller,
      onTap: onTabPress,
      keys: keys,
    ) : BusinessLayout(
      controller: controller,
      onTap: onTabPress,
      keys: keys,
    );
  }

  void onTabPress(int index) {
    if (currentIndex == index) {
      keys[index].currentState?.popUntil((route) => route.isFirst);
    }
    currentIndex = index;
  }

}

class CustomerLayout extends StatefulWidget {
  CustomerLayout({this.controller, this.onTap, this.keys});
  final CupertinoTabController controller;
  final Function(int) onTap;
  final List<GlobalKey<NavigatorState>> keys;

  State<CustomerLayout> createState() => _CustomerLayout();
}

class _CustomerLayout extends State<CustomerLayout> {

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: widget.controller,
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: NavIcon("Receipts", "receipts"),
          ),
          BottomNavigationBarItem(
            icon: NavIcon("Scan QR", "qr_scan"),
          ),
          BottomNavigationBarItem(
            icon: NavIcon("Businesses", "business"),
          ),
        ],
        onTap: widget.onTap,
      ),
      tabBuilder: (context, i) {
        return CupertinoTabView(
          navigatorKey: widget.keys[i],
          builder: (context) {
            return _getView(i);
          },
        );
      },
    );
  }

  Widget _getView(int index) {
    switch (index) {
      case 0:
        print('Current Receipts: '+ receiptManager.currentReceipts.length.toString());
        return Receipts(receiptManager.currentReceipts);
      case 1:
        return ScanReceipt();
      case 2:
        return Businesses();
    }
    return CupertinoPageScaffold(child: Container());
  }
}

class BusinessLayout extends StatelessWidget {

  final CupertinoTabController controller;
  final Function(int) onTap;
  final List<GlobalKey<NavigatorState>> keys;

  BusinessLayout({this.controller, this.onTap, this.keys});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: controller,
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: NavIcon("Create", "create_receipt"),
          ),
          BottomNavigationBarItem(
            icon: NavIcon("Scan QR", "qr_scan"),
          ),
          BottomNavigationBarItem(
            icon: NavIcon("Announcements", "announcement"),
          ),
        ],
        onTap: onTap,
      ),
      tabBuilder: (context, i) {
        return CupertinoTabView(
          navigatorKey: keys[i],
          builder: (context) {
            return _getView(i);
          },
        );
      },
    );
  }

  Widget _getView(int index) {
    switch (index) {
      case 0:
        return CupertinoPageScaffold(child: Container());
      case 1:
        return CupertinoPageScaffold(child: Container());
      case 2:
        return CupertinoPageScaffold(child: Container());
    }
    return CupertinoPageScaffold(child: Container());
  }
}

class NavIcon extends StatelessWidget {

  final String image;
  final String title;

  NavIcon(this.title, this.image);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: image == "qr_scan" ? qrImage(context) : Column(
        children: [
          Container(
            height: 28,
            width: 28,
            child: Center(
              child: Image.asset("assets/icons/$image.png", color: IconTheme.of(context).color,),
            ),
          ),
          Text(title),
        ],
      ),
    );
  }

  Widget qrImage(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Container(
          height: 28,
          width: 28,
          child: Image.asset("assets/icons/$image.png", color: white),
        ),
      ),
    );
  }

}