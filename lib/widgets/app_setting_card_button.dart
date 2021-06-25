

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class AppSettingCardButton extends StatelessWidget {
  final String text;
  final Widget? widget;

  const AppSettingCardButton({
    required this.text,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.openSans(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            if(widget!=null) widget!,
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}