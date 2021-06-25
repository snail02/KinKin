import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class AppPanelIconsNotif extends StatelessWidget {
  //final Function onTap;
  final bool? isFlowers;
  final String? flowersValue;
  final Function(String)? listenerOnTapFlowers;
  final bool? isMessage;
  final int? messageValue;
  final Function? onTapMessage;
  final bool? isNotification;
  final int? notificationValue;
  final Function? onTapNotification;
  final bool? isCall;
  final VoidCallback? onTapCall;
  final bool? isSetting;
  final Function? onTapSetting;

  const AppPanelIconsNotif({
    this.flowersValue,
    this.messageValue,
    this.notificationValue,
    this.isCall,
    this.isSetting,
    this.isFlowers,
    this.isMessage,
    this.isNotification,
    this.onTapCall,
    this.listenerOnTapFlowers,
    this.onTapMessage,
    this.onTapNotification,
    this.onTapSetting,

//this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 70,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Visibility(
            //visible: flowersValue!=null,
            visible: true,
            child: Expanded(
              child: GestureDetector(
                onTap: () {
                  _showDialog(context);
                },
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/heart.svg',
                          height: 42,
                        ),
                        Text(
                          flowersValue ?? "0",
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //SizedBox(width: 10,),
          Visibility(
            visible: messageValue != null,
            child: Expanded(
              child: GestureDetector(
                onTap: () {
                  if (onTapMessage != null) onTapMessage!();
                },
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        SvgPicture.asset(
                          'assets/images/link.svg',
                          height: 42,
                          color: Theme.of(context).buttonColor,
                        ),
                        Visibility(
                          visible: messageValue != null && messageValue != 0,
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            height: 24,
                            width: 24,
                            decoration: new BoxDecoration(
                              color: Color.fromRGBO(250, 74, 12, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              messageValue.toString(),
                              style: GoogleFonts.openSans(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          //SizedBox(width: 10,),
          Visibility(
            visible: notificationValue != null,
            child: Expanded(
              child: GestureDetector(
                onTap: () {
                  if (onTapNotification != null) onTapNotification!();
                },
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        SvgPicture.asset(
                          'assets/images/bell.svg',
                          height: 42,
                        ),
                        Visibility(
                          visible: notificationValue != null &&
                              notificationValue != 0,
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            height: 24,
                            width: 24,
                            decoration: new BoxDecoration(
                              color: Color.fromRGBO(250, 74, 12, 1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              notificationValue.toString(),
                              style: GoogleFonts.openSans(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTapCall,
              child: Card(
                elevation: 0,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/call.svg',
                        height: 42,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                print("ontap setting");
              },
              child: Card(
                elevation: 0,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/setting.svg',
                        height: 42,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> _displayTextInputDialog(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //           title: Text(LocaleKeys.tracker_command_send_flowers.tr()),
  //           content: _containerAlert(),
  //           actions: [
  //             GestureDetector(
  //               onTap: () {},
  //               child: Container(
  //                 padding: EdgeInsets.all(5),
  //                 decoration: BoxDecoration(
  //                   color: Color.fromRGBO(47, 128, 237, 1),
  //                   borderRadius: BorderRadius.all(
  //                     Radius.circular(5.0),
  //                   ),
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     LocaleKeys.all_send.tr(),
  //                     style: GoogleFonts.openSans(
  //                       color: Color.fromRGBO(255, 255, 255, 1),
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

  Future<void> _showDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();

          _textEditingController.text = flowersValue ?? "";
          final FocusNode _textEditingFocusNode = FocusNode();
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(LocaleKeys.tracker_command_send_flowers.tr(),
                  style: GoogleFonts.openSans(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  )),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MaterialButton(
                        height: 40,
                        color: Theme.of(context).buttonColor,
                        shape: CircleBorder(),
                        elevation: 0,
                        focusElevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          var intValue;
                          if (_textEditingController.text.isEmpty)
                            intValue = 0;
                          else
                            intValue = int.parse(_textEditingController.text);
                          if (intValue > 0) {
                            intValue--;
                            _textEditingController.text = intValue.toString();
                          }
                        },
                        child: Icon(
                          Icons.remove,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 80,
                        child: TextFormField(
                            controller: _textEditingController,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Theme.of(context).colorScheme.primary,),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: InputDecoration(
                              hintText: "0",
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(),
                            )),
                      ),
                      MaterialButton(
                        height: 40,
                        color: Theme.of(context).buttonColor,
                        shape: CircleBorder(),
                        elevation: 0,
                        focusElevation: 0,
                        disabledElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0,
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          var intValue;
                          if (_textEditingController.text.isEmpty)
                            intValue = 0;
                          else
                            intValue = int.parse(_textEditingController.text);
                          intValue++;
                          _textEditingController.text = intValue.toString();
                        },
                        child: Icon(
                          Icons.add,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Theme.of(context).buttonColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 0,
                  focusElevation: 0,
                  disabledElevation: 0,
                  highlightElevation: 0,
                  hoverElevation: 0,
                  onPressed: () {
                    if (_textEditingController.text.isEmpty)
                      listenerOnTapFlowers?.call("0");
                    else
                      listenerOnTapFlowers?.call(_textEditingController.text);

                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      LocaleKeys.all_send.tr(),
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }
}
