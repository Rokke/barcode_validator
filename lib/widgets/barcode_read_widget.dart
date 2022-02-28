import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';

class BarcodeReadWidget extends StatelessWidget {
  final ScanResult scanResult;
  const BarcodeReadWidget(this.scanResult, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 28;
    if (scanResult.rawContent.length > 20) {
      fontSize = 12;
    } else if (scanResult.rawContent.length > 15) {
      fontSize = 20;
    }
    final textStyle = TextStyle(fontSize: fontSize, color: Theme.of(context).secondaryHeaderColor, fontFamily: 'Terminal');
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Theme.of(context).primaryColorDark,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    scanResult.format.toString().toUpperCase(),
                    style: textStyle.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Theme.of(context).primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Length: ${scanResult.rawContent.length}',
                    style: textStyle.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
            ),
          ]),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black, width: 1),
              color: Theme.of(context).primaryColorDark,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: scanResult.rawContent.runes
                  .map((e) => Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      child: Text(
                        utf8.decode([e]),
                        style: textStyle,
                      )))
                  .toList(),
            ),
          ),
          // Container(color: Colors.purple, child: Text('12345678901234567890', style: textStyle.copyWith(fontSize: 25))),
          // Container(color: Colors.indigo, child: Text('00000000000000000000', style: textStyle.copyWith(fontSize: 34))),
        ], //20*34=400*x   ... 300*x=20*25
      ),
    );
  }
}
