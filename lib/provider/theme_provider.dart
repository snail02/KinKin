import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  // bool get isDarkMode {
  //   if (themeMode == ThemeMode.system) {
  //     final brightness = SchedulerBinding.instance.window.platformBrightness;
  //     return brightness == Brightness.dark;
  //   } else {
  //     return themeMode == ThemeMode.dark;
  //   }
  // }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class OwnThemeFields {
  final Color colorMainText;
  final Color colorSecondText;
  final Color colorSubtext;
  final Color colorPrefixText;
  final Color colorTextButton;
  final Color colorElement;
  final Color colorErrorMessageBox;
  final Color colorFillImage;
  final Color colorInfoText;
  final Color colorLinkText;
  final Color colorDivider;

  OwnThemeFields({
    this.colorMainText = Colors.black,
    this.colorSecondText = Colors.black,
    this.colorPrefixText = Colors.black,
    this.colorTextButton = Colors.black,
    this.colorElement = Colors.black,
    this.colorErrorMessageBox = Colors.black,
    this.colorFillImage = Colors.black,
    this.colorInfoText = Colors.black,
    this.colorLinkText = Colors.black,
    this.colorSubtext = Colors.black,
    this.colorDivider = Colors.black,
  });
}

extension MyThemes on ThemeData {
  static Map<InputDecorationTheme, OwnThemeFields> _own = {};

  void addOwn(OwnThemeFields own) {
    // can't use reference to ThemeData since Theme.of() can create a new localized instance from the original theme. Use internal fields, in this case InputDecoreationTheme reference which is not deep copied but simply a reference is copied
    _own[this.inputDecorationTheme] = own;
  }

  static late final OwnThemeFields empty = OwnThemeFields();

  OwnThemeFields own() {
    var o = _own[this.inputDecorationTheme];
    if (o == null) {
      o = empty;
    }
    return o;
  }

  OwnThemeFields ownTheme(BuildContext context) => Theme.of(context).own();

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color.fromRGBO(31, 31, 31, 1),
    primaryColor: Color.fromRGBO(0, 0, 0, 1),
    buttonColor: Color.fromRGBO(47, 128, 237, 1),
    dividerColor: Color.fromRGBO(229, 229, 229, 1),
    errorColor: Color.fromRGBO(246, 149, 46, 0.75),
    accentColor: Color.fromRGBO(34, 34, 34, 1), //colorFillImage
    secondaryHeaderColor:Color.fromRGBO(255, 255, 255, 0.5), //infotext
    toggleableActiveColor: Color.fromRGBO(0, 122, 255, 1), //link

    colorScheme: ColorScheme.dark(
      primary: Color.fromRGBO(255, 255, 255, 1), //maintext
      primaryVariant: Color.fromRGBO(255, 255, 255, 0.5), //secondtext
      secondary: Color.fromRGBO(255, 255, 255, 1),
      secondaryVariant: Color.fromRGBO(255, 255, 255, 0.5),
    ),
    appBarTheme: AppBarTheme(color: Color.fromRGBO(49, 49, 49, 1)),
    //colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
    textTheme: TextTheme(
      headline1: GoogleFonts.openSans(
        color: Color.fromRGBO(255, 255, 255, 1),
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
      headline2: GoogleFonts.openSans(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      headline3: GoogleFonts.openSans(
        color: Color.fromRGBO(60, 60, 67, 0.6),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headline4: GoogleFonts.openSans(
        color: Color.fromRGBO(255, 255, 255, 0.5),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      button: GoogleFonts.openSans(
        color: Color.fromRGBO(0, 0, 0, 1),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  )..addOwn(OwnThemeFields(
      colorElement: Color.fromRGBO(47, 128, 237, 1),//
      colorErrorMessageBox: Color.fromRGBO(246, 149, 46, 0.75),//
      colorFillImage: Color.fromRGBO(238, 238, 238, 1),//
      colorMainText: Color.fromRGBO(255, 255, 255, 1),//
      colorPrefixText: Color.fromRGBO(255, 255, 255, 0.5),
      colorSecondText: Color.fromRGBO(255, 255, 255, 0.5),//
      colorTextButton: Color.fromRGBO(0, 0, 0, 1),//
      colorInfoText: Color.fromRGBO(60, 60, 67, 0.6),//
      colorLinkText: Color.fromRGBO(0, 122, 255, 1),//
      colorDivider: Color.fromRGBO(229, 229, 229, 1),//
    ));

  static final ThemeData lightTheme = (ThemeData.light().copyWith(
    scaffoldBackgroundColor: Color.fromRGBO(249, 249, 249, 1),
    primaryColor: Color.fromRGBO(255, 255, 255, 1),
    buttonColor: Color.fromRGBO(47, 128, 237, 1),
    dividerColor: Color.fromRGBO(229, 229, 229, 1),
    errorColor: Color.fromRGBO(246, 149, 46, 0.25),
    accentColor: Color.fromRGBO(238, 238, 238, 1), //colorFillImage
    secondaryHeaderColor:Color.fromRGBO(60, 60, 67, 0.6), //infotext
    toggleableActiveColor: Color.fromRGBO(0, 122, 255, 1),
    colorScheme: ColorScheme.light(
      primary: Color.fromRGBO(0, 0, 0, 1), //maintext
      primaryVariant: Color.fromRGBO(170, 170, 170, 1), //secondtext
      secondary: Color.fromRGBO(60, 60, 67, 1),
      secondaryVariant: Color.fromRGBO(60, 60, 67, 0.3),
    ),
    appBarTheme: AppBarTheme(color: Color.fromRGBO(244, 244, 244, 1)),
    // colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
    textTheme: TextTheme(
      headline1: GoogleFonts.openSans(
        color: Color.fromRGBO(0, 0, 0, 1),
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
      headline2: GoogleFonts.openSans(
        color: Color.fromRGBO(60, 60, 67, 0.6),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      headline3: GoogleFonts.openSans(
        color: Color.fromRGBO(60, 60, 67, 0.6),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      headline4: GoogleFonts.openSans(
        color: Color.fromRGBO(60, 60, 67, 0.3),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      button: GoogleFonts.openSans(
        color: Color.fromRGBO(255, 255, 255, 1),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
  ))
    ..addOwn(OwnThemeFields(
      colorElement: Color.fromRGBO(47, 128, 237, 1),
      colorErrorMessageBox: Color.fromRGBO(246, 149, 46, 0.25),
      colorFillImage: Color.fromRGBO(238, 238, 238, 1),
      colorMainText: Color.fromRGBO(0, 0, 0, 1),
      colorPrefixText: Color.fromRGBO(60, 60, 67, 0.3),
      colorSecondText: Color.fromRGBO(170, 170, 170, 1),
      colorTextButton: Color.fromRGBO(255, 255, 255, 1),
      colorInfoText: Color.fromRGBO(60, 60, 67, 0.6),
      colorLinkText: Color.fromRGBO(0, 122, 255, 1),
      colorDivider: Color.fromRGBO(229, 229, 229, 1),
    ));
}
