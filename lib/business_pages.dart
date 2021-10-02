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

class CreateReceipt extends StatefulWidget {

  @override
  _CreateReceiptState createState() => _CreateReceiptState();
}

class _CreateReceiptState extends State<CreateReceipt> {

  List<Product> productsOrdered = [];
  List<Coupon> couponsMade = [];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          SliverNavigationBar("Create Receipt"),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(edge_padding),
              child: Column(
                children: verticalSpace(card_spacing, [
                  productsOrdered.isNotEmpty ? _orderCard() : null,
                  ...(couponsMade.isNotEmpty ? couponsMade.map((coupon) => _couponCard(coupon)).toList() : []),
                  productsOrdered.isNotEmpty ? _createReceiptButton() : null,
                  ...Receiptify.instance.business.products.map((product) => _productCard(product)).toList(),
                  _addProductButton(),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderCard() {
    return GestureDetector(
      onTap: () async {
        final coupon = await showCustomDialog<Coupon>(context, CustomDialog("Add Coupon", AddCoupon()));
        couponsMade.add(coupon);
        setState(() {});
      },
      child: RoundCard(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 35,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
              ),
              child: Center(
                child: Text("+ Add Coupon"),
              ),
            ),
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
                          Text(Receiptify.instance.business.name, style: TextStyle(color: title, fontSize: 20),),
                          Text(currentDateString(), style: TextStyle(color: subtitle, fontSize: 15),),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("\$${(calculateTotal() * 1.06).toStringAsFixed(2)}", style: TextStyle(color: white, fontSize: 16),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  ...verticalSpace(10, productsOrdered.map<Widget>((product) => Row(
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
                  SizedBox(height: 32,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _couponCard(Coupon coupon) {
    return RoundCard(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: horizontal_margin),
        child: Row(
          children: [
            Text(coupon.details, style: TextStyle(color: title, fontSize: 16),),
            Spacer(),
            Text(coupon.expirationDate, style: TextStyle(color: subtitle, fontSize: 16),)
          ],
        ),
      ),
    );
  }

  Widget _createReceiptButton() {
    return RoundCard(
      child: Padding(
        padding: const EdgeInsets.all(horizontal_margin),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            RoundButton(
              height: 45,
              text: "Create Receipt",
              onPress: () {
                final receipt = Receipt(
                  dateIssued: currentDateString(),
                  businessName: Receiptify.instance.business.name,
                  address: Receiptify.instance.business.address,
                  phone: Receiptify.instance.business.phone,
                  subtotal: calculateTotal(),
                  total: calculateTotal() * 1.06,
                  order: productsOrdered,
                  coupons: couponsMade,
                );
                // TODO get hash for receipt
                showCustomDialog<String>(context, CustomDialog("Receipt", ShowQrCode("RECEIPT HASH")));
              },
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
      ),
    );
  }

  Widget _productCard(Product product) {
    return GestureDetector(
      onTap: () async {
        final p = await showCustomDialog<Product>(context, CustomDialog("Select Product", SelectProduct(product)));
        productsOrdered.add(p);
        setState(() {});
      },
      child: RoundCard(
        height: 64,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontal_margin),
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
                  child: Text("+", style: TextStyle(color: white, fontSize: 14),),
                ),
              ),
              SizedBox(width: 8,),
              Text(product.name, style: TextStyle(color: title, fontSize: 16),),
              Spacer(),
              Text("\$${product.price}", style: TextStyle(color: green, fontSize: 16),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _addProductButton() {
    return RoundCard(
      child: Padding(
        padding: const EdgeInsets.all(horizontal_margin),
        child: RoundButton(
          height: 45,
          text: "Add Product",
          onPress: () async {
            final product = await showCustomDialog<Product>(context, CustomDialog("Add Product", AddProduct()));
            Receiptify.instance.business.products.add(product);
            setState(() {});
          },
        ),
      ),
    );
  }

  double calculateTotal() {
    double sum = 0;
    for (Product p in productsOrdered) {
      sum += p.price * p.quantity;
    }
    return sum;
  }

}

class AddProduct extends StatelessWidget {

  final DialogTextController nameController;
  final DialogTextController priceController;

  AddProduct() : nameController = DialogTextController(), priceController = DialogTextController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DialogTextField(
          controller: nameController,
          placeholder: "Name",
        ),
        SizedBox(height: item_spacing),
        DialogTextField(
          controller: priceController,
          placeholder: "Price",
        ),
        SizedBox(height: item_spacing),
        RoundButton(
          text: "Done",
          height: 42,
          onPress: () {
            Navigator.of(context).pop(Product(
              nameController.text,
              double.parse(priceController.text),
              1,
            ));
          },
        )
      ],
    );
  }

}

class SelectProduct extends StatelessWidget {

  final Product product;
  final DialogTextController countController;

  SelectProduct(this.product) : countController = DialogTextController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DialogTextField(
          controller: countController,
          placeholder: "Count",
        ),
        SizedBox(height: item_spacing),
        RoundButton(
          text: "Done",
          height: 42,
          onPress: () {
            Navigator.of(context).pop(Product(
              product.name,
              product.price,
              int.parse(countController.text),
            ));
          },
        )
      ],
    );
  }
}

class AddCoupon extends StatelessWidget {

  final DialogTextController detailsController;
  final DialogTextController expirationController;

  AddCoupon() : detailsController = DialogTextController(), expirationController = DialogTextController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DialogTextField(
          controller: detailsController,
          placeholder: "Details",
        ),
        SizedBox(height: item_spacing),
        DialogTextField(
          controller: expirationController,
          placeholder: "Expiration",
        ),
        SizedBox(height: item_spacing),
        RoundButton(
          text: "Done",
          height: 42,
          onPress: () {
            Navigator.of(context).pop(Coupon(
              details: detailsController.text,
              expirationDate: expirationController.text,
            ));
          },
        )
      ],
    );
  }
}
