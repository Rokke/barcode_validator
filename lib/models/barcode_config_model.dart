import 'package:barcode_validator/services/application_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerBarcodeConfig = Provider((ref) {
  final appConfig = ref.watch(providerApplicationConfig);
  return BarcodeConfigRepository(appConfig.barcodeModels);
});
// final providerSelectedBarcodeConfig = StateProvider<int>((ref) => -1);

class BarcodeConfigRepository {
  final List<BarcodeConfigModel> _barcodeModels;
  // final Reader _read;
  // late int _selectedBarcode;

  BarcodeConfigRepository(this._barcodeModels) {
    // _updateSelectedBarcode(_read(providerApplicationConfig).lastSavedIndex);
    // changeBarcode(0);
  }
  // List<BarcodeConfigModel> get barcodeModels => List.unmodifiable(_barcodeModels);
  int get length => _barcodeModels.length;
  // int get index => _selectedBarcode;
  BarcodeConfigModel getBarcodeConfig(int index) => _barcodeModels[index];
  List<BarcodeConfigModel> get barcodeModels => _barcodeModels;
  void addNewBarcodeConfig(BarcodeConfigModel barcodeConfigModel) {
    _barcodeModels.add(barcodeConfigModel);
    // changeBarcode(_barcodeModels.length - 1);
  }

  // _updateSelectedBarcode(int index) {
  //   debugPrint('_updateSelectedBarcode($index)');
  //   _selectedBarcode = index;
  //   // _read(providerSelectedBarcodeConfig.notifier).state = _selectedBarcode; // _barcodeModels.isNotEmpty && _selectedBarcode >= 0 ? _barcodeModels[_selectedBarcode] : null;
  // }

  // void changeBarcode(int index) {
  //   debugPrint('changeBarcode($index)');
  //   _updateSelectedBarcode(index);
  //   _read(providerApplicationConfig).changeLastIndex(index);
  // }

  // void nextBarcode() {
  //   changeBarcode((_selectedBarcode == _barcodeModels.length - 1) ? 0 : _selectedBarcode + 1);
  // }

  // void previousBarcode() {
  //   changeBarcode((_selectedBarcode == 0) ? 0 : _barcodeModels.length - 1);
  // }
}

class BarcodeConfigModel {
  final List<BarcodeConfigRegex> barcodes;
  String name;

  BarcodeConfigModel(this.name, this.barcodes);
  set updateBarcodes(List<BarcodeConfigRegex> value) {
    barcodes.clear();
    barcodes.addAll(value);
  }

  int get length => barcodes.length;
}

class BarcodeConfigRegex {
  final String name;
  final List<String> barcodeTypes;
  final String regex;
  final int? start, stop;

  BarcodeConfigRegex({required this.name, required this.barcodeTypes, required this.regex, required this.start, required this.stop});
  // String get encode => '$name§$regex§[${barcodeTypes.map((e) => e).join(',')}]§$start§$stop';
}
