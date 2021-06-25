import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
class TextState{


  String getText(String state){
    switch(state){
      case 'move':
        return LocaleKeys.tracker_state_move.tr();
      case 'stop':
        return LocaleKeys.tracker_state_stop.tr();
      case 'park':
        return LocaleKeys.tracker_state_park.tr();
      case 'stay':
        return LocaleKeys.tracker_state_stay.tr();
      default:
        return "";
    }
  }
}