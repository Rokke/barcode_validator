import 'package:barcode_validator/barrel.dart';
import 'package:barcode_validator/screens/settings_screen.dart';
import 'package:barcode_validator/widgets/barcode_validator_pageview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerWidget {
  HomeScreen({Key? key}) : super(key: key);
  final notifierLastBarcodeScan = ValueNotifier<BarcodeFormatModel?>(kDebugMode ? BarcodeFormatModel(barcodeFormatEnum: BarcodeFormatEnum.code128, data: '00234567890123456789') : null);

  _onScan(BarcodeFormatModel result) {
    debugPrint('_onScan($result)');
    debugPrint('result: ${result.barcodeFormatEnum}, ${result.data}');
    notifierLastBarcodeScan.value = result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appConfig = ref.watch(providerApplicationConfig);
    final barcodeConfigs = ref.read(providerBarcodeConfig);
    // final selectedBarcodeConfigIndex = ref.watch(providerSelectedBarcodeConfig);
    final _pageController = PageController(initialPage: appConfig.lastSavedIndex, viewportFraction: barcodeConfigs.length > 1 ? 1 : 1);
    debugPrint('HomeScreen-build - ${appConfig.barcodeModels.length}->${MediaQuery.of(context).size}'); //392.7, 834.9
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Barcode validator'),
            if (!kDebugMode)
              Text(
                'version: ${appConfig.versionName}',
                style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.white),
              ),
          ],
        ),
        actions: [
          IconButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen(appConfig))), icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () => notifierLastBarcodeScan.value = BarcodeFormatModel(barcodeFormatEnum: BarcodeFormatEnum.code128, data: '012345678901234567890123'), icon: const Icon(Icons.bug_report)),
          PopupMenuButton(
            itemBuilder: (context) => barcodeConfigs.barcodeModels
                .asMap()
                .entries
                .map((entry) => PopupMenuItem<int>(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (entry.key == _pageController.initialPage) const Icon(Icons.check, color: Colors.green),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              entry.value.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
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
      body: ValueListenableBuilder<BarcodeFormatModel?>(
        valueListenable: notifierLastBarcodeScan,
        builder: (context, lastScan, _) => lastScan == null
            ? Center(
                child: Text(
                  'Scan barcode',
                  style: Theme.of(context).textTheme.headline3,
                ),
              )
            : BarcodeValidatorPageViewer(appConfig: appConfig, barcodeConfigs: barcodeConfigs, pageController: _pageController, lastScan: lastScan),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => scanBarcode(_onScan),
        child: const Icon(Icons.camera),
      ),
    );
  }
}
