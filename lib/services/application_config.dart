import 'package:barcode_validator/services/barcode_config_model.dart';
import 'package:barcode_validator/services/sharedpred_barcode_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final providerApplicationConfig = ChangeNotifierProvider<ApplicationConfig>((_) => throw Exception('Must be initialized'));

class ApplicationConfig extends ChangeNotifier {
  final List<String> _barcodeNames;
  int _lastSavedIndex;
  final String _versionName;
  ApplicationConfig._(this._barcodeNames, this._lastSavedIndex, this._versionName);
  int get lastSavedIndex => _lastSavedIndex;
  String get versionName => _versionName;
  static Future<ApplicationConfig> getInstance() async {
    final pInfo = await PackageInfo.fromPlatform();
    final pref = await SharedPreferences.getInstance();
    final appConfig = ApplicationConfig._(pref.getStringList('BarcodeTypes') ?? [], pref.getInt('LastIndex') ?? -1, '${pInfo.version}${pInfo.buildNumber.isNotEmpty ? '.${pInfo.buildNumber}' : ''}');
    return appConfig;
  }

  Future<void> save(List<BarcodeConfigModel> barcodeModels) async {
    debugPrint('save(${barcodeModels.length})');
    final pref = await SharedPreferences.getInstance();
    _barcodeNames.clear();
    _barcodeNames.addAll(SharedPrefBarcodeService.barcodeConfigToSharedPrefs(barcodeModels));
    pref.setStringList('BarcodeTypes', _barcodeNames);
    notifyListeners();
  }

  changeLastIndex(int index) async {
    debugPrint('changeLastIndex($index)');
    (await SharedPreferences.getInstance()).setInt('LastIndex', _lastSavedIndex = index);
  } //BUR123456789012

  List<BarcodeConfigModel> get barcodeModels => SharedPrefBarcodeService.sharedPrefsToBarcodeConfig(_barcodeNames);
}
