import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class TextCommand{


  String getText(String type){
    switch(type){
      case 'find_device':
        return LocaleKeys.tracker_command_find_device.tr();
      case 'listen_around':
        return LocaleKeys.tracker_command_listen_around.tr();
      case 'reboot':
        return LocaleKeys.tracker_command_reboot.tr();
      case 'shutdown':
        return LocaleKeys.tracker_command_shutdown.tr();
      case 'callback':
        return LocaleKeys.tracker_command_callback.tr();
      case 'send_flowers':
        return LocaleKeys.tracker_command_send_flowers.tr();
      case 'voice_message':
        return LocaleKeys.tracker_command_voice_message.tr();
      case 'view_health':
        return LocaleKeys.tracker_command_view_health.tr();
      case 'make_call':
        return LocaleKeys.tracker_command_make_call.tr();
      case 'send_message':
        return LocaleKeys.tracker_command_send_message.tr();
      default:
        return "commandName";
    }
  }
}