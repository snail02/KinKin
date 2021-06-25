

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/provider/theme_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/common/splash/splash_page.dart';
import 'package:flutter_app/translations/codegen_loader.g.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // //Now we use SystemChrome
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //   //Lets make the Status Bar Transparent
  //   statusBarColor: Color.fromRGBO(244, 244, 244, 1),
  //
  //   //Lets make the status bar icon brightness to bright
  //   statusBarIconBrightness: Brightness.dark,
  // ));

  runApp(EasyLocalization(
      path: 'assets/translations',
      supportedLocales: [Locale('ru'), Locale('en')],
      //fallbackLocale: Locale('ru'),
      // useOnlyLangCode: true,
      assetLoader: CodegenLoader(),
      child: MyApp()));
  configLoading();
}



void configLoading() {
  EasyLoading.instance
   // ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
     ..loadingStyle = EasyLoadingStyle.custom
    // ..indicatorSize = 45.0
     ..radius = 18.0
     ..progressColor = Colors.blue
     ..backgroundColor = Colors.transparent
     ..indicatorColor = Colors.blue
     ..textColor = Colors.blue
     ..maskType = EasyLoadingMaskType.custom
     ..maskColor = Colors.white.withOpacity(0.5)
     ..userInteractions = false;
    // ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  //static ValueNotifier<Locale> currentLocale = ValueNotifier<Locale>(Locale((Platform.localeName).substring(0, 2).toString()));
  final navigatorKey = GlobalKey<NavigatorState>();

  // FlutterSoundRecorder? myRecorder = FlutterSoundRecorder();
  // FlutterSoundPlayer? myPlayer = FlutterSoundPlayer();
  //
  //  bool mRecorderIsInited = false;
  //  bool mPlayerIsInited = false;

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    builder: (context, _) {
      final themeProvider = Provider.of<ThemeProvider>(context);
    //return ValueListenableBuilder(
      //builder: (BuildContext context, value, Widget child) {
        return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          //locale: currentLocale.value,
          locale: context.locale ,
          title: 'KinKin',

          themeMode: themeProvider.themeMode,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,

          // theme: ThemeData(
          //   scaffoldBackgroundColor: Colors.white,
          //   textTheme: TextTheme(
          //     headline1: GoogleFonts.openSans(
          //       color: Color.fromRGBO(0, 0, 0, 1),
          //       fontSize: 30,
          //       fontWeight: FontWeight.w700,
          //     ),
          //     headline2: GoogleFonts.openSans(
          //       color: Color.fromRGBO(60, 60, 67, 0.6),
          //       fontSize: 16,
          //       fontWeight: FontWeight.w400,
          //     ),
          //     headline3: GoogleFonts.openSans(
          //       color: Color.fromRGBO(60, 60, 67, 0.6),
          //       fontSize: 14,
          //       fontWeight: FontWeight.w400,
          //     ),
          //     button: GoogleFonts.openSans(
          //       color: Color.fromRGBO(255, 255, 255, 1),
          //       fontSize: 18,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          home: SplashPage(),
          builder: EasyLoading.init(),
          navigatorKey: navigatorKey,
        );
  },
  );
     // },
     //valueListenable: currentLocale,
   // );



}
