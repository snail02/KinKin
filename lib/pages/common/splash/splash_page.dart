import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/common/auth/login/login_page.dart';
import 'package:flutter_app/pages/common/splash/splash_view.dart';
import 'package:flutter_app/pages/common/splash/splash_view_model.dart';
import 'package:flutter_app/pages/primary/primary_page.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with NotificationsMixin implements SplashView {

  late SplashViewModel _viewModel;

  @override
  void initState() {
    _viewModel = SplashViewModel(view: this);
    setUpStartLocale();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 311,
            ),
            Image.asset(
              'assets/images/KinKin.png',
              width: 90,
              height: 80,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "KinKin",
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void openLoginPage() {
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.fade, child: LoginPage()));

  }

  @override
  void openPrimaryPage() {
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.fade, child: PrimaryPage()));

  }
  Future<Locale> getSaveLocale() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    if (prefs.get('locale') != null) {
      String saveLocale = prefs.get('locale').toString();
      if (saveLocale.isNotEmpty) {
        return Locale(saveLocale);
      }
    }
    prefs.setString('locale', context.locale.toString());
    return context.locale;


  }

  Future<void> setUpStartLocale() async {
    EasyLocalization.of(context)!.setLocale(await getSaveLocale());
  }

}
