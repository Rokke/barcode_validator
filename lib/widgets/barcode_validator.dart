import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/models/barcode_config_model.dart';
import 'package:flutter/material.dart';

class BarcodeValidatorWidget extends StatelessWidget {
  final ScanResult scanResult;
  final BarcodeConfigRegex barcodeConfig;
  const BarcodeValidatorWidget(this.barcodeConfig, this.scanResult, {Key? key}) : super(key: key);
  Widget _barcodeContainer(BuildContext context, String text, {required Color backgroundColor, required Color textColor, List<BoxShadow>? boxShadow, bool bold = false}) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8), boxShadow: boxShadow),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: bold ? FontWeight.bold : null)));
  Widget _errorBarcodeContainer(BuildContext context, String text, {List<BoxShadow>? boxShadow, bool bold = false}) =>
      _barcodeContainer(context, text, backgroundColor: Colors.red, textColor: Colors.white, boxShadow: boxShadow, bold: bold);
  Widget _okBarcodeContainer(BuildContext context, String text, {bool bold = true}) => Container(
      margin: const EdgeInsets.only(right: 2, bottom: 1),
      child: _barcodeContainer(context, text, backgroundColor: Colors.green, textColor: Colors.white, boxShadow: [BoxShadow(color: Colors.green[800]!, offset: const Offset(2, 2))], bold: bold));
  @override
  Widget build(BuildContext context) {
    bool barcodeTypeOK = false, barcodeRegexOK = RegExp(barcodeConfig.regex).hasMatch(scanResult.rawContent);
    String value = (barcodeRegexOK) ? scanResult.rawContent.substring(barcodeConfig.start ?? 0, barcodeConfig.stop ?? scanResult.rawContent.length - 1) : '';
    final barcodeTypes = barcodeConfig.barcodeTypes.map((e) {
      if (e != scanResult.format.name) return _errorBarcodeContainer(context, e.toUpperCase());
      barcodeTypeOK = true;
      return _okBarcodeContainer(context, e.toUpperCase());
    }).toList();
    return Card(
      margin: const EdgeInsets.all(2),
      color: (barcodeTypeOK && barcodeRegexOK) ? Colors.green[100] : Colors.red[100],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (barcodeTypeOK && barcodeRegexOK)
                  ? _okBarcodeContainer(context, barcodeConfig.name)
                  : _errorBarcodeContainer(context, barcodeConfig.name, boxShadow: [BoxShadow(color: Colors.red[900]!, offset: const Offset(2, 2))], bold: true),
              Row(mainAxisSize: MainAxisSize.min, children: barcodeTypes),
              if (barcodeConfig.start != null || barcodeConfig.stop != null) Text('[${barcodeConfig.start}-${barcodeConfig.stop}]'),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                barcodeRegexOK ? _okBarcodeContainer(context, barcodeConfig.regex, bold: false) : _errorBarcodeContainer(context, barcodeConfig.regex),
                if (value.isNotEmpty)
                  _okBarcodeContainer(
                    context,
                    value,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
