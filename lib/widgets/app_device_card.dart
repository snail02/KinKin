import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/device/device.dart';
import 'package:flutter_app/pages/device_detail/device_detail_page.dart';
import 'package:flutter_app/utils/text_state.dart';
import 'package:flutter_app/utils/url_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class AppDeviceCard extends StatelessWidget {
  final Device device;



  const AppDeviceCard({
    required this.device,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     PageTransition(
        //         type: PageTransitionType.fade,
        //         child: DeviceDetailPage(
        //           device: device,
        //         )));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DeviceDetailPage(
            device: device,
          )),
        );
      },
      child: Card(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.symmetric(horizontal: 10),
          shadowColor: Color.fromRGBO(0, 0, 0, 0.03),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
            height: 100,
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    //color: Colors.red,
                    color: Theme.of(context).accentColor,
                    shape: BoxShape.circle,
                  ),

                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: CachedNetworkImage(
                      imageUrl: UrlImage().url(device.image),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              device.name,
                              style: GoogleFonts.openSans(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Visibility(
                              visible: device.battery!=null,
                              child: Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/battery.svg',
                                      height: 28,
                                       color: Theme.of(context).colorScheme.primary,
                                       //width: 26,
                                    ),
                                    Text(
                                      device.battery.toString(),
                                      style: GoogleFonts.openSans(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(
                            device.lastLocation!=null? device.lastLocation!.getLastUpdateTime(context.locale.toString()):"",
                          style: GoogleFonts.openSans(
                            color: Color.fromRGBO(6, 160, 68, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          TextState().getText(device.lastLocation?.state?? ""),
                          style: GoogleFonts.openSans(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: (device.message>0)? true : false ,
                        child: Row(
                          children: [
                            Icon(
                              Icons.message_sharp,
                              color: Color.fromRGBO(47, 128, 237, 1),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              device.message.toString(),
                              style: GoogleFonts.openSans(
                                color: Color.fromRGBO(47, 128, 237, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: (device.alert > 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              color: Color.fromRGBO(250, 74, 12, 1),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              device.alert.toString(),
                              style: GoogleFonts.openSans(
                                color: Color.fromRGBO(250, 74, 12, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
