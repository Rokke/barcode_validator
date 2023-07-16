import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/widgets/barcode_validator.dart';
import 'package:flutter/material.dart';

class BarcodeListValidatorWidget extends StatelessWidget {
  // final List<BarcodeConfigRegex> barcodes;
  final BarcodeConfigModel barcodeConfigModel;
  final BarcodeFormatModel barcodeFormatModel;
  const BarcodeListValidatorWidget(this.barcodeConfigModel, this.barcodeFormatModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          // color: Theme.of(context).colorScheme.primary,
          child: Center(child: Text(barcodeConfigModel.name, style: Theme.of(context).textTheme.headline6!, overflow: TextOverflow.clip)),
        ),
        Flexible(
            child: ListView.builder(
          controller: _controller,
          itemBuilder: (context, index) => BarcodeValidatorWidget(
            barcodeConfigModel.barcodes[index],
            barcodeFormatModel,
          ),
          itemCount: barcodeConfigModel.barcodes.length,
        )),
      ],
    );
  }
}
