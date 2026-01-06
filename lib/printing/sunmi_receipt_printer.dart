import 'dart:typed_data';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class SunmiReceiptData {
  const SunmiReceiptData({
    required this.shopName,
    required this.shopPhone,
    required this.customerName,
    required this.customerPhone,
    required this.expressCompany,
    required this.expressBranch,
    this.feeController,
  });

  final String shopName;
  final String shopPhone;

  final String customerName;
  final String customerPhone;

  final String expressCompany;
  final String expressBranch;
  final String? feeController;
}

class SunmiReceiptPrinter {
  const SunmiReceiptPrinter();

  static final _dateFormat = DateFormat('yyyy-MM-dd HH:mm', 'lo_LA');

  Future<void> printWaybillReceipt({
    required SunmiReceiptData data,
    String logoAssetPath = 'assets/img/logo.png',
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('Sunmi printer works on Android only');
    }

    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.initPrinter();

    await SunmiPrinter.startTransactionPrint(true);

    try {
      // try {
      //   final logoBytes = await _readAssetBytes(logoAssetPath);
      //   // Print logo with reduced size
      //   await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      //   await SunmiPrinter.printImage(
      //       logoBytes); // Default size is already small
      //   await SunmiPrinter.lineWrap(1);
      // } catch (e) {
      //   // Logo couldn't be loaded, continue without printing logo
      //   print('Warning: Logo image not found: $e');
      // }

      await SunmiPrinter.printText(
        'Nkauj Hnub Thor',
        style: SunmiTextStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
          fontSize: 20, // Smaller font size
        ),
      );

      await SunmiPrinter.lineWrap(2);

      await SunmiPrinter.printText(
        'ຊື່ຜູ້ສົ່ງ: ${data.shopName}',
        style: SunmiTextStyle(
          bold: true,

          fontSize: 16, // Smaller font size
        ),
      );
      await SunmiPrinter.printText(
        'ເບີຜູ້ສົ່ງ: ${_formatPhoneNumber(data.shopPhone)}',
        style: SunmiTextStyle(
          fontSize: 16, // Smaller font size
        ),
      );

      await SunmiPrinter.line();

      // await _row(label: 'ວັນທີ', value: _dateFormat.format(DateTime.now()));
      await SunmiPrinter.lineWrap(1);

      // await SunmiPrinter.printText(
      //   'ຂໍ້ມູນລູກຄ້າ',
      //   style: SunmiTextStyle(bold: true, fontSize: 16),
      // );

      await SunmiPrinter.printText(
        'ຊື່ຜູ້ຮັບ: ${data.customerName}',
        style: SunmiTextStyle(bold: true, fontSize: 16),
      );

      await SunmiPrinter.printText(
        'ເບີຜູ້ຮັບ: ${_formatPhoneNumber(data.customerPhone)}',
        style: SunmiTextStyle(bold: true, fontSize: 16),
      );

      // await _row(label: 'ຊື່', value: data.customerName);
      // await _row(label: 'ເບີ', value: data.customerPhone);

      await SunmiPrinter.lineWrap(1);

      await SunmiPrinter.printText(
        'COD: ${data.feeController} ກີບ',
        style: SunmiTextStyle(bold: true, fontSize: 16),
      );

      // await SunmiPrinter.printText(
      //   'ບໍລິສັດຂົນສົ່ງ',
      //   style: SunmiTextStyle(bold: true, fontSize: 16),
      // );

      // await SunmiPrinter.printText(
      //   'ບໍລິສັດ: ${data.expressCompany}',
      //   style: SunmiTextStyle(bold: true, fontSize: 16),
      // );

      await SunmiPrinter.printText(
        'ສາຂາ: ${data.expressBranch}',
        style: SunmiTextStyle(bold: true, fontSize: 16),
      );

      // await _row(label: 'ບໍລິສັດ', value: data.expressCompany);
      // await _row(label: 'ສາຂາ', value: data.expressBranch);

      await SunmiPrinter.line();
      await SunmiPrinter.lineWrap(2);
      await SunmiPrinter.printText(
        'ບໍລິສັດຂົນສົ່ງ: ${data.expressCompany}',
        style: SunmiTextStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: 16, // Smaller font size
        ),
      );
      await SunmiPrinter.line();
      await SunmiPrinter.lineWrap(2);

      await SunmiPrinter.printText(
        '',
        style: SunmiTextStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: 16, // Smaller font size
        ),
      );

      await SunmiPrinter.printQRCode(
          'https://www.facebook.com/hlublosmobtsolosncothoj.hlublosmoblosncothoj',
          style: SunmiQrcodeStyle(
            qrcodeSize: 3,
            errorLevel: SunmiQrcodeLevel.LEVEL_H,
          ));

      await SunmiPrinter.printText(
        '',
        style: SunmiTextStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: 16, // Smaller font size
        ),
      );

      await SunmiPrinter.lineWrap(3);
      await SunmiPrinter.line();
      await SunmiPrinter.printText(
        'Thank You',
        style: SunmiTextStyle(
          bold: true,
          align: SunmiPrintAlign.CENTER,
          fontSize: 18, // Smaller font size
        ),
      );

      await SunmiPrinter.printText(
        '',
        style: SunmiTextStyle(
          align: SunmiPrintAlign.CENTER,
          fontSize: 16, // Smaller font size
        ),
      );

      await SunmiPrinter.lineWrap(3);
      await SunmiPrinter.cutPaper();
    } finally {
      await SunmiPrinter.exitTransactionPrint(true);
    }
  }

  static Future<void> _row(
      {required String label, required String value}) async {
    await SunmiPrinter.printRow(
      cols: [
        SunmiColumn(
            text: '$label:', width: 6, style: SunmiTextStyle(fontSize: 16)),
        SunmiColumn(
            text: value, width: 16, style: SunmiTextStyle(fontSize: 16)),
      ],
    );
  }

  static Future<Uint8List> _readAssetBytes(String path) async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

  // Format phone number as 020-XXXX-XXXX
  static String _formatPhoneNumber(String phone) {
    // Remove any non-digit characters
    String digits = phone.replaceAll(RegExp(r'\D'), '');

    // If the phone number already has the correct format, return it
    if (phone.contains('-')) {
      return phone;
    }

    // Format as 020-XXXX-XXXX if it has enough digits
    if (digits.length >= 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    }

    // Return original if we can't format it
    return phone;
  }
}
