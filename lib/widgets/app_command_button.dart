import 'package:flutter/material.dart';
import 'package:flutter_app/models/device/commands.dart';
import 'package:flutter_app/utils/text_command.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppCommandButton extends StatelessWidget {
  final Commands command;
  final Function? onTap;
  final bool enabled;
  final String image;
  final Color color;

  const AppCommandButton({
    required this.command,
    this.onTap,
    this.enabled = true,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap?.call();
      },
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: Row(
          children: [
            SizedBox(width: 16,),
            SvgPicture.asset(
              image,
              width: 24,
              color: color,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              TextCommand().getText(command.code),
              style: GoogleFonts.openSans(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
