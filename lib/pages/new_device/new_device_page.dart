import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/device/device.dart';
import 'package:flutter_app/models/device/device_detail.dart';
import 'package:flutter_app/pages/device_detail/device_detail_page.dart';
import 'package:flutter_app/pages/new_device/new_device_states.dart';
import 'package:flutter_app/pages/new_device/new_device_view.dart';
import 'package:flutter_app/pages/new_device/new_device_view_model.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/utils/common_ui/common_notification.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_text_field.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class NewDevicePage extends StatefulWidget {
  final DeviceDetail? device;

  const NewDevicePage({Key? key, this.device}) : super(key: key);

  @override
  _NewDevicePage createState() => _NewDevicePage();
}

class _NewDevicePage extends State<NewDevicePage>
    with NotificationsMixin
    implements NewDeviceView {
  final FocusNode identifierFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode phoneNumberFocus = FocusNode();
  final FocusNode loginFocus = FocusNode();
  final FocusNode passFocus = FocusNode();

  TextEditingController identifierController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController loginController = TextEditingController();
  TextEditingController passController = TextEditingController();

  late NewDeviceViewModel _viewModel;

  @override
  void initState() {
    _viewModel = NewDeviceViewModel(view: this);
    addDataInTextField();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
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
          (widget.device != null)
              ? LocaleKeys.all_edit.tr()
              : LocaleKeys.device_add.tr(),
          style: GoogleFonts.openSans(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
      ),
      body: SafeArea(
        child: StreamBuilder<NewDeviceState>(
          initialData: Idle(errors: {}),
          stream: _viewModel.statesStream,
          builder: (context, snapshot) {
            final NewDeviceState state = snapshot.data!;

            final bool addDeviceInProgress = state is AddDeviceInProgress;
            //final bool showErrorMessage = state is ShowErrorMessage;

            final Map<Field, String> fieldErrors = {};
            if (state is Idle) {
              fieldErrors.addAll(state.errors);
            }
            addDeviceInProgress ? showProgressBar() : EasyLoading.dismiss();
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Visibility(
                    visible: widget.device == null,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LocaleKeys.to_add_device.tr(),
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  AppTextField(
                    prefix: LocaleKeys.all_id.tr(),
                    focusNode: identifierFocus,
                    controller: identifierController,
                    enabled: (widget.device != null) ? false : true,
                    // initialValue: (widget.device!=null)? widget.device.udId : "",
                  ),
                  AppTextField(
                    prefix: LocaleKeys.all_name.tr(),
                    focusNode: nameFocus,
                    controller: nameController,
                    // initialValue: (widget.device!=null)? widget.device.name : "",
                  ),
                  AppTextField(
                    prefix: LocaleKeys.all_phone_number.tr(),
                    focusNode: phoneNumberFocus,
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    //initialValue: (widget.device!=null)? widget.device. :  "",
                  ),
                  SizedBox(
                    height: 29,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      LocaleKeys.tracker_sim_if_balance_required.tr(),
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AppTextField(
                    prefix: LocaleKeys.all_login_name.tr(),
                    focusNode: loginFocus,
                    controller: loginController,
                  ),
                  AppTextField(
                    prefix: LocaleKeys.all_password.tr(),
                    focusNode: passFocus,
                    controller: passController,
                  ),
                  SizedBox(
                    height: 41,
                  ),
                  Row(children: [
                    SizedBox(width: 16),
                    Expanded(
                      child: AppButton(
                        text: LocaleKeys.all_add.tr(),
                        enabled: true,
                        onPressed: () async {
                          _viewModel.sendAddNewDeviceButtonClicked(
                            udId: identifierController.text,
                            name: nameController.text,
                            phoneNumber: phoneNumberController.text,
                            simLogin: loginController.text,
                            simPassword: passController.text,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                  ]),
                  SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 16),
                      Text(
                        LocaleKeys.not_have_device.tr(),
                        style: GoogleFonts.openSans(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Flexible(
                        child: TextButton(
                            onPressed: () {},
                            child: Text(LocaleKeys.buy_device.tr(),
                                style: GoogleFonts.openSans(
                                  color: Theme.of(context).toggleableActiveColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ))),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void addDataInTextField() {
    if (widget.device?.udid != null) {
      identifierController.text = widget.device!.udid;
    }
    if (widget.device?.name != null) {
      nameController.text = widget.device!.name;
    }
    if (widget.device?.phoneNumber != null) {
      phoneNumberController.text = widget.device!.phoneNumber;
    }
    if (widget.device?.simLogin != null) {
      loginController.text = widget.device!.simLogin!;
    }
  }

  @override
  void closeNewDevicePage() {
    EasyLoading.dismiss();
    Navigator.pop(context);
  }

  void unFocusField() {
    // Unfocus all focus nodes
    identifierFocus.unfocus();
    nameFocus.unfocus();
    phoneNumberFocus.unfocus();
    loginFocus.unfocus();
    passFocus.unfocus();
  }

  void showProgressBar() {
    unFocusField();
    EasyLoading.show();
  }
}
