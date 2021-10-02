import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class CodeScanner extends StatelessWidget {
  const CodeScanner({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QRScanner(),
    );
  }
}

class QRScanner extends StatefulWidget {
  const QRScanner({Key key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: const Color.fromRGBO(56, 218, 85, 1.0),
                borderRadius: 10,
                borderWidth: 5.0
              ),
            ),
          ),
          const Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a code'),
            ),
          )
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
