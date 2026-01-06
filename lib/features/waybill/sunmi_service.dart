import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class Sunmi {
  // initialize sunmi printer
  static Future<void> _initialize() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();
  }

  static Future<void> printReceipts(imageBytes) async {
    await _initialize();

    await SunmiPrinter.printImage(imageBytes);

    await SunmiPrinter.cut();
  }
}
