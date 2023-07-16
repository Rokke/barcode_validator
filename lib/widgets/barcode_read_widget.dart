import 'dart:convert';

import 'package:barcode_validator/barrel.dart';
import 'package:flutter/material.dart';

class BarcodeReadWidget extends StatelessWidget {
  final BarcodeFormatModel barcodeFormatModel;
  const BarcodeReadWidget(this.barcodeFormatModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = ((barcodeFormatModel.data.length > 19)
            ? Theme.of(context).textTheme.headline6
            : barcodeFormatModel.data.length > 14
                ? Theme.of(context).textTheme.headline5
                : Theme.of(context).textTheme.headline4)!
        .copyWith(fontFamily: 'Terminal');
    //00345678901234567890
    // final textStyle = ;
    final colorRuneBackground = Theme.of(context).colorScheme.primaryContainer;
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
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    barcodeFormatModel.barcodeFormatEnum.formatName,
                    style: Theme.of(context).textTheme.headline6, //.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black, width: 1),
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    'Length: ${barcodeFormatModel.data.length}',
                    style: Theme.of(context).textTheme.headline6, //.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
            ),
          ]),
          Container(
            constraints: const BoxConstraints.expand(height: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.black, width: 1),
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                // mainAxisAlignment: MainAxisAlignment.center,
                itemBuilder: (context, index) => //barcodeFormatModel.data.runes
                    Container(
                        decoration: BoxDecoration(border: Border.all(), color: colorRuneBackground),
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Center(
                          child: Text(
                            utf8.decode([barcodeFormatModel.data.runes.elementAt(index)]),
                            style: textStyle,
                            // textAlign: TextAlign.center,
                          ),
                        )),
                itemCount: barcodeFormatModel.data.runes.length,
              ),
            ),
          ),
          // Container(color: Colors.purple, child: Text('1234567890123456789000000000000000000000', style: textStyle.copyWith(fontSize: 25))),
          // Container(color: Colors.indigo, child: Text('', style: textStyle.copyWith(fontSize: 34))),
        ], //20*34=400*x   ... 300*x=20*25
      ),
    );
  }
}
