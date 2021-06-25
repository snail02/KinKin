import 'package:flutter/material.dart';
import 'package:flutter_app/pages/primary/settings/settings_events.dart';
import 'package:flutter_app/pages/primary/settings/settings_states.dart';
import 'package:flutter_app/pages/primary/settings/settings_view.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel
    extends ViewModel<SettingsView, SettingsState, SettingsEvent> {
  SettingsViewModel({required SettingsView view}) : super(view: view);


  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', '');
    view.openLoginPage();
  }
}
