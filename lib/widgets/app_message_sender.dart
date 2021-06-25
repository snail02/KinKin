import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/app_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppMessageSender extends StatelessWidget {
  final bool isTextType;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onPressButton;
  final Function unPressButton;

  const AppMessageSender(
      {this.isTextType = false,
      required this.controller,
      required this.focusNode,
      required this.onPressButton,
      required this.unPressButton});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 255, 255, 1),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: GoogleFonts.openSans(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 13),
                    hintStyle: GoogleFonts.openSans(
                      color: Color.fromRGBO(170, 170, 170, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: "Отправить сообщение",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 13,
            ),
            Listener(
              onPointerDown: (details)=>onPressButton,
              onPointerUp: (details)=>unPressButton,
              child: RawMaterialButton(
                onPressed: () => {},
                elevation: 0.0,
                constraints: BoxConstraints(minWidth: 40.0, minHeight: 36.0),
                fillColor: Color.fromRGBO(47, 128, 237, 1),
                child: (isTextType == false)
                    ? SvgPicture.asset(
                        "assets/images/microphone.svg",
                        color: Color.fromRGBO(255, 255, 255, 1),
                        height: 26,
                      )
                    : SvgPicture.asset(
                        "assets/images/arrow.svg",
                        color: Color.fromRGBO(255, 255, 255, 1),
                        height: 26,
                      ),
                padding: EdgeInsets.all(10.0),
                shape: CircleBorder(),
              ),
            ),
            SizedBox(
              width: 13,
            ),
          ],
        ));
  }
}
