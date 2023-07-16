import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/screens/barcode_validator_screen.dart';
import 'package:barcode_validator/services/sharedpred_barcode_service.dart';
import 'package:barcode_validator/widgets/barcode_config_listtile.dart';
import 'package:barcode_validator/widgets/barcode_regex_listtile.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  final ApplicationConfig appConfig;
  const SettingsScreen(this.appConfig, {Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final selectedBarcode = ValueNotifier(-1);
  late final List<BarcodeConfigModel> barcodes;
  bool changes = false;
  int editProfile = -1;

  final _profileController = ScrollController(), _barcodeController = ScrollController();
  @override
  void initState() {
    barcodes = widget.appConfig.barcodeModels;
    super.initState();
  }

  Future<bool> _checkIfExit() async {
    debugPrint('_checkIfExit($changes)');
    if (changes) {
      final resp = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  'Discard changes?',
                  style: Theme.of(context).textTheme.headline6,
                ),
                content: const Text('There are changes made!\nAre you sure that you want to discard these?'),
                actions: [
                  ElevatedButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                  ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('OK')),
                ],
              ));
      if (resp != true) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Settings-build');
    return WillPopScope(
      onWillPop: () => _checkIfExit(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            actions: [
              IconButton(
                  onPressed: changes
                      ? () {
                          widget.appConfig.save(barcodes);
                          Navigator.of(context).pop();
                        }
                      : null,
                  icon: const Icon(Icons.save)),
            ],
          ),
          body: ValueListenableBuilder<int>(
              valueListenable: selectedBarcode,
              builder: (context, selected, _) {
                if (editProfile != selectedBarcode.value) editProfile = -1;
                debugPrint('edit: $editProfile, ${selectedBarcode.value}');
                final selectedBarcodeConfig = selected > -1 ? barcodes[selected] : null;
                return Column(children: [
                  Flexible(
                      child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Profiles:',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              ActionButtonWidget(
                                const Icon(Icons.add, color: Colors.white),
                                tooltip: 'Create new profile',
                                onPressed: () {
                                  barcodes.add(BarcodeConfigModel('', []));
                                  setState(() {
                                    selectedBarcode.value = editProfile = barcodes.length - 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: ListView.builder(
                            controller: _profileController,
                            itemBuilder: (context, index) => BarcodeConfigListTile(
                              barcodes[index],
                              onSelected: selected == index ? null : () => selectedBarcode.value = index,
                              onSave: (name) => setState(() {
                                changes = true;
                                barcodes[index].name = name;
                              }),
                              editing: editProfile == index,
                              onDelete: () => setState(() {
                                changes = true;
                                selectedBarcode.value--;
                                barcodes.removeAt(index);
                              }),
                            ),
                            itemCount: barcodes.length,
                          ),
                        ),
                      ],
                    ),
                  )),
                  if (selectedBarcodeConfig != null)
                    SizedBox(
                      height: 400,
                      child: Card(
                        // color: Theme.of(context).colorScheme.primaryContainer,
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Barcodes:',
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                  ActionButtonWidget(
                                    const Icon(Icons.share, color: Colors.white),
                                    tooltip: 'Share setting',
                                    onPressed: () {
                                      Navigator.of(context).push(HeroDialogRoute(
                                          builder: (context) => Center(
                                                child: Container(
                                                  color: Colors.white,
                                                  width: 300,
                                                  height: 300,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(40.0),
                                                    child: QrImage(data: SharedPrefBarcodeService.barcodeModelToString(selectedBarcodeConfig)),
                                                  ),
                                                ),
                                              )));
                                    },
                                  ),
                                  ActionButtonWidget(
                                    const Icon(Icons.add, color: Colors.white),
                                    tooltip: 'Add new barcode validator',
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(HeroDialogRoute(builder: (context) => MaterialPageRoute(builder: (context) => const BarcodeValidatorScreen(barcodeConfigRegex: null))));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                                child: ListView.builder(
                              controller: _barcodeController,
                              itemBuilder: (context, index) => BarcodeRegexListTile(selectedBarcodeConfig.barcodes[index],
                                  onChanged: (barcodeConfigRegex) => setState(() {
                                        selectedBarcodeConfig.replaceBarcodeConfigRegex(index, barcodeConfigRegex);
                                      })),
                              itemCount: selectedBarcodeConfig.length,
                            )),
                          ],
                        ),
                      ),
                    ),
                  // if (selectedBarcodeConfig != null)
                  //   Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: SizedBox(height: 200, child: QrImage(data: SharedPrefBarcodeService.barcodeModelToString(selectedBarcodeConfig))),
                  //   ),
                  // if (kDebugMode && selectedBarcodeConfig != null) Text(SharedPrefBarcodeService.barcodeModelToString(selectedBarcodeConfig)),
                ]);
              })),
    );
  }
}
