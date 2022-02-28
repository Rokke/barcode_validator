import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/models/barcode_config_model.dart';
import 'package:barcode_validator/services/application_config.dart';
import 'package:barcode_validator/services/sharedpred_barcode_service.dart';
import 'package:barcode_validator/widgets/action_buttons_widget.dart';
import 'package:barcode_validator/widgets/barcode_config_listtile.dart';
import 'package:barcode_validator/widgets/barcode_regex_listtile.dart';
import 'package:flutter/foundation.dart';
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
  int editProfile = -1;

  final _profileController = ScrollController(), _barcodeController = ScrollController();
  @override
  void initState() {
    barcodes = widget.appConfig.barcodeModels;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Settings-build');
    // final appConfig = ref.watch(providerApplicationConfig);
    // final barcodes = ref.read(providerBarcodeConfig).barcodeModels;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: [
            IconButton(
                onPressed: () {
                  widget.appConfig.save(barcodes);
                  Navigator.of(context).pop();
                },
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
                if (kDebugMode)
                  ElevatedButton(
                      onPressed: () {
                        ref.read(providerBarcodeConfig).addNewBarcodeConfig(SharedPrefBarcodeService.sharedPrefsToBarcodeConfig([
                              r'§§BUR§[code128,code39]§^(BUR|KON)\d{12}$§§TGK§[i2of5]§^00[1-9]{1}\d{15}$§§MAZDA§[code128]§^DN\d{12}.{0,18}$§0§14§§ASTA§[code128]§^(C|M)[A-Z0-9]{10}\d{10}$§§VOLVO§[code128,code39,ean128]§^VO\d{11}$§§S10§[code128,code39,ean128]§^([A-Z]{2}|[0-9]{2})\d{9}[A-Z]{2}$§§EAN§[code128,ean128]§^00\d{18}$§§DPD§[code128]§^%[a-zA-Z0-9]{7}\d{20}$§8§22§§Shipment§[code128,ean128]§^((?:401)?\d{17})$§3§17§§VOLVO CARS§[code128,code39]§^0878\d{18}$§§SKF§[code39]§^(S|M|G)\d{9}$§§DPDSHORT§[]§^\d{14}$§§FORD§[code128]§^5\d{11}$§§PartloadShipment§[code39]§^\d{10}$§§DHL§[code128]§^(J[A-Z0-9]{10,34}|[1-4]J[A-Z0-9]{9,33})$',
                              'NOProd§§EAN§[CODE39,CODE128]§^\\d{20}\$§§I2OF5§[I2OF5]§^\\d{10}\$',
                              'NOTest§§EAN§[CODE128,CODE39]§^00\\d{18}\$§§I2OF5§[I2OF5]§^\\d{12}\$'
                            ]).first);
                      },
                      child: const Text('Read')),
                Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: SizedBox(
                      height: 200,
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
                                  style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
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
                                  barcodes[index].name = name;
                                }),
                                editing: editProfile == index,
                                onDelete: () => setState(() {
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
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: SizedBox(
                      height: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Barcodes:',
                                  style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
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
                              ],
                            ),
                          ),
                          Flexible(
                              child: ListView.builder(
                            controller: _barcodeController,
                            itemBuilder: (context, index) => BarcodeRegexListTile(selectedBarcodeConfig.barcodes[index]),
                            itemCount: selectedBarcodeConfig.length,
                          )),
                        ],
                      ),
                    ),
                  ),
                if (selectedBarcodeConfig != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(height: 200, child: QrImage(data: SharedPrefBarcodeService.barcodeModelToString(selectedBarcodeConfig))),
                  ),
                if (kDebugMode && selectedBarcodeConfig != null) Text(SharedPrefBarcodeService.barcodeModelToString(selectedBarcodeConfig)),
              ]);
            }));
  }
}
