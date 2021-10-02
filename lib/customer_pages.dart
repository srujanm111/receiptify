import 'package:flutter/cupertino.dart';
import 'package:receiptify/constants.dart';
import 'package:receiptify/widgets.dart';

class Receipts extends StatefulWidget {
  @override
  _ReceiptsState createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          SliverNavigationBar("Receipts"),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(),
          ),
        ],
      ),
    );
  }

}


class Businesses extends StatefulWidget {
  @override
  _BusinessesState createState() => _BusinessesState();
}

class _BusinessesState extends State<Businesses> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          SliverNavigationBar("Businesses"),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(),
          ),
        ],
      ),
    );
  }

}

class ScanReceipt extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: green,
      child: CustomScrollView(
        slivers: [
          SliverNavigationBar("Scan QR Code"),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(30),
              child: RoundCard(
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}
