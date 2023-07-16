import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/screens/barcode_validator_screen.dart';
import 'package:flutter/material.dart';

class BarcodeRegexListTile extends StatelessWidget {
  final BarcodeConfigRegex barcode;
  final Function(BarcodeConfigRegex barcodeConfigRegex) onChanged;
  const BarcodeRegexListTile(this.barcode, {Key? key, required this.onChanged}) : super(key: key);
  _onEdit(BuildContext context) async {
    final change = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BarcodeValidatorScreen(
              barcodeConfigRegex: barcode,
            )));
    if (change is BarcodeConfigRegex) onChanged(change);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).listTileTheme.tileColor,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChipWidget(
                  barcode.name,
                  backgroundColor: Colors.green,
                  extraSize: true,
                ),
                if (barcode.start != null || barcode.stop != null) ChipWidget('pos: ${barcode.start} to ${barcode.stop}'),
              ],
            ),
            Flexible(child: ChipWidget(barcode.regexText)),
          ]),
          Flexible(
            child: Wrap(children: barcode.barcodeTypes.map((e) => ChipWidget(e.formatName)).toList()),
          ),
          ActionButtonWidget(const Icon(Icons.edit, color: Colors.white), tooltip: 'Edit validator', onPressed: () => _onEdit(context)),
        ]));
  }
}
