import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class AppMessageError extends StatelessWidget {
  final String text;

  const AppMessageError({
    required this.text,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).errorColor,
        border: Border.all(
          color: Color.fromRGBO(246, 149, 46, 1),
          width: 1,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Text(
            text,
            style: GoogleFonts.openSans(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

