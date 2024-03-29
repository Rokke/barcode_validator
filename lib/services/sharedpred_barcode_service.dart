import 'package:barcode_validator/barrel.dart';

abstract class SharedPrefBarcodeService {
  static BarcodeConfigModel? stringToBarcodeModel(String value) {
    final sep = value.split('§§');
    if (sep.length < 2) return null;
    return BarcodeConfigModel(sep.first, _stringToBarcodeConfigRegexList(sep.sublist(1)));
  }

  static List<BarcodeConfigRegex> _stringToBarcodeConfigRegexList(List<String> value) {
    return value.map(_stringToBarcodeConfigRegex).toList();
  }

  static Iterable<BarcodeFormatEnum> _stringToBarcodeFormatEnumList(String value) sync* {
    for (var element in value.split(',')) {
      final barcodeFormat = element.trim();
      if (barcodeFormat.isNotEmpty) yield BarcodeFormatModel.stringToBarcodeFormatEnum(barcodeFormat);
    }
  }

  static BarcodeConfigRegex _stringToBarcodeConfigRegex(String value) {
    final sep = value.split('§');
    return BarcodeConfigRegex(
        name: sep.first,
        barcodeTypes: _stringToBarcodeFormatEnumList(sep[1].substring(1, sep[1].length - 1)).toList(),
        regex: sep[2],
        start: sep.length > 3 ? int.tryParse(sep[3]) : null,
        stop: sep.length > 4 ? int.tryParse(sep[4]) : null);
  }

  static List<BarcodeConfigModel> sharedPrefsToBarcodeConfig(List<String> sharedPrefStrings) => sharedPrefStrings.map(stringToBarcodeModel).whereType<BarcodeConfigModel>().toList();
  static String _barcodeConfigRegexToString(BarcodeConfigRegex value) =>
      '§§${value.name}§[${value.barcodeTypes.map((e) => e.toString().split('.').last).join(',')}]§${value.regex}${(value.start != null || value.stop != null) ? '§${value.start ?? 0}' : ''}${value.stop != null ? '§${value.stop}' : ''}';
  static String barcodeModelToString(BarcodeConfigModel value) => '${value.name}${value.barcodes.map(_barcodeConfigRegexToString).join()}';
  static List<String> barcodeConfigToSharedPrefs(List<BarcodeConfigModel> barcodeConfigModels) => barcodeConfigModels.map(barcodeModelToString).toList();
}
