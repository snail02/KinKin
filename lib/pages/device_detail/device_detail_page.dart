import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/device/device.dart';
import 'package:flutter_app/pages/connections/connections_page.dart';
import 'package:flutter_app/pages/device_detail/device_detail_states.dart';
import 'package:flutter_app/pages/device_detail/device_detail_view.dart';
import 'package:flutter_app/pages/device_detail/device_detail_view_model.dart';
import 'package:flutter_app/pages/device_detail/events/events_page.dart';
import 'package:flutter_app/pages/new_device/new_device_page.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/utils/sound_player.dart';
import 'package:flutter_app/utils/text_state.dart';
import 'package:flutter_app/utils/url_image.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_command_button.dart';
import 'package:flutter_app/widgets/app_expanded_panel.dart';
import 'package:flutter_app/widgets/app_message_sender.dart';
import 'package:flutter_app/widgets/app_panel_commands.dart';
import 'package:flutter_app/widgets/app_panel_events.dart';
import 'package:flutter_app/widgets/app_panel_icons_notif.dart';
import 'package:flutter_app/widgets/app_panel_sim_balance.dart';
import 'package:flutter_app/widgets/app_text_field.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceDetailPage extends StatefulWidget {
  final Device device;

  const DeviceDetailPage({Key? key, required this.device}) : super(key: key);

  @override
  _DeviceDetailPageState createState() => _DeviceDetailPageState();
}

var refreshKey = GlobalKey<RefreshIndicatorState>();

class _DeviceDetailPageState extends State<DeviceDetailPage>
    with NotificationsMixin, AutomaticKeepAliveClientMixin<DeviceDetailPage>, SingleTickerProviderStateMixin
    implements DeviceDetailView {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  late DeviceDetailViewModel _viewModel;
  Completer<GoogleMapController> _controllerGoogleMaps = Completer();

  TextEditingController messageSenderController = TextEditingController();
  FocusNode messageSenderFocusNode = FocusNode();
  FocusNode buttonMessageSenderFocusNode = FocusNode();

  FlutterSound? flutterSound;
  FlutterSoundRecorder? myRecorder = FlutterSoundRecorder();
  FlutterSoundPlayer? myPlayer = FlutterSoundPlayer();

  StreamSubscription? _recorderSubscription;
  String _hintTextMessageSender = LocaleKeys.tracker_command_send_message.tr();
  String _recorderTxt = "00:00:00";
  int _durationMilliSec = 0;

  bool mRecorderIsInited = false;
  bool mPlayerIsInited = false;
  bool recording = false;
  bool isTextType = false;

  String ext = "mp4";
  String type = "voice";
  String? fileName;
  String? filePath;

  late double _scale;
  late AnimationController _controller = AnimationController(
    vsync: this,
    reverseDuration: Duration(
      milliseconds: 50,
    ),
    duration: Duration(
      milliseconds: 50,
    ),
    lowerBound: 0,
    upperBound: 0.57,
  );

  String buttonExpansionTile = "assets/images/right.svg";

  static ValueNotifier<String> currentUrlSound = ValueNotifier<String>("test");

  @override
  void initState() {
    _viewModel = DeviceDetailViewModel(view: this);
    _viewModel.updateDeviceDetail(id: widget.device.id);
    _viewModel.checkPermission();

    _recorderTxt = _hintTextMessageSender;

    myPlayer!.openAudioSession().then((value) {
      setState(() {
        mPlayerIsInited = true;
      });
    });

    myRecorder!.openAudioSession().then((value) {
      setState(() {
        mRecorderIsInited = true;
      });
    });

    messageSenderController.addListener(onChangeTextFormField);

    _controller
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  void playRecordedFile() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String filename = 'voiceMessage';
    await myPlayer!.startPlayer(
        fromURI: '$tempPath/$filename',
        codec: Codec.aacMP4,
        whenFinished: () {});
  }

  Future<void> durationRecord() async {
    _recorderSubscription = myRecorder!.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
      setState(() {
        _recorderTxt = txt.substring(0, 8);
        _durationMilliSec = e.duration.inMilliseconds;
      });
    });
  }

  Future<void> record() async {
    unFocusField();

    durationRecord();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    filePath = tempPath;
    fileName = 'voiceMessage';
    print("mRecorderIsInited = " + mRecorderIsInited.toString());
    print("mPlayerIsInited = " + mPlayerIsInited.toString());
    await myRecorder!.startRecorder(
      toFile: '$tempPath/$fileName',
      codec: Codec.aacMP4,
    );
  }

  Future<void> stopRecorder() async {
    _recorderSubscription!.pause();
    setState(() {
      _recorderTxt = _hintTextMessageSender;
    });
    await myRecorder!.stopRecorder();

    recording = false;

    if (fileName != null && filePath != null && _durationMilliSec > 1000) {
      _viewModel.uploadVoiceMessage(
          id: _viewModel.deviceDetail!.id,
          fileName: fileName!,
          filePath: filePath! + '/' + fileName!,
          type: type,
          ext: ext);
    }
  }

  @override
  void dispose() {
    myPlayer!.closeAudioSession();
    myPlayer = null;

    myRecorder!.closeAudioSession();
    myRecorder = null;

    _controller.dispose();
    super.dispose();
    cancelRecorderSubscriptions();
  }

  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
// make sure to initialize before map loading
      if (_viewModel.deviceDetail?.lastLocation?.lat != null &&
          _viewModel.deviceDetail?.lastLocation?.lon != null)
        _markers.add(
          Marker(
              markerId: MarkerId('your marker id'),
              position: LatLng(_viewModel.deviceDetail!.lastLocation!.lat!,
                  _viewModel.deviceDetail!.lastLocation!.lon!),
              icon: _viewModel.bitImage == null
                  ? BitmapDescriptor.defaultMarker
                  : BitmapDescriptor.fromBytes(_viewModel.bitImage!)),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DeviceDetailState>(
        initialData: UpdateDeviceDetailInProgress(),
        stream: _viewModel.statesStream,
        builder: (context, snapshot) {
          final DeviceDetailState state = snapshot.data!;

          final bool updateDeviceDetailInProgress =
              state is UpdateDeviceDetailInProgress;

          final bool sendingVoiceMessageInProgress =
              state is SendingDataInProgress;

          sendingVoiceMessageInProgress
              ? showProgressBar()
              : EasyLoading.dismiss();
          if (updateDeviceDetailInProgress) return _buildLoadingView();
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              shadowColor: Color.fromRGBO(0, 0, 0, 0.3),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Theme.of(context).toggleableActiveColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                _viewModel.deviceDetail?.name ?? "",
                style: GoogleFonts.openSans(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: Theme.of(context).appBarTheme.color,
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 5),
                  child: IconButton(
                    onPressed: openChangeDevicePage,
                    icon: SvgPicture.asset(
                      'assets/images/pen.svg',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                )
              ],
            ),
            body: RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cardDevice(),
                  AppPanelIconsNotif(
                    messageValue: _viewModel.deviceDetail?.messageNew,
                    notificationValue: _viewModel.deviceDetail?.alertNew,
                    flowersValue: _viewModel.settings?.sendFlowers?.value,
                    listenerOnTapFlowers: (valueSendFlowers) {
                      _viewModel.sendFlowers(
                        id: _viewModel.deviceDetail!.id,
                        flowers: valueSendFlowers,
                      );
                    },
                    onTapMessage: openEventsPage,
                    onTapNotification: openEventsPage,
                    onTapCall: call,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 355,
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                _viewModel.deviceDetail?.lastLocation?.lat ?? 0,
                                _viewModel.deviceDetail?.lastLocation?.lon ??
                                    0),
                            zoom: 15.4746,
                          ),
                          onMapCreated: _onMapCreated,
                          markers: _markers,
                          // _controllerGoogleMaps.complete(controller);
                          gestureRecognizers: Set()
                            ..add(Factory<EagerGestureRecognizer>(
                                () => EagerGestureRecognizer())),
                        )),
                  ),
                  if (_viewModel.deviceDetail?.getInfoOfSim() != null)
                    AppPanelSimBalance(
                        _viewModel.deviceDetail!.getInfoOfSim()!),
                  if (_viewModel.haveVoiceMessageCommands()) messageSender(),
                  if (_viewModel.events.length > 0)
                    AppPanelEvents(_viewModel.events, openEventsPage),
                  if (_viewModel.getAvailableCommands() != null &&
                      _viewModel.getAvailableCommands()!.length > 0)
                    AppPanelCommands(_viewModel.getAvailableCommands()!, (com) {
                      if(com.code == "send_flowers") {

                      }
                      else
                      _viewModel.sendCommand(
                          id: _viewModel.deviceDetail!.id,
                          commandCode: com.code,
                          command: com.command!);
                    }),
                  SizedBox(
                    height: 20,
                  ),
                  settingButton(),
                  SizedBox(
                    height: 41,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showProgressBar() {
    unFocusField();
    EasyLoading.show();
  }

  void unFocusField() {
    messageSenderFocusNode.unfocus();
    messageSenderFocusNode.canRequestFocus = false;
  }

  Widget messageSender() {
    _scale = 1 + _controller.value;
    return Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
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
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: TextField(
                  controller: messageSenderController,
                  focusNode: messageSenderFocusNode,
                  style: GoogleFonts.openSans(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10, right: 13),
                    hintStyle: GoogleFonts.openSans(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    hintText: _recorderTxt,
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
              onPointerDown: (details) {
                if (!isTextType) {
                  if (_viewModel.permission) {
                    _controller.forward();
                    print("record");
                    record();
                    recording = true;
                  } else
                    _viewModel.askPermission();
                }
                if (isTextType) {
                  _viewModel
                      .sendTextMessage(
                      id: _viewModel.deviceDetail!.id,
                      message: messageSenderController.text)
                      .then((value) {
                    if (value) {
                      setState(() {
                        messageSenderController.text = "";
                        isTextType = false;
                      });
                    }
                  });
                }
              },
              onPointerUp: (details) {
                if (!isTextType) {
                  _controller.reverse();
                  print("unPressMessageSender");
                  if (recording) {
                    print("stopRecorder");
                    stopRecorder();
                    _viewModel.updateDeviceDetail(
                        id: _viewModel.deviceDetail!.id);
                  }
                }
              },
              child: Transform.scale(
                scale: _scale,
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).buttonColor,
                    ),
                  child: Center(
                      child: (isTextType == false)
                          ? SvgPicture.asset(
                              "assets/images/microphone.svg",
                              color: Theme.of(context).primaryColor,
                              height: 26,
                            )
                          : SvgPicture.asset(
                              "assets/images/arrow.svg",
                              color: Theme.of(context).primaryColor,
                              height: 26,
                            ),
                  ),
                ),
              ),
              // child: RawMaterialButton(
              //   onPressed: () {
              //
              //   },
              //   elevation: 0.0,
              //   constraints: BoxConstraints(minWidth: 40.0, minHeight: 36.0),
              //   fillColor: Color.fromRGBO(47, 128, 237, 1),
              //   child: (isTextType == false)
              //       ? SvgPicture.asset(
              //           "assets/images/microphone.svg",
              //           color: Color.fromRGBO(255, 255, 255, 1),
              //           height: 26,
              //         )
              //       : SvgPicture.asset(
              //           "assets/images/arrow.svg",
              //           color: Color.fromRGBO(255, 255, 255, 1),
              //           height: 26,
              //         ),
              //   padding: EdgeInsets.all(10.0),
              //   shape: CircleBorder(),
              // ),
            ),
            SizedBox(
              width: 13,
            ),
          ],
        ));
  }

  Widget settingButton() {
    return GestureDetector(
      onTap: () {
        print("onTapSettingButton");
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 47,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/setting.svg',
              height: 24,
            ),
            Text(
              LocaleKeys.menu_settings.tr(),
              style: GoogleFonts.openSans(
                color: Theme.of(context).buttonColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cardDevice() {
    return ExpansionTileCard(
      key: cardA,
      elevation: 0,
      finalPadding: EdgeInsets.only(bottom: 0.0),
      borderRadius: BorderRadius.all(Radius.circular(0)),
      baseColor: Theme.of(context).primaryColor,
      expandedColor: Theme.of(context).primaryColor,
      trailing: Container(
        height: 50,
        width: 50,
        child: Center(
          child: Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Center(
              child: SvgPicture.asset(
                buttonExpansionTile,
                height: 10,
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ),
        ),
      ),
      onExpansionChanged: (value) {
        if (value)
          setState(() {
            buttonExpansionTile = "assets/images/left.svg";
          });
        else
          setState(() {
            buttonExpansionTile = "assets/images/right.svg";
          });
      },

      title: Container(
        height: 70,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                //color: Colors.red,
                color: Theme.of(context).accentColor,
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: EdgeInsets.all(10),
                child: (_viewModel.deviceDetail?.image == null)
                    ? Icon(Icons.error)
                    : CachedNetworkImage(
                        //imageUrl: imageUrl,
                        imageUrl:
                            UrlImage().url(_viewModel.deviceDetail!.image!),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    _viewModel.deviceDetail?.lastLocation
                            ?.getLastUpdateTime(context.locale.toString()) ??
                        "",
                    style: GoogleFonts.openSans(
                      color: Color.fromRGBO(6, 160, 68, 1),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    TextState().getText(
                        _viewModel.deviceDetail?.lastLocation?.state ?? ""),
                    style: GoogleFonts.openSans(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ]),
            Expanded(
                child: SizedBox(
              width: 10,
            )),
            Visibility(
              visible: _viewModel.deviceDetail?.battery == null ? false : true,
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _batteryIcon(_viewModel.deviceDetail?.battery ?? 100),
                    Text(
                      (_viewModel.deviceDetail?.battery == null)
                          ? " "
                          : _viewModel.deviceDetail!.battery!.toString() + '%',
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
      //subtitle: Text('I expand!'),
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_viewModel.deviceDetail?.udid != null)
                    Text(
                      LocaleKeys.all_id.tr() + ":",
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (_viewModel.deviceDetail?.trackerModel?.name != null)
                    Text(
                      LocaleKeys.all_model.tr() + ":",
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (_viewModel.deviceDetail?.phoneNumber != null)
                    Text(
                      LocaleKeys.all_telephone.tr() + ":",
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primaryVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
              SizedBox(
                width: 13,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_viewModel.deviceDetail?.udid != null)
                    Text(
                      _viewModel.deviceDetail?.udid ?? "",
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (_viewModel.deviceDetail?.trackerModel?.name != null)
                    Text(
                      _viewModel.deviceDetail?.trackerModel?.name ?? '',
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (_viewModel.deviceDetail?.phoneNumber != null)
                    Text(
                      _viewModel.deviceDetail?.phoneNumber ?? "",
                      style: GoogleFonts.openSans(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await _viewModel.updateDeviceDetail(id: widget.device.id);
  }

  Widget _buildLoadingView() {
    return Center(
      child: Container(
        height: 36,
        child: CircularProgressIndicator(
        ),
      ),
    );
  }

  Widget _batteryIcon(int value) {
    if (value == 0)
      return SvgPicture.asset(
        'assets/images/battery_0.svg',
        height: 27,
        color: Theme.of(context).colorScheme.primary,
      );
    if (value > 0 && value < 50)
      return SvgPicture.asset(
        'assets/images/battery_25.svg',
        height: 27,
        color: Theme.of(context).colorScheme.primary,
      );
    if (value >= 50 && value < 75)
      return SvgPicture.asset(
        'assets/images/battery_50.svg',
        height: 27,
        color: Theme.of(context).colorScheme.primary,
      );
    if (value >= 75 && value < 100)
      return SvgPicture.asset(
        'assets/images/battery_75.svg',
        height: 27,
        color: Theme.of(context).colorScheme.primary,
      );
    if (value == 100)
      return SvgPicture.asset(
        'assets/images/battery_100.svg',
        height: 27,
        color: Theme.of(context).colorScheme.primary,
      );
    return SvgPicture.asset(
      'assets/images/battery_100.svg',
      height: 27,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  void openChangeDevicePage() {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: NewDevicePage(
              device: _viewModel.deviceDetail,
            )));
  }

  void onChangeTextFormField() {
    String text = messageSenderController.text;
    bool hasFocus = messageSenderFocusNode.hasFocus;
    if (text != "")
      setState(() {
        isTextType = true;
      });
    else
      setState(() {
        isTextType = false;
      });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


    Future<void> call() async{
      if(_viewModel.deviceDetail?.phoneNumber!=null) {
        String tel = "tel:";
        if(_viewModel.deviceDetail!.phoneNumber.substring(0,1)!='8' && _viewModel.deviceDetail!.phoneNumber.substring(0,1)!='+')
          tel+='+';
        if (await canLaunch(tel + _viewModel.deviceDetail!.phoneNumber)) {
          await launch(tel + _viewModel.deviceDetail!.phoneNumber);
        } else {
          throw 'call not possible';
        }
      }
    }



  @override
  void openEventsPage() {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ConnectionsPage(
                deviceDetail: _viewModel.deviceDetail!,
              )),
    );
  }
}
