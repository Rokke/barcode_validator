import 'dart:io';

import 'package:barcode_validator/services/sharedpred_barcode_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing convertion from sharedpref to barcodeconfig', () {
    final org = [
      'NOProd§§EAN§[code39,code128]§^\\d{20}\$§§I2OF5§[i2of5]§^\\d{10}\$',
      'NOTest§§EAN§[code128,code39]§^00\\d{18}\$§§I2OF5§[i2of5]§^\\d{12}\$',
      File('test/test_data/noprod_barcode.txt').readAsStringSync()
    ];
    final bc = SharedPrefBarcodeService.sharedPrefsToBarcodeConfig(org);
    test('Converting a simple sharedpref to barcodeconfig', () async {
      final ret = bc.first;
      expect(ret.name, 'NOProd');
      expect(ret.barcodes.length, 2);
      expect(ret.barcodes.first.barcodeTypes, ['code39', 'code128']);
      expect(ret.barcodes.first.regex, '^\\d{20}\$');
    });
    test('Converting a simple sharedpref to barcodeconfig', () async {
      expect(bc.length, 3);
      expect(bc[1].barcodes.length, 2);
      expect(bc[1].barcodes.last.barcodeTypes, ['i2of5']);
      expect(bc[1].barcodes.last.regex, '^\\d{12}\$');
    });
    test('Checking the noprod_barcode.txt file', () async {
      expect(bc.last.barcodes.first.name, 'BUR');
      expect(bc.last.barcodes.first.barcodeTypes, ['code128', 'code39']);
      expect(bc.last.barcodes[7].name, 'DPD');
      expect(bc.last.barcodes[7].start, 8);
      expect(bc.last.barcodes[7].stop, 22);
      expect(bc.last.barcodes.length, 15);
      expect(bc.last.barcodes.last.regex, '^(J[A-Z0-9]{10,34}|[1-4]J[A-Z0-9]{9,33})\$');
    });
    test('Converting a barcodeconfig to simple sharedpref', () async {
      final ret = SharedPrefBarcodeService.barcodeConfigToSharedPrefs(bc);
      expect(ret.length, 3);
      expect(ret.first, org.first);
      expect(ret[1], org[1]);
      expect(ret.last, org.last);
    });
  });
}
