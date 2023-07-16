import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart' as bc2;
import 'package:barcode_validator/barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

scanBarcode(Function(BarcodeFormatModel barcodeFormatModel) onScan, {List<BarcodeFormatEnum>? barcodeFormats}) {
  debugPrint('scanBarcode($barcodeFormats)');
  if (Platform.isWindows || kDebugMode) {
    Clipboard.getData(Clipboard.kTextPlain).then((clipData) {
      debugPrint('clip: ${clipData?.text}');
      onScan(BarcodeFormatModel(
        barcodeFormatEnum: barcodeFormats?.first ?? BarcodeFormatEnum.code128,
        data: clipData?.text ??
            (barcodeFormats?.contains(BarcodeFormatEnum.qr) != true
                ? '00375678901234567890'
                : r'§§BUR§[code128,code39]§^(BUR|KON)\d{12}$§§TGK§[i2of5]§^00[1-9]{1}\d{15}$§§MAZDA§[code128]§^DN\d{12}.{0,18}$§0§14§§ASTA§[code128]§^(C|M)[A-Z0-9]{10}\d{10}$§§VOLVO§[code128,code39,ean128]§^VO\d{11}$§§S10§[code128,code39,ean128]§^([A-Z]{2}|[0-9]{2})\d{9}[A-Z]{2}$§§EAN§[code128,ean128]§^00\d{18}$§§DPD§[code128]§^%[a-zA-Z0-9]{7}\d{20}$§8§22§§Shipment§[code128,ean128]§^((?:401)?\d{17})$§3§17§§VOLVO CARS§[code128,code39]§^0878\d{18}$§§SKF§[code39]§^(S|M|G)\d{9}$§§DPDSHORT§[]§^\d{14}$§§FORD§[code128]§^5\d{11}$§§PartloadShipment§[code39]§^\d{10}$§§DHL§[code128]§^(J[A-Z0-9]{10,34}|[1-4]J[A-Z0-9]{9,33})$'),
      ));
    });
  } else {
    bc2.BarcodeScanner.scan(options: barcodeFormats != null ? bc2.ScanOptions(restrictFormat: BarcodeFormatModel.barcodeFormatEnumListToBarcodeFormatList(barcodeFormats)) : const bc2.ScanOptions())
        .then((scanResult) => onScan(BarcodeFormatModel.fromScanResult(scanResult)));
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  final WidgetBuilder _builder;

  HeroDialogRoute({required builder, RouteSettings? settings, bool fullscreenDialog = false})
      : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);
  @override
  Color? get barrierColor => Colors.black54;
  @override
  bool get opaque => false;
  @override
  bool get barrierDismissible => true;
  @override
  String? get barrierLabel => 'Popup dialog open';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

TextFormField textInput({required TextEditingController controller, String? labelText, FocusNode? focusNode}) => TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(labelText: labelText, border: OutlineInputBorder(borderRadius: BorderRadius.circular(4))),
    );
