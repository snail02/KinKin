import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/common/auth/login/login_page.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_states.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_successful_page.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_view.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_view_mode.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_message_error.dart';
import 'package:flutter_app/widgets/app_text_field.dart';
import 'package:flutter_app/widgets/app_text_link.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPage createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage>
    with NotificationsMixin
    implements RegistrationView {
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  final TapGestureRecognizer recognizer1 = TapGestureRecognizer();
  final TapGestureRecognizer recognizer2 = TapGestureRecognizer();

  bool _agreement = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showErrorMessage = false;

  late RegistrationViewModel _viewModel;

  @override
  void initState() {
    _viewModel = RegistrationViewModel(view: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        child: SafeArea(
          child: StreamBuilder<RegistrationState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final RegistrationState state = snapshot.data!;

              final bool registrationInProgress =
                  state is RegistrationInProgress;
              showErrorMessage = state is ShowErrorMessage;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              registrationInProgress
                  ? showProgressBar()
                  : EasyLoading.dismiss();
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 75),
                    Image.asset(
                      'assets/images/KinKin.png',
                      width: 90,
                      height: 80,
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LocaleKeys.register_new.tr(),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LocaleKeys.register_enterData.tr(),
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 18),
                    AppTextField(
                      prefix: LocaleKeys.all_name.tr(),
                      controller: nameController,
                      focusNode: nameFocus,
                      //focusNode: nameFocus,
                    ),
                    AppTextField(
                      prefix: LocaleKeys.all_email.tr(),
                      controller: emailController,
                      focusNode: emailFocus,
                    ),
                    AppTextField(
                      prefix: LocaleKeys.all_password.tr(),
                      controller: passwordController,
                      focusNode: passFocus,
                    ),
                    SizedBox(height: 35),

                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Checkbox(
                          value: _agreement,
                          onChanged: (value) =>onChangedCheckBox(value!),
                        ),
                        AppTextLink(
                          prefix: "I agree with our",
                          between: "and",
                          text1: "Terms",
                          text2: "Conditions",
                          recognizer1: recognizer1,
                          recognizer2: recognizer2,
                          onTap1: onTapFirstTextLink,
                          onTap2: onTapSecondTextLink,
                        ),
                        SizedBox(
                          width: 16,
                        )
                      ],
                    ),
                    SizedBox(height: 22),
                    _buildErrorMsg(
                      visible: _viewModel.isRegistartionError,
                      errorText: fieldErrors[Field.ERROR_MSG] != null
                          ? fieldErrors[Field.ERROR_MSG]
                          : " ",
                    ),
                    SizedBox(height: 25),
                    Row(children: <Widget>[
                      SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          enabled: true,
                          text: LocaleKeys.register_register.tr(),
                          onPressed: () async {
                            _viewModel.sendCreateAccountButtonClicked(
                              name: nameController.text,
                              email: emailController.text,
                              password: passwordController.text,
                              agreement: _agreement,
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                    ]),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 16),
                        Text(
                          LocaleKeys.register_already.tr(),
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                            onPressed: openLoginPage,
                            child: Text(LocaleKeys.login_login.tr(),
                                style: GoogleFonts.openSans(
                                  color: Theme.of(context).toggleableActiveColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ))),
                        SizedBox(width: 16),
                      ],
                    ),
                    //if (registrationInProgress) _buildLoadingView(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    unFocusField();
    return Expanded(
      child: Center(
        child: Container(
          color: Color.fromRGBO(255, 255, 255, 0.6),
          child: Center(
            child: Container(
                width: 32, height: 32, child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  void unFocusField() {
    // Unfocus all focus nodes
    passFocus.unfocus();
    nameFocus.unfocus();
    emailFocus.unfocus();

  }

  void showProgressBar(){
    unFocusField();
    EasyLoading.show();
  }

  void onChangedCheckBox(bool value) {
    setState(() {
      _agreement = value;
    });
  }

  Widget _buildErrorMsg({
    required bool visible,
    String? errorText,
  }) {
    return _buildErrorMessageContent(
      visible: visible,
      errorText: errorText?? " ",
    );
  }

  Widget _buildErrorMessageContent({
    required bool visible,
    String? errorText,
  }) {
    return Visibility(
      maintainAnimation: true,
      maintainSize: true,
      maintainState: true,
      visible: visible,
      child: Container(
        child: Row(children: <Widget>[
          SizedBox(width: 16),
          Expanded(
            child: AppMessageError(
              //text: "Неправильный пароль",
              text: errorText?? " ",
            ),
          ),
          SizedBox(width: 16),
        ]),
      ),
    );
  }

  void onTapFirstTextLink() {
    _viewModel.openWebsiteTermsConditions();
  }

  void onTapSecondTextLink() {
    _viewModel.openWebsitePrivacyPolicy();
  }

  @override
  void openLoginPage() {
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: LoginPage()),
        (Route<dynamic> route) => false);
  }

  @override
  void openRegistrationSuccessfulPage() {
    EasyLoading.dismiss();
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            type: PageTransitionType.fade, child: RegistrationSuccessfulPage()),
        (Route<dynamic> route) => false);
  }
}
