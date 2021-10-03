import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:receiptify/constants.dart';
import 'package:receiptify/create_qrcode.dart';
import 'package:receiptify/data_classes.dart';
import 'package:receiptify/functions.dart';
import 'package:receiptify/main.dart';
import 'package:receiptify/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' as foundation;

class Receipts extends StatefulWidget {

  @override
  _ReceiptsState createState() => _ReceiptsState();
}

class _ReceiptsState extends State<Receipts> {

  Future<List<Receipt>> future;

  @override
  void initState() {
    super.initState();
    future = _getReceipts();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          SliverNavigationBar("Receipts", onRefresh: () => setState(() {
            future = _getReceipts();
          }),),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(edge_padding),
              child: FutureBuilder<List<Receipt>>(
                future: future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(green)));
                  } else if (snapshot.hasData) {
                    return Column(
                      children: verticalSpace(card_spacing, snapshot.data.map((r) => _receiptCard(r)).toList()),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(green)));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Receipt>> _getReceipts() async {
    var url = Uri.parse(baseURL + 'retrieveReceipts');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'securityCode': securityCode,
        'name': Receiptify.instance.customer.name,
        'email': Receiptify.instance.customer.email
      }),
    );
    var json = jsonDecode(response.body);
    List<dynamic> hashes = json["allReceipts"];
    List<Receipt> receipts = [];
    for (String hash in hashes) {
      var url = Uri.parse(baseURL + 'retrieveHash');
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          'securityCode': securityCode,
          'name': Receiptify.instance.customer.name,
          'hashCode': hash,
        }),
      );
      var map = jsonDecode(response.body);
      var receipt = Receipt.fromJson(map["data"]);
      receipt.hash = hash;
      receipts.add(receipt);
    }
    return receipts;
  }

  Widget _receiptCard(Receipt receipt) {
    return GestureDetector(
      onTap: () => push(ReceiptView(receipt), context),
      child: RoundCard(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            receipt.coupons.isNotEmpty ? Container(
              height: 35,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Center(
                child: Text("${receipt.coupons.length} Coupon${receipt.coupons.length > 1 ? "s" : ""} Attached!"),
              ),
            ) : Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: vertical_margin, horizontal: horizontal_margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(receipt.businessName, style: TextStyle(color: title, fontSize: 20),),
                          Text(receipt.dateIssued, style: TextStyle(color: subtitle, fontSize: 15),),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("\$${receipt.total.toStringAsFixed(2)}", style: TextStyle(color: white, fontSize: 16),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  ...verticalSpace(10, receipt.order.map<Widget>((product) => Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text("${product.quantity}x", style: TextStyle(color: white, fontSize: 14),),
                        ),
                      ),
                      SizedBox(width: 8,),
                      Text(product.name, style: TextStyle(color: title, fontSize: 16),),
                      Spacer(),
                      Text("\$${product.price}", style: TextStyle(color: green, fontSize: 16),)
                    ],
                  )).toList()),
                  receipt.coupons.isNotEmpty ? SizedBox(height: 32,) : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ReceiptView extends StatelessWidget {

  final Receipt receipt;

  ReceiptView(this.receipt);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(receipt.businessName),
        transitionBetweenRoutes: false,
        backgroundColor: CupertinoTheme.of(context).primaryColor,
        brightness: Brightness.dark,
        border: null,
        leading: ArrowButton(direction: ArrowDirection.left, onPress: () => Navigator.of(context).pop(),),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: _body(context),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(edge_padding),
      child: Column(
        children: verticalSpace(card_spacing, [
          Stack(
            alignment: Alignment.topRight,
            children: [
              RoundCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: vertical_margin, horizontal: horizontal_margin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                          color: title,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Text(receipt.businessName, style: TextStyle(color: white, fontSize: 20),),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(receipt.address.street, style: TextStyle(color: title, fontSize: 20),),
                      Text("${receipt.address.city}, ${receipt.address.state} ${receipt.address.zip}", style: TextStyle(color: title, fontSize: 20),),
                      Text(receipt.phone, style: TextStyle(color: title, fontSize: 20),),
                      SizedBox(height: 20,),
                      ...verticalSpace(10, receipt.order.map<Widget>((product) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text("${product.quantity}x", style: TextStyle(color: white, fontSize: 14),),
                              ),
                            ),
                            SizedBox(width: 8,),
                            Text(product.name, style: TextStyle(color: title, fontSize: 16),),
                            Spacer(),
                            Text("\$${product.price}", style: TextStyle(color: green, fontSize: 16),)
                          ],
                        ),
                      )).toList()),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _dollarAmount(receipt.subtotal, "Subtotal"),
                            _dollarAmount(receipt.total - receipt.subtotal, "Tax 6%"),
                            _dollarAmount(receipt.total, "Total"),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          RoundButton(
                            height: 45,
                            text: "Present Receipt",
                            onPress: () => showCustomDialog<String>(context, CustomDialog("Receipt", ShowQRCode(receipt.hash))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Center(
                                child: Image.asset("assets/icons/qr_code.png", color: white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(receipt.dateIssued, style: TextStyle(color: subtitle, fontSize: 15)),
              ),
            ],
          ),
          ...receipt.coupons.map((coupon) => RoundCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: vertical_margin, horizontal: horizontal_margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(coupon.details, style: TextStyle(color: title, fontSize: 20),),
                  SizedBox(height: 15,),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      RoundButton(
                        height: 45,
                        text: "Present Coupon",
                        onPress: () => showCustomDialog<String>(context, CustomDialog("Coupon", ShowQRCode(receipt.hash))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          height: 30,
                          width: 30,
                          child: Center(
                            child: Image.asset("assets/icons/qr_code.png", color: white,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(coupon.expirationDate, style: TextStyle(color: subtitle, fontSize: 15),),
                ],
              ),
            ),
          )).toList(),
          RoundButton(
            height: 45,
            text: "Subscribe to " + receipt.businessName + "!",
            onPress: () {
              String name = receipt.businessName;

              _subscribeToBusiness(name).then((response) {
                var jsonBody = jsonDecode(response.body);
                if(jsonBody['success']) {
                  showCustomDialog<String>(context, CustomDialog("Subscribed to $name!", Icon(Icons.check)));
                }
              });

            }),
    ]),
    ),
    );
  }

  Future<http.Response> _subscribeToBusiness(String businessName) async{
    var url = getAPI(baseURL, 'addSubscription');
    return await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          'securityCode': 'A3D263103C27E77EF8B6267C051906C0',
          'name': Receiptify.instance.customer.name,
          'subscription': businessName
        })
    );
  }

  Widget _dollarAmount(double amount, String sub) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text("\$${amount.toStringAsFixed(2)}", style: TextStyle(color: white, fontSize: 16),),
          ),
        ),
        SizedBox(height: 2,),
        Text(sub, style: TextStyle(color: subtitle, fontSize: 14),),
      ],
    );
  }

}

class CustomerScanReceipt extends StatefulWidget {

  State<CustomerScanReceipt> createState() => _ScanReceipt();
}

class _ScanReceipt extends State<CustomerScanReceipt> {

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
        if (result == null) {
          result = scanData;
          if (!foundation.kIsWeb) {
            controller.pauseCamera();
          }
          _getReceipt(result.code).then((receipt) {
            showCustomDialog(context, CustomDialog("Receipt Added!", Builder(
              builder: (context) => Column(
                children: [
                  Text("Thank you for shopping at ${receipt.businessName}!", style: TextStyle(color: green, fontSize: 18,), textAlign: TextAlign.center,),
                  SizedBox(height: 20),
                  RoundButton(
                    text: "See Receipt",
                    height: 45,
                    onPress: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ))).whenComplete(() {
              push(ReceiptView(receipt), context);
              if (!foundation.kIsWeb) {
                controller.resumeCamera();
              }
              result = null;
            });

          });
        }

      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<Receipt> _getReceipt(String hash) async {
    var url = Uri.parse(baseURL + 'retrieveHash');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'securityCode': 'A3D263103C27E77EF8B6267C051906C0',
        'hashCode': hash,
        'name': Receiptify.instance.customer.name,
      }),
    );
    final json = jsonDecode(response.body);
    var receipt = Receipt.fromJson(json["data"]);
    receipt.hash = hash;
    return receipt;
  }

}

class Businesses extends StatefulWidget {
  @override
  _BusinessesState createState() => _BusinessesState();
}

class _BusinessesState extends State<Businesses> {

  GlobalKey<CustomTabBarViewState> tabViewKey;
  bool isSubscription = false;
  List<String> subscribedBusinesses = [];
  List<String> unsubscribedBusinesses = [];

  @override
  void initState() {
    super.initState();
    tabViewKey = GlobalKey<CustomTabBarViewState>();
    _getSubscriptions().then((ls) {
      setState(() {
        ls.forEach((entry) {
          String bus = entry.keys.first;
          bool subbed = entry[entry.keys.first];
          if (subbed && !subscribedBusinesses.contains(bus)) {
            subscribedBusinesses.add(bus);
          } else if (!subbed && !unsubscribedBusinesses.contains(bus)) {
            unsubscribedBusinesses.add(bus);
          }
        });
        print(subscribedBusinesses.length);
        print(unsubscribedBusinesses.length);
      });
    });
  }

  Widget _initAnnouncements() {
    return Container(
      child: SafeArea(
        child: Center(
          child: Icon(Icons.mail)
        )
      )
    );
  }

  Widget _initSubscriptions() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: ListView.separated (
            itemCount: subscribedBusinesses.length + unsubscribedBusinesses.length,
            separatorBuilder: (BuildContext context, int index) => const Spacer(),
            itemBuilder: ( (context, index) {
              return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                  child: RoundCard(
                      height: 45,
                      child: Stack (
                          children: [
                            Container(
                              height: 45,
                              decoration: BoxDecoration(
                                  color: index < subscribedBusinesses.length?green:white,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                            ),
                            Center(
                                child: index < subscribedBusinesses.length?
                                  Text(subscribedBusinesses[index]) :
                                    Text(unsubscribedBusinesses[index - subscribedBusinesses.length],
                                      style: TextStyle(
                                          color: green
                                      ),
                                    ),
                            )
                          ])
                  )
              );
            }))
      )
    );
  }

  Future<List<Map<String,bool>>> _getSubscriptions() async{
    var url = getAPI(baseURL, 'getSubscriptions');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'securityCode': 'A3D263103C27E77EF8B6267C051906C0',
        'name': Receiptify.instance.customer.name,
      }),
    );

    var url2 = getAPI(baseURL, 'getBusinessList');
    var response2 = await http.post(
      url2,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String> {
        'securityCode': 'A3D263103C27E77EF8B6267C051906C0',
        'name': Receiptify.instance.customer.name,
      }),
    );

    var jsonData = jsonDecode(response.body);
    var jsonData2 = jsonDecode(response2.body);
    List<Map<String,bool>> ret = [];
    Set<String> subbedSet = <String>{};
    if(jsonData['success']) {
      (List<String>.from(jsonData['subscriptions'])).forEach((element) {
          ret.add({element: true});
          subbedSet.add(element);
      });
    }
    if(jsonData2['success']) {
      (List<String>.from(jsonData2['businessList'])).forEach((element) {
        if(!subbedSet.contains(element)) {
          ret.add({element: false});
        }
      });
    }

    return ret;
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
              SliverFillRemaining(hasScrollBody: true, child: _initAnnouncements()),
              SliverFillRemaining(hasScrollBody: true, child: _initSubscriptions()),
            ],
          ),
        ],
      ),
    );
  }

  void changePage(int page) {
    tabViewKey.currentState.changePage(page);
    setState( () => isSubscription = !isSubscription);
  }

}
