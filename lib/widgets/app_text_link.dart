import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextLink extends StatelessWidget {
  final String prefix;
  final String between;
  final String text1;
  final String text2;
  final Function onTap1;
  final Function onTap2;
  final TapGestureRecognizer recognizer1;
  final TapGestureRecognizer recognizer2 ;

  AppTextLink({
    required this.text1,
    required this.text2,
    required this.prefix,
    required this.between,
    required this.onTap1,
    required this.onTap2,
    required this.recognizer1,
    required this.recognizer2,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: RichText(
        //overflow: TextOverflow.ellipsis,
        //textDirection: TextDirection.rtl,
        //textAlign: TextAlign.justify,
        //maxLines: 2,
        //textScaleFactor: 0.5,
        textAlign: TextAlign.left,
        text: TextSpan(
          text: prefix == null ? "" : prefix + " ",
          style: GoogleFonts.openSans(
            color: Theme.of(context).colorScheme.primaryVariant,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          children: <TextSpan>[
            TextSpan(
              text: text1,
              recognizer: recognizer1..onTap = () => onTap1(),
              style: GoogleFonts.openSans(
                color: Theme.of(context).toggleableActiveColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: ' ' +between+ ' ',
              style: GoogleFonts.openSans(
                color: Theme.of(context).colorScheme.primaryVariant,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: text2,
              recognizer: recognizer2..onTap = () =>onTap2(),
              style: GoogleFonts.openSans(
                color: Theme.of(context).toggleableActiveColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
