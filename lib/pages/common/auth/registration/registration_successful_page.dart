import 'package:flutter/material.dart';
import 'package:flutter_app/pages/common/auth/login/login_page.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:page_transition/page_transition.dart';

class RegistrationSuccessfulPage extends StatefulWidget {
  @override
  _RegistrationSuccessfulPage createState() => _RegistrationSuccessfulPage();
}

class _RegistrationSuccessfulPage extends State<RegistrationSuccessfulPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 75),
                Image.asset(
                  'assets/images/KinKin.png',
                  width: 90,
                  height: 80,
                ),
                SizedBox(height: 71),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Регистрация выполнена успешно",
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 7),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "На вашу почту отправлено письмо с данными о регистрации",
                    style: Theme.of(context).textTheme.headline2,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 58),
                Row(children: <Widget>[
                  SizedBox(width: 16),
                  Expanded(
                    child: AppButton(
                      enabled: true,
                      text: 'Назад на вход',
                      onPressed: onPressedGoOnLogin,
                    ),
                  ),
                  SizedBox(width: 16),
                ]),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressedGoOnLogin(){
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            type: PageTransitionType.fade, child: LoginPage()),
            (Route<dynamic> route) => false);
  }

}