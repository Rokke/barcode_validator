import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/models/barcode_config_model.dart';
import 'package:barcode_validator/screens/settings_screen.dart';
import 'package:barcode_validator/services/application_config.dart';
import 'package:barcode_validator/widgets/barcode_list_validator.dart';
import 'package:barcode_validator/widgets/barcode_read_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);
  final notifierLastBarcodeScan = ValueNotifier<ScanResult?>(null);

  _onScan(ScanResult result) {
    debugPrint('_onScan($result)');
    debugPrint('result: ${result.format}, ${result.formatNote}, ${result.rawContent}, ${result.type}');
    notifierLastBarcodeScan.value = result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(providerApplicationConfig);
    final barcodeConfigs = ref.read(providerBarcodeConfig);
    // final selectedBarcodeConfigIndex = ref.watch(providerSelectedBarcodeConfig);
    final _pageController = PageController(initialPage: appConfig.lastSavedIndex, viewportFraction: barcodeConfigs.length > 1 ? 0.8 : 1);
    debugPrint('HomeScreen-build - ${appConfig.barcodeModels.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode validator'),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen(appConfig))), icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () => notifierLastBarcodeScan.value = ScanResult(type: ResultType.Barcode, rawContent: '00345678901234567890', format: BarcodeFormat.code39),
              icon: const Icon(Icons.bug_report)),
          PopupMenuButton(
            itemBuilder: (context) => barcodeConfigs.barcodeModels
                .asMap()
                .entries
                .map((entry) => PopupMenuItem<int>(
                      child: Row(
                        children: [
                          if (entry.key == _pageController.initialPage) const Icon(Icons.check, color: Colors.green),
                          const SizedBox(width: 10),
                          Text(entry.value.name),
                        ],
                      ),
                      enabled: entry.key != _pageController.initialPage,
                      value: entry.key,
                    ))
                .toList(),
            onSelected: (int? index) {
              if (index != null) {
                // barcodeConfigs.changeBarcode(index);
                _pageController.jumpToPage(index);
              }
            },
          )
        ],
      ),
      body: ValueListenableBuilder<ScanResult?>(
        valueListenable: notifierLastBarcodeScan,
        builder: (context, lastScan, _) => lastScan == null
            ? Center(
                child: Text(
                  'Scan barcode',
                  style: Theme.of(context).textTheme.headline3,
                ),
              )
            : Column(
                children: [
                  BarcodeReadWidget(lastScan),
                  Flexible(
                    child: PageView.builder(
                        onPageChanged: (index) => appConfig.changeLastIndex(index),
                        scrollDirection: Axis.horizontal,
                        itemCount: barcodeConfigs.length,
                        controller: _pageController,
                        itemBuilder: (context, index) => Container(
                              color: Theme.of(context).primaryColor.withAlpha(index.isEven ? 100 : 200),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                Card(
                                  color: Theme.of(context).colorScheme.primary.withAlpha(50),
                                  child: Center(
                                      child: Text(barcodeConfigs.barcodeModels[index].name, style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.onPrimary))),
                                ),
                                Flexible(child: BarcodeListValidatorWidget(barcodeConfigs.barcodeModels[index].barcodes, lastScan)),
                              ]),
                            )),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanBarcode(_onScan),
        child: const Icon(Icons.camera),
      ),
    );
  }
}
