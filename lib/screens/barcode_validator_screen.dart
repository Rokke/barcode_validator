import 'package:barcode_validator/barrel.dart';
import 'package:flutter/material.dart';

class BarcodeValidatorScreen extends StatefulWidget {
  final BarcodeConfigRegex? barcodeConfigRegex;
  const BarcodeValidatorScreen({Key? key, required this.barcodeConfigRegex}) : super(key: key);

  @override
  State<BarcodeValidatorScreen> createState() => _BarcodeValidatorScreenState();
}

class _BarcodeValidatorScreenState extends State<BarcodeValidatorScreen> {
  late final BarcodeConfigRegex current;
  late final TextEditingController _txtName, _txtRegex, _txtStart, _txtStop;
  final List<BarcodeFormatEnum> lstUnselected = BarcodeFormatEnum.values.where((e) => e != BarcodeFormatEnum.unknown).toList(), lstSelected = [];
  @override
  void initState() {
    if (widget.barcodeConfigRegex != null) {
      for (var stringBarcodeFormat in widget.barcodeConfigRegex!.barcodeTypes) {
        _addToSelected(stringBarcodeFormat);
      }
      current = widget.barcodeConfigRegex!.copyWith();
    } else {
      current = BarcodeConfigRegex(name: '', barcodeTypes: [], regex: '^\\d{20}\$', start: null, stop: null);
    }
    _txtName = TextEditingController(text: current.name);
    _txtRegex = TextEditingController(text: current.regex);
    _txtStart = TextEditingController(text: current.start?.toString() ?? '');
    _txtStop = TextEditingController(text: current.stop?.toString() ?? '');
    super.initState();
  }

  _addToSelected(BarcodeFormatEnum barcodeFormatEnum) {
    setState(() {
      lstUnselected.remove(barcodeFormatEnum);
      lstSelected.add(barcodeFormatEnum);
    });
  }

  _addToUnselected(BarcodeFormatEnum barcodeFormatEnum) {
    setState(() {
      lstSelected.remove(barcodeFormatEnum);
      lstUnselected.add(barcodeFormatEnum);
    });
  }

  @override
  void dispose() {
    _txtName.dispose();
    _txtRegex.dispose();
    _txtStart.dispose();
    _txtStop.dispose();
    super.dispose();
  }

  Widget _listItem(String caption, List<BarcodeFormatEnum> lst, {Color? colorBackground, Color? colorText}) {
    colorBackground ??= Theme.of(context).colorScheme.primary;
    colorText ??= Theme.of(context).colorScheme.onPrimary;
    return Flexible(
      child: Card(
          child: Container(
        margin: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: colorBackground.withAlpha(50),
              ),
              alignment: Alignment.center,
              child: Text(
                caption,
                style: Theme.of(context).textTheme.headline6!,
              ),
            ),
            const SizedBox(height: 2),
            Flexible(
                child: Container(
                    color: colorBackground.withAlpha(100),
                    child: ListView.builder(
                        itemCount: lst.length,
                        itemBuilder: (context, index) => Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(3),
                            child: InkWell(
                              onTap: () => lst == lstUnselected ? _addToSelected(lst[index]) : _addToUnselected(lst[index]),
                              child: ChipWidget(lst[index].formatName, extraSize: true, backgroundColor: colorBackground!.withAlpha(50)),
                            ))))),
          ],
        ),
      )),
    );
  }

  _save() {
    debugPrint('_save()');
    Navigator.of(context).pop(BarcodeConfigRegex(
        name: _txtName.text,
        regex: _txtRegex.text,
        barcodeTypes: lstSelected,
        start: _txtStart.text.isEmpty ? null : int.tryParse(_txtStart.text),
        stop: _txtStop.text.isEmpty ? null : int.tryParse(_txtStop.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode validator'),
        actions: [
          IconButton(onPressed: _save, icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          textInput(controller: _txtName, labelText: 'Name:'),
          const SizedBox(height: 8),
          textInput(controller: _txtRegex, labelText: 'Regex:'),
          const SizedBox(height: 8),
          Flexible(
            child: Row(
              children: [
                _listItem('Unselected', lstUnselected, colorBackground: Theme.of(context).colorScheme.error),
                _listItem('Selected', lstSelected),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Flexible(child: textInput(controller: _txtStart, labelText: 'Start index:')),
              const SizedBox(width: 8),
              Flexible(child: textInput(controller: _txtStop, labelText: 'Stop index:')),
            ],
          ),
        ]),
      ),
    );
  }
}
