import 'package:barcode_validator/barrel.dart';
import 'package:flutter/material.dart';

class BarcodeValidatorWidget extends StatelessWidget {
  final BarcodeFormatModel barcodeFormatModel;
  final BarcodeConfigRegex barcodeConfig;
  const BarcodeValidatorWidget(this.barcodeConfig, this.barcodeFormatModel, {Key? key}) : super(key: key);
  // Widget _barcodeContainer(BuildContext context, String text, {required Color backgroundColor, required Color textColor, List<BoxShadow>? boxShadow, bool bold = false}) => Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 6),
  //     decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8), boxShadow: boxShadow),
  //     child: Text(text, style: TextStyle(color: textColor, fontWeight: bold ? FontWeight.bold : null)));
  Widget _errorBarcodeContainer(BuildContext context, String text, {bool extra = false}) => ChipWidget(
        text,
        extraSize: extra,
        // labelPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.red.withOpacity(0.45),
      );
  // _barcodeContainer(context, text, backgroundColor: Colors.red, textColor: Colors.white, boxShadow: boxShadow, bold: bold);
  Widget _okBarcodeContainer(BuildContext context, String text, {bool bold = true, bool extra = false}) => ChipWidget(
        text,
        extraSize: extra,
        backgroundColor: Colors.green.withOpacity(extra ? 0.8 : 0.65),
        icon: const Icon(
          Icons.check,
          size: 20,
        ),
      );
  // Container(
  //     margin: const EdgeInsets.only(right: 2, bottom: 1),
  //     child: _barcodeContainer(context, text, backgroundColor: Colors.green, textColor: Colors.white, boxShadow: [BoxShadow(color: Colors.green[800]!, offset: const Offset(2, 2))], bold: bold));
  @override
  Widget build(BuildContext context) {
    bool barcodeTypeOK = false, barcodeRegexOK = RegExp(barcodeConfig.regex).hasMatch(barcodeFormatModel.data);
    String value = (barcodeRegexOK) ? barcodeFormatModel.data.substring(barcodeConfig.start ?? 0, barcodeConfig.stop ?? barcodeFormatModel.data.length - 1) : '';
    final barcodeTypes = barcodeConfig.barcodeTypes.map((e) {
      if (e != barcodeFormatModel.barcodeFormatEnum) return _errorBarcodeContainer(context, e.formatName);
      barcodeTypeOK = true;
      return _okBarcodeContainer(context, e.formatName);
    }).toList();
    return LayoutBuilder(builder: (context, constraint) {
      return Card(
        margin: const EdgeInsets.all(2),
        color: (barcodeTypeOK && barcodeRegexOK) ? Colors.green.withOpacity(0.250) : Colors.red.withOpacity(0.250),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (constraint.maxWidth > 200)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  (barcodeTypeOK && barcodeRegexOK) ? _okBarcodeContainer(context, barcodeConfig.name, extra: true) : _errorBarcodeContainer(context, barcodeConfig.name, extra: true),
                  if (constraint.maxWidth > 370 && (barcodeConfig.start != null || barcodeConfig.stop != null)) Text('[${barcodeConfig.start}-${barcodeConfig.stop}]'),
                  if (constraint.maxWidth > 370) Row(mainAxisSize: MainAxisSize.min, children: barcodeTypes),
                ],
              ),
            Container(
              margin: const EdgeInsets.only(top: 2, left: 5),
              child: (constraint.maxWidth < 230)
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(child: barcodeRegexOK ? _okBarcodeContainer(context, barcodeConfig.regex, bold: false) : _errorBarcodeContainer(context, barcodeConfig.regex)),
                        if (constraint.maxWidth > 370 && value.isNotEmpty)
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
    });
  }
}
