import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/models/barcode_config_model.dart';
import 'package:barcode_validator/services/sharedpred_barcode_service.dart';
import 'package:barcode_validator/widgets/action_buttons_widget.dart';
import 'package:flutter/material.dart';

class BarcodeConfigListTile extends StatefulWidget {
  final BarcodeConfigModel barcodeConfig;
  final Function()? onSelected;
  final Function(String name) onSave;
  final Function()? onDelete;
  final bool editing;
  const BarcodeConfigListTile(this.barcodeConfig, {Key? key, this.onSelected, this.editing = false, required this.onSave, this.onDelete}) : super(key: key);

  @override
  State<BarcodeConfigListTile> createState() => _BarcodeConfigListTileState();
}

class _BarcodeConfigListTileState extends State<BarcodeConfigListTile> {
  late final TextEditingController _txtController;
  late final FocusNode _focusNode;
  late bool editing;
  late String name;
  @override
  void initState() {
    editing = widget.editing;
    _focusNode = FocusNode();
    if (editing) _focusNode.requestFocus();
    name = widget.barcodeConfig.name;
    _txtController = TextEditingController(text: name);
    super.initState();
  }

  @override
  void dispose() {
    _txtController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build: $editing');
    bool isSelected = widget.onSelected == null;
    final textStyle = isSelected ? Theme.of(context).textTheme.bodyLarge : Theme.of(context).textTheme.bodyMedium;
    return Card(
        child: ListTile(
      leading: isSelected ? IconButton(onPressed: widget.onDelete, icon: const Icon(Icons.delete, color: Colors.red)) : null,
      selected: isSelected,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          editing
              ? SizedBox(
                  width: 200,
                  height: 30,
                  child: TextFormField(
                    focusNode: _focusNode,
                    controller: _txtController,
                  ))
              : Text(
                  name,
                  style: textStyle,
                ),
          if (isSelected)
            IconButton(
                onPressed: () {
                  if (editing) {
                    name = _txtController.text;
                    editing = false;
                    widget.onSave(name);
                  } else {
                    setState(() {
                      editing = true;
                    });
                  }
                },
                icon: Icon(editing ? Icons.save : Icons.edit))
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('${widget.barcodeConfig.barcodes.length}', style: textStyle),
          if (isSelected)
            ActionButtonWidget(const Icon(Icons.camera, color: Colors.white), tooltip: 'Refresh with new QR barcode, you can find this from monitorapp version >=1.2.1', onPressed: () {
              scanBarcode(
                (scanResult) {
                  widget.onSave(name);
                  widget.barcodeConfig.updateBarcodes = SharedPrefBarcodeService.stringToBarcodeModel(scanResult.rawContent).barcodes;
                },
                barcodeFormats: [BarcodeFormat.qr],
              );
            }),
        ],
      ),
      onTap: widget.onSelected,
    ));
  }
}
