import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/device/connected_device.dart';
import 'package:flutter_app/models/device/device_detail.dart';
import 'package:flutter_app/pages/new_connection/new_connection_states.dart';
import 'package:flutter_app/pages/new_connection/new_connection_view.dart';
import 'package:flutter_app/pages/new_connection/new_connection_view_model.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_connected_device_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

class NewConnectionPage extends StatefulWidget {
  final ConnectedDevice? connectedDevice;

  const NewConnectionPage({Key? key, this.connectedDevice}) : super(key: key);

  @override
  _NewConnectionPageState createState() => _NewConnectionPageState();
}

var refreshKey = GlobalKey<RefreshIndicatorState>();

bool switchValue = false;

class _NewConnectionPageState extends State<NewConnectionPage>
    with NotificationsMixin
    implements NewConnectionView {
  late NewConnectionViewModel _viewModel;
  late ScrollController _controller;

  @override
  void initState() {
    _viewModel = NewConnectionViewModel(view: this);
    //_viewModel.updateConnections(id: widget.deviceDetail.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NewConnectionState>(
        initialData: UpdateConnectionDeviceInProgress(),
        stream: _viewModel.statesStream,
        builder: (context, snapshot) {
          final NewConnectionState state = snapshot.data!;

          final bool updateConnectionDeviceInProgress =
              state is UpdateConnectionDeviceInProgress;

          return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).toggleableActiveColor,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
                title: Text(
                  LocaleKeys.connections_new_connections.tr(),
                  style: GoogleFonts.openSans(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Theme.of(context).appBarTheme.color,
                actions: [
                  TextButton(
                    onPressed: saveChanges,
                    child: Text(LocaleKeys.all_save.tr(),
                        style: GoogleFonts.openSans(
                          color: Theme.of(context).toggleableActiveColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  SizedBox(
                    width: 16,
                  )
                ],
              ),
              body: Column(
                children: [
                  pronunciationWidget(),
                  statusConnectionWidget(),
                ],
              ));
        });
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        height: 36,
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).buttonColor,
        ),
      ),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    //await _viewModel.updateConnections(id: widget.deviceDetail.id);
  }

  Widget typeConnectionWidget() {
    return Text("123");
  }

  Widget nameConnectionWidget() {
    return Text("123");
  }

  Widget idChatWidget() {
    return Text("123");
  }

  TextEditingController controller = TextEditingController();

  Widget pronunciationWidget() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            style: GoogleFonts.openSans(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: "hintText",
              prefixIcon: Container(
                padding: EdgeInsets.only(left: 16, top: 8),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'This is no Link\n',
                    style: GoogleFonts.openSans(
                              color: Theme.of(context).colorScheme.secondaryVariant,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      TextSpan(
                        text: 'but this is',
                        style: GoogleFonts.openSans(
                                        color: Theme.of(context).toggleableActiveColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          print("tap ");
                        },
                      ),
                    ],
                  ),
                ),
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(
                //       "ID чата",
                //       style: GoogleFonts.openSans(
                //         color: Theme.of(context).colorScheme.secondaryVariant,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ),
                //     TextButton(
                //         onPressed: () {},
                //         child: Text("Как узнать id чата?",
                //             style: GoogleFonts.openSans(
                //               color: Theme.of(context).toggleableActiveColor,
                //               fontSize: 12,
                //               fontWeight: FontWeight.w600,
                //             )))
                //   ],
                // ),
              ),
              isDense: true,
              prefixIconConstraints:
                  BoxConstraints(minWidth: 140, minHeight: 0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget statusConnectionWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(children: [
        CupertinoSwitch(
          activeColor: Theme.of(context).toggleableActiveColor,
          value: switchValue,
          onChanged: (bool value) {
            setState(() {
              switchValue = value;
            });
          },
        ),
        SizedBox(
          width: 14,
        ),
        Text(
          switchValue
              ? LocaleKeys.all_on_full.tr()
              : LocaleKeys.all_off_full.tr(),
          style: GoogleFonts.openSans(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ]),
    );
  }

  void saveChanges() {}
}
