import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/common/auth/login/login_page.dart';
import 'package:flutter_app/pages/primary/primary_page.dart';
import 'package:flutter_app/pages/primary/settings/settings_view.dart';
import 'package:flutter_app/pages/primary/settings/settings_view_model.dart';
import 'package:flutter_app/provider/theme_provider.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_setting_card_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage>
    with NotificationsMixin, AutomaticKeepAliveClientMixin<SettingsPage>
    implements SettingsView {
  late SettingsViewModel _viewModel;
  List listItem = ["Русский", "English"];
  List listItemTypeTheme = ["Светлая", "Темная"];
  String valueChooseLanguage = "null";
  String valueChooseTheme = "null";

  List listWidgetCommon = [];
  List listWidgetInterface = [];
  List listWidgetSupport = [];


  @override
  void initState() {
    _viewModel = SettingsViewModel(view: this);
    super.initState();

    valueChooseTheme = getCurrentTheme();
  }

  @override
  Widget build(BuildContext context) {
    valueChooseLanguage = getCurrentLanguage();
    widgetInit();
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
        automaticallyImplyLeading: false,
        title: Text(
          LocaleKeys.menu_settings.tr(),
          style: GoogleFonts.openSans(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        actions: <Widget>[
          TextButton(
              onPressed: _viewModel.logOut,
              child: Text(
                LocaleKeys.menu_logout.tr(),
                style: GoogleFonts.openSans(
                  color: Theme.of(context).toggleableActiveColor,
                  //color: Color.fromRGBO(r, g, b, opacity)
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              )),
          SizedBox(
            width: 16,
          )
        ],
      ),
      body: GestureDetector(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.only(top: 14, left: 10, right: 10),
            children: [
              commonCard(),
              interfaceCard(),
            ],
          ),
        ),
      ),
    );
  }

  void widgetInit() {
    listWidgetCommon.clear();
    listWidgetInterface.clear();
    listWidgetSupport.clear();

    Widget myProfile = AppSettingCardButton(
        text: "Мой профиль",
        widget: SvgPicture.asset(
          'assets/images/right_right.svg',
          height: 16,
          color: Theme.of(context).colorScheme.primaryVariant,
        ));

    listWidgetCommon.add(myProfile);

    Widget language = AppSettingCardButton(
      text: LocaleKeys.settings_interface_language.tr(),
      widget: DropdownButton(
        value: valueChooseLanguage,
        underline: SizedBox(),
        icon: SizedBox(),
        onChanged: (newValue) async {
          setState(() {
            valueChooseLanguage = newValue.toString();
            changeLanguage(valueChooseLanguage);
          });
        },
        items: listItem.map((valueItem) {
          return DropdownMenuItem(
              value: valueItem,
              child: Text(
                valueItem,
                style: GoogleFonts.openSans(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ));
        }).toList(),
      ),
    );
    listWidgetInterface.add(language);

    Widget theme = AppSettingCardButton(
      text: "Тема интерфейса",
      widget: DropdownButton(
        value: valueChooseTheme,
        underline: SizedBox(),
        icon: SizedBox(),
        onChanged: (newValue) async {
          setState(() {
            valueChooseTheme = newValue.toString();
            changeTheme(valueChooseTheme);
          });
        },
        items: listItemTypeTheme.map((valueItem) {
          return DropdownMenuItem(
              value: valueItem,
              child: Text(
                valueItem,
                style: GoogleFonts.openSans(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ));
        }).toList(),
      ),
    );
    listWidgetInterface.add(theme);
  }

  Widget commonCard() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Общее",
              style: GoogleFonts.openSans(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Card(
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              //primary: false,
              shrinkWrap: true,

              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return listWidgetCommon[index];
              },
              itemCount: listWidgetCommon.length,
            ),
          )
        ],
      ),
    );
  }

  Widget interfaceCard() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Интерфейс",
              style: GoogleFonts.openSans(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Card(
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              //primary: false,
              shrinkWrap: true,

              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return listWidgetInterface[index];
              },
              itemCount: listWidgetInterface.length,
            ),
          )
        ],
      ),
    );

    // return Card(
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: Theme.of(context).primaryColor,
    //       borderRadius: BorderRadius.all(Radius.circular(10)),
    //       //border: Border.all(width: 1),
    //     ),
    //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           LocaleKeys.settings_interface_language.tr(),
    //           style: GoogleFonts.openSans(
    //             color: Theme.of(context).own().colorMainText,
    //             fontSize: 16,
    //             fontWeight: FontWeight.w400,
    //           ),
    //         ),
    //         DropdownButton(
    //           value: valueChooseLanguage,
    //           underline: SizedBox(),
    //           icon: SizedBox(),
    //           onChanged: (newValue) async {
    //             setState(() {
    //               valueChooseLanguage = newValue.toString();
    //               changeLanguage(valueChooseLanguage);
    //             });
    //           },
    //           items: listItem.map((valueItem) {
    //             return DropdownMenuItem(
    //                 value: valueItem,
    //                 child: Text(
    //                   valueItem,
    //                   style: GoogleFonts.openSans(
    //                     color: Theme.of(context).own().colorSecondText,
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w400,
    //                   ),
    //                 ));
    //           }).toList(),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  String getCurrentLanguage() {
    String currentLanguage;
    if (EasyLocalization.of(context)!.currentLocale == Locale('ru'))
      currentLanguage = listItem[0];
    else
      currentLanguage = listItem[1];

    return currentLanguage;
  }

  String getCurrentTheme() {
    String currentTheme;

    currentTheme = listItemTypeTheme[0];
    return currentTheme;
  }

  void changeLanguage(String valueChoose) async {
    if (valueChoose == 'Русский') {
      EasyLocalization.of(context)!.setLocale(Locale('ru'));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('locale', Locale('ru').toString());
      // final SharedPreferences prefs =  await SharedPreferences.getInstance();
      //   String accessToken = prefs.get('accessToken').toString();

    } else {
      EasyLocalization.of(context)!.setLocale(Locale('en'));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('locale', Locale('en').toString());
    }
    Navigator.of(context).pushReplacement(PageTransition(
        type: PageTransitionType.fade,
        child: PrimaryPage(
          currentTab: 1,
        )));
  }

  void changeTheme(String valueChoose) async {
    final provider = Provider.of<ThemeProvider>(context, listen: false);

    if (valueChoose == listItemTypeTheme[0])
      provider.toggleTheme(false);
    else
      provider.toggleTheme(true);
  }

  @override
  void openLoginPage() {
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: LoginPage()),
        (Route<dynamic> route) => false);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
