import 'package:barcode_validator/models/barcode_config_model.dart';
import 'package:flutter/material.dart';

class BarcodeRegexListTile extends StatelessWidget {
  final BarcodeConfigRegex barcode;
  const BarcodeRegexListTile(this.barcode, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(barcode.name),
      dense: true,
      subtitle: Text(barcode.regex),
      leading: Text(barcode.barcodeTypes.toString()),
      trailing: (barcode.start != null || barcode.stop != null) ? Text('[${barcode.start}, ${barcode.stop}]') : null,
    ));
  }
}
