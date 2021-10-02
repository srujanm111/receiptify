import 'package:flutter/cupertino.dart';
import 'package:receiptify/widgets.dart';

class ShowQrCode extends StatelessWidget {

  final String hash;

  ShowQrCode(this.hash);

  @override
  Widget build(BuildContext context) {
    // TODO generate QR code from hash
    return Column(
      children: [
        // Generated QR Code here
        RoundButton(
          text: "Done",
          height: 45,
          onPress: () => Navigator.of(context).pop(),
        )
      ],
    );
  }

}