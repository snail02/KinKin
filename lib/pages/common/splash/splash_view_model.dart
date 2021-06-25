
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/common/splash/splash_events.dart';
import 'package:flutter_app/pages/common/splash/splash_states.dart';

import 'package:flutter_app/pages/common/splash/splash_view.dart';
import 'package:flutter_app/utils/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends ViewModel<SplashView, SplashState, SlashEvent> {
  SplashViewModel({required SplashView view}) : super(view: view);

  @override
  void init() {
    super.init();
    _checkSavedAccessToken();
    //initSplash();
  }

/*  void initSplash(){
    Future.wait([_checkSavedAccessToken(), Future.delayed(Duration(seconds: 3))] );
  }*/

  Future<void> _checkSavedAccessToken() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    if (prefs.get('accessToken') != null) {
      String accessToken = prefs.get('accessToken').toString();
      if (accessToken.isNotEmpty) {
        print(accessToken);
        view.openPrimaryPage();
      }
      else
        view.openLoginPage();
    } else {
      view.openLoginPage();
    }
  }

}
