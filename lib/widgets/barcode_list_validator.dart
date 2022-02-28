import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/models/barcode_config_model.dart';
import 'package:barcode_validator/widgets/barcode_validator.dart';
import 'package:flutter/material.dart';

class BarcodeListValidatorWidget extends StatelessWidget {
  final List<BarcodeConfigRegex> barcodes;
  final ScanResult scanResult;
  const BarcodeListValidatorWidget(this.barcodes, this.scanResult, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = ScrollController();
    return ListView.builder(
      controller: _controller,
      itemBuilder: (context, index) => BarcodeValidatorWidget(barcodes[index], scanResult),
      itemCount: barcodes.length,
    );
  }
}
