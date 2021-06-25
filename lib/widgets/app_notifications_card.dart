import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/event/event.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/sound_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AppNotificationsCard extends StatelessWidget {
  final Event event;
  static const String baseUrl = "https://backend.kinkin.net/data/talk/";

  const AppNotificationsCard({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (event.type == "tlk" || event.type == "ptk") {
          if(event.data!=null)
          if(SoundPlayer().play(baseUrl + event.data!)!=1)
            CommonUiNotification(
              type: CommonUiNotificationType.ALERT,
              message: "play error",
            );
        }
      },
      child: Container(
        color: Colors.transparent,
        height: 50,
        child: (event.type != "ptk")
            ? Row(
          children: [
            SizedBox(
              width: 16,
            ),
            imageEvent(context),
            SizedBox(
              width: 8,
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 6,
                  ),
                  textEvent(context),
                  Text(getSubText(),
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ))
                ]),
            Expanded(
              child: SizedBox(
                width: 16,
              ),
            ),
            Text(
              event.getLastUpdateTime(context.locale.toString()),
              style: GoogleFonts.openSans(
                color: Theme.of(context).colorScheme.primaryVariant,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 16,
            ),
          ],
        )
            : Row(
          children: [
            SizedBox(
              width: 16,
            ),
            if (event.duration != null)
              Text(
                event.getLastUpdateTime(context.locale.toString()),
                style: GoogleFonts.openSans(
                  color: Theme.of(context).colorScheme.primaryVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.left,
              ),
            Expanded(
              child: SizedBox(
                width: 16,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 6,
                ),
                textEvent(context),
                if (event.duration != null)
                  Text(
                    getSubText(),
                    style: GoogleFonts.openSans(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                  )
              ],
            ),

            SizedBox(
              width: 8,
            ),
            imageEvent(context),
            SizedBox(
              width: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget imageEvent(BuildContext context) {
    if (event.type == "tlk" || event.type == "ptk")
      return SvgPicture.asset(
        'assets/images/microphone.svg',
        color: colorEvent(context),
        width: 24,
      );
    if (event.type == "txt")
      return SvgPicture.asset('assets/images/ChatCircleText.svg',
          color: colorEvent(context), width: 24);
    return SvgPicture.asset("assets/images/share.svg",
        color: colorEvent(context), width: 24);
  }

  Widget textEvent(BuildContext context) {
    var style = GoogleFonts.openSans(
      color: colorEvent(context),
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );
    var styleB = GoogleFonts.openSans(
      color: colorEvent(context),
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );
    if (event.type == "tlk" || event.type == "ptk") {
      if (event.type == "tlk")
        return Text(
          LocaleKeys.tracker_event_tlk.tr(),
          style: styleB,
        );
      else
        return Text(
          LocaleKeys.tracker_event_tlk.tr(),
          style: style,
        );
    }
    if (event.type == "txt")
      return Text(
        LocaleKeys.tracker_event_txt.tr(),
        style: style,
      );
    if (event.type == "rst")
      return Text(
        "Устройство перезагружено",
        style: style,
      );
    if (event.type == "sos")
      return Text(
        "Сигнал тревоги от устройства",
        style: style,
      );
    if (event.type == "wrm")
      return Text(
        "Часы сняты с руки",
        style: style,
      );
    if (event.type == "lbt")
      return Text(
        "Низкий заряд батареи",
        style: style,
      );
    return Text(
      event.type,
      style: style,
    );
  }

  Color colorEvent(BuildContext context) {
    if (event.type == "tlk" || event.type == "ptk")
      return Theme.of(context).buttonColor;
    return Theme.of(context).colorScheme.primaryVariant;
  }

  String getSubText() {
    if (event.type == "tlk" || event.type == "ptk")
      return (event.duration!).toString() + " " +LocaleKeys.all_sec.tr();
    if (event.type == "txt") return event.data?? "";
    return "";
  }
}
