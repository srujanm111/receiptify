import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:receiptify/constants.dart';
import 'package:receiptify/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  GlobalKey<CustomTabBarViewState> tabViewKey;

  @override
  void initState() {
    super.initState();
    tabViewKey = GlobalKey<CustomTabBarViewState>();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          TabbedNavigationBar(
            "Businesses",
            PinnedSelector(
              initialIndex: 0,
              items: [
                SelectorItem("Announcements", () => changePage(0)),
                SelectorItem("Subscriptions", () => changePage(1)),
              ],
            ),
          ),
          CustomTabBarView(
            initialIndex: 0,
            key: tabViewKey,
            useChildDirectly: true,
            tabs: [
              SliverFillRemaining(hasScrollBody: false, child: Container()),
              SliverFillRemaining(hasScrollBody: false, child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  void changePage(int page) {
    tabViewKey.currentState.changePage(page);
  }

}

class ScanReceipt extends StatefulWidget {

  State<ScanReceipt> createState() => _ScanReceipt();
}

class _ScanReceipt extends State<ScanReceipt> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

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
              padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: green,
                    borderRadius: 10,
                    borderWidth: 10.0
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.stopCamera();
        Future.delayed(Duration.zero, () =>
            _queryServer(result.code).then((response) {
              var data = _parseData(response);
              //send data to receipt
            }));
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<http.Response> _queryServer(String hash) async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');

    var url = Uri.parse('https://qrcoder-server.herokuapp.com/retrieveHash');
    return await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          'securityCode': 'A3D263103C27E77EF8B6267C051906C0',
          'hashCode': hash,
          'name': name ?? 'ERROR'
        })
    );
  }

  dynamic _parseData(response) {
    var data = jsonDecode(response.body);
    return data['data'];
  }

}