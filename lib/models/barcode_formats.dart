import 'package:barcode_scan2/barcode_scan2.dart' as bc2;
import 'package:flutter/foundation.dart';

class BarcodeFormatModel {
  BarcodeFormatEnum barcodeFormatEnum;
  String data;
  BarcodeFormatModel({required this.barcodeFormatEnum, required this.data});
  factory BarcodeFormatModel.fromScanResult(bc2.ScanResult scanResult) {
    if (scanResult.formatNote.isNotEmpty) debugPrint('FormatNote: ${scanResult.formatNote}');
    return BarcodeFormatModel(barcodeFormatEnum: scanResultFormatToBarcodeFormatEnum(scanResult.format, scanResult.formatNote), data: scanResult.rawContent);
  }
  @override
  String toString() => 'BarcodeFormat(${barcodeFormatEnum.formatName},$data)';

  static BarcodeFormatEnum scanResultFormatToBarcodeFormatEnum(bc2.BarcodeFormat barcodeFormat, String formatNote) {
    switch (barcodeFormat) {
      case bc2.BarcodeFormat.aztec:
        return BarcodeFormatEnum.aztec;
      case bc2.BarcodeFormat.code128:
        return formatNote == 'EAN128' ? BarcodeFormatEnum.ean128 : BarcodeFormatEnum.code128;
      case bc2.BarcodeFormat.code39:
        return BarcodeFormatEnum.code39;
      case bc2.BarcodeFormat.code93:
        return BarcodeFormatEnum.code93;
      case bc2.BarcodeFormat.dataMatrix:
        return BarcodeFormatEnum.dataMatrix;
      case bc2.BarcodeFormat.ean13:
        return BarcodeFormatEnum.ean13;
      case bc2.BarcodeFormat.ean8:
        return BarcodeFormatEnum.ean8;
      case bc2.BarcodeFormat.interleaved2of5:
        return BarcodeFormatEnum.i2of5;
      case bc2.BarcodeFormat.pdf417:
        return BarcodeFormatEnum.pdf417;
      case bc2.BarcodeFormat.qr:
        return BarcodeFormatEnum.qr;
      case bc2.BarcodeFormat.upce:
        return BarcodeFormatEnum.upce;
      case bc2.BarcodeFormat.unknown:
      default:
        debugPrint('Unknown barcode format: $barcodeFormat');
        return BarcodeFormatEnum.unknown;
    }
  }

  static bc2.BarcodeFormat barcodeFormatEnumToBarcodeFormat(BarcodeFormatEnum barcodeFormatEnum) {
    switch (barcodeFormatEnum) {
      case BarcodeFormatEnum.unknown:
        return bc2.BarcodeFormat.unknown;
      case BarcodeFormatEnum.aztec:
        return bc2.BarcodeFormat.aztec;
      case BarcodeFormatEnum.code39:
        return bc2.BarcodeFormat.code39;
      case BarcodeFormatEnum.code128:
      case BarcodeFormatEnum.ean128:
        return bc2.BarcodeFormat.code128;
      case BarcodeFormatEnum.code93:
        return bc2.BarcodeFormat.code93;
      case BarcodeFormatEnum.dataMatrix:
        return bc2.BarcodeFormat.dataMatrix;
      case BarcodeFormatEnum.ean13:
        return bc2.BarcodeFormat.ean13;
      case BarcodeFormatEnum.ean8:
        return bc2.BarcodeFormat.ean8;
      case BarcodeFormatEnum.i2of5:
        return bc2.BarcodeFormat.interleaved2of5;
      case BarcodeFormatEnum.pdf417:
        return bc2.BarcodeFormat.pdf417;
      case BarcodeFormatEnum.qr:
        return bc2.BarcodeFormat.qr;
      case BarcodeFormatEnum.upce:
        return bc2.BarcodeFormat.upce;
    }
  }

  static List<bc2.BarcodeFormat> barcodeFormatEnumListToBarcodeFormatList(List<BarcodeFormatEnum> barcodeFormatEnumList) => barcodeFormatEnumList.map(barcodeFormatEnumToBarcodeFormat).toList();
  static BarcodeFormatEnum stringToBarcodeFormatEnum(String barcodeFormat) {
    switch (barcodeFormat.toLowerCase().split('.').last) {
      case "aztec":
        return BarcodeFormatEnum.aztec;
      case "code128":
        return BarcodeFormatEnum.code128;
      case "code39":
        return BarcodeFormatEnum.code39;
      case "code93":
        return BarcodeFormatEnum.code93;
      case "dataMatrix":
        return BarcodeFormatEnum.dataMatrix;
      case "ean128":
        return BarcodeFormatEnum.ean128;
      case "ean13":
        return BarcodeFormatEnum.ean13;
      case "ean8":
        return BarcodeFormatEnum.ean8;
      case "i2of5":
      case "interleaved2of5":
        return BarcodeFormatEnum.i2of5;
      case "pdf417":
        return BarcodeFormatEnum.pdf417;
      case "qr":
      case "qrcode":
        return BarcodeFormatEnum.qr;
      case "upce":
        return BarcodeFormatEnum.upce;
      default:
        debugPrint('Unknown barcode format: $barcodeFormat');
        return BarcodeFormatEnum.unknown;
    }
  }
}

enum BarcodeFormatEnum {
  unknown,
  aztec,
  code39,
  code128,
  code93,
  dataMatrix,
  ean128,
  ean13,
  ean8,
  i2of5,
  pdf417,
  qr,
  upce,
}

extension OnBarcodeFormatEnum on BarcodeFormatEnum {
  String get formatName => toString().split('.').last.toUpperCase();
}
