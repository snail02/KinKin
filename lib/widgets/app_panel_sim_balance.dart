import 'package:flutter/material.dart';
import 'package:flutter_app/models/sim/info_of_sim.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AppPanelSimBalance extends StatelessWidget {
  final InfoOfSim infoOfSim;

  const AppPanelSimBalance(this.infoOfSim);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 100,
      child: Card(
        margin: EdgeInsets.all(0),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 13, top: 6, bottom: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/etisalat.png',
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Text(
                        infoOfSim.simOperator ?? " ",
                        style: GoogleFonts.openSans(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 13),
                  child: Text(
                    LocaleKeys.all_updated.tr() +
                        " " +
                        infoOfSim.getUpdateTime(context.locale.toString()),
                    style: GoogleFonts.openSans(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                  visible: infoOfSim.simBalance?.balance != null,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.tracker_sim_balance.tr(),
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              infoOfSim.simBalance?.balance?.toString() ?? "",
                              style: GoogleFonts.openSans(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2,),
                            ( infoOfSim.simBalance?.currency=="RUB") ?
                              SvgPicture.asset(
                                'assets/images/rub.svg',
                                height: 13,
                                width: 13,
                                color: Theme.of(context).colorScheme.primary,
                              )
                           :
                            Text(
                              infoOfSim.simBalance?.currency ?? "",
                              style: GoogleFonts.openSans(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: infoOfSim.simBalance?.data != null,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.tracker_sim_data.tr(),
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(children: [
                          Text(
                            infoOfSim.simBalance?.data?.toString() ?? "",
                            style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2,),
                          Text(
                            LocaleKeys.tracker_designation_mb.tr(),
                            style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: infoOfSim.simBalance?.sms != null,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.tracker_sim_sms.tr(),
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(children: [
                          Text(
                            infoOfSim.simBalance?.sms?.toString() ?? "",
                            style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2,),
                          Text(
                            LocaleKeys.tracker_designation_pc.tr(),
                            style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: infoOfSim.simBalance?.calls != null,
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          LocaleKeys.tracker_sim_calls.tr(),
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Row(children: [
                          Text(
                            infoOfSim.simBalance?.calls?.toString() ?? "",
                            style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2,),
                          Text(
                            LocaleKeys.tracker_designation_min.tr(),
                            style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
