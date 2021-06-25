import 'package:flutter/material.dart';
import 'package:flutter_app/models/event/event.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/widgets/app_notifications_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AppPanelEvents extends StatelessWidget {
  final List<Event> events;
  final VoidCallback onTap;

  AppPanelEvents(this.events, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 9, left: 10),
            child: Text(
              LocaleKeys.all_alerts.tr(),
              style: GoogleFonts.openSans(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              //textAlign: TextAlign.start,
            ),
          ),
          Card(
            margin: EdgeInsets.all(0),
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                ListView.separated(
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
                    return AppNotificationsCard(
                      event: events[index],
                    );
                  },
                  itemCount: events.length,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    color: Colors.transparent,
                    height: 45,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color:Theme.of(context).dividerColor,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.all_alerts.tr(),
                                style: GoogleFonts.openSans(
                                  color: Theme.of(context).buttonColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
