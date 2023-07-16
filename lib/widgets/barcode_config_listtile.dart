import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/services/sharedpred_barcode_service.dart';
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
    return InkWell(
      child: Card(
        color: isSelected ? Theme.of(context).listTileTheme.selectedTileColor : Theme.of(context).listTileTheme.tileColor,
        child: Row(
          children: [
            if (isSelected) IconButton(onPressed: widget.onDelete, icon: const Icon(Icons.delete, color: Colors.red)),
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                editing
                    ? Flexible(child: textInput(controller: _txtController, focusNode: _focusNode, labelText: 'Name:'))
                    : Flexible(
                        child: Text(
                        name,
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                      )),
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
                          _focusNode.requestFocus();
                        }
                      },
                      icon: Icon(editing ? Icons.save : Icons.edit)),
              ],
            )),
            Text('${widget.barcodeConfig.barcodes.length}', style: textStyle),
            if (isSelected)
              ActionButtonWidget(const Icon(Icons.camera, color: Colors.white), tooltip: 'Refresh with new QR barcode, you can find this from monitorapp version >=1.2.1', onPressed: () {
                scanBarcode(
                  (barcodeFormatModel) {
                    widget.onSave(name);
                    final barcodeModel = SharedPrefBarcodeService.stringToBarcodeModel(barcodeFormatModel.data);
                    if (barcodeModel != null) {
                      if (widget.barcodeConfig.name.isEmpty && barcodeModel.name.isNotEmpty) {
                        _txtController.text = barcodeModel.name;
                        _focusNode.requestFocus();
                        debugPrint('!empty: ${widget.barcodeConfig.name}');
                      } else {
                        debugPrint('empty: ${barcodeModel.name}');
                      }
                      widget.barcodeConfig.updateBarcodes = barcodeModel.barcodes;
                    } else {
                      debugPrint('Invalid barcodeconfig');
                    }
                  },
                  barcodeFormats: [BarcodeFormatEnum.qr],
                );
              }),
          ],
        ),
      ),
      onTap: widget.onSelected,
    );
  }
}
