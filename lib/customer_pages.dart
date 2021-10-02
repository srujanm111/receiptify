import 'package:flutter/cupertino.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:receiptify/constants.dart';
import 'package:receiptify/widgets.dart';
import 'dart:io';

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
              padding: EdgeInsets.all(30),
              child: RoundCard(
                child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                        borderColor: const Color.fromRGBO(56, 218, 85, 1.0),
                        borderRadius: 10,
                        borderWidth: 5.0
                    )
                )
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
        //Future.delayed(Duration.zero, () => Navigator.push(
        //    context,
        //    MaterialPageRoute(builder: (context) => )
        //));
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
