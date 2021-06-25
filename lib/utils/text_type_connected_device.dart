import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class TextTypeConnectedDevice {
  String getText(String state) {
    switch (state) {
      case 'tg':
        return LocaleKeys.connections_type_tg.tr();
      case 'my':
        return LocaleKeys.connections_type_my.tr();
      case 'oth':
        return LocaleKeys.connections_type_oth.tr();
      default:
        return "";
    }
  }
}
