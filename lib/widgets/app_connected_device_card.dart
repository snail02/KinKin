import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/device/connected_device.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/text_type_connected_device.dart';
import 'package:flutter_app/utils/url_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AppConnectedDeviceCard extends StatelessWidget {
  final ConnectedDevice connectedDevice;

  const AppConnectedDeviceCard({
    required this.connectedDevice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DeviceDetailPage(
        //     device: device,
        //   )),
        // );
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
                      imageUrl:
                          UrlImage().urlConnection(connectedDevice.type ?? ""),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                              CircularProgressIndicator(
                                  value: downloadProgress.progress),
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
                        Text(
                          connectedDevice.name ?? "",
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          TextTypeConnectedDevice().getText(connectedDevice.type ?? ""),
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(children: [
                          SvgPicture.asset(
                            'assets/images/sound-waves.svg',
                            height: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            connectedDevice.speechCount.toString(),
                            style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(right: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 24,
                            width: 64,
                            decoration: BoxDecoration(
                                color: (connectedDevice.state == 1)
                                    ? Color.fromRGBO(57, 137, 46, 1)
                                    : Color.fromRGBO(196, 196, 196, 1),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            child: Center(
                              child: Text(
                                (connectedDevice.state == 1)
                                    ? LocaleKeys.all_on.tr()
                                    : LocaleKeys.all_off.tr(),
                                style: GoogleFonts.openSans(
                                  color: (connectedDevice.state == 1)
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          SvgPicture.asset(
                            'assets/images/right_right.svg',
                            height: 10,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
