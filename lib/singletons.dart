import 'data_classes.dart';

class ReceiptManager {
  static final ReceiptManager _instance = ReceiptManager._internal();
  List<Receipt> currentReceipts;

  factory ReceiptManager() {
    return _instance;
  }

  ReceiptManager._internal() {
    currentReceipts = [];
  }

  List<Receipt> getReceipts() {
    return currentReceipts;
  }

  void addReceipt(Receipt r) {
    currentReceipts.add(r);
  }
}