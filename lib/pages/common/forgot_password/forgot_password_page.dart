import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/common/auth/login/login_page.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_send_mail_page.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_states.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_view.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_view_mode.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_text_field.dart';
import 'package:flutter_app/widgets/app_message_error.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage>
    with NotificationsMixin
    implements ForgotPasswordView {
  final FocusNode emailFocus = FocusNode();
  final TapGestureRecognizer recognizer = TapGestureRecognizer();
  TextEditingController emailController = TextEditingController();

  bool showErrorMessage = false;

  late ForgotPasswordViewModel _viewModel;

  @override
  void initState() {
    _viewModel = ForgotPasswordViewModel(view: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        child: SafeArea(
          child: StreamBuilder<ForgotPasswordState>(
              initialData: Idle(errors: {}),
              stream: _viewModel.statesStream,
              builder: (context, snapshot) {
                final ForgotPasswordState state = snapshot.data!;

                final bool forgotPasswordInProgress =
                    state is ForgotPasswordInProgress;
                showErrorMessage = state is ShowErrorMessage;

                final Map<Field, String> fieldErrors = {};
                if (state is Idle) {
                  fieldErrors.addAll(state.errors);
                }
                forgotPasswordInProgress
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
                      SizedBox(height: 12),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          LocaleKeys.login_forgot.tr(),
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          LocaleKeys.forgot_enterData.tr(),
                          maxLines: 3,
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 18),
                      AppTextField(
                        prefix: LocaleKeys.all_email.tr(),
                        focusNode: emailFocus,
                        controller: emailController,
                      ),
                      SizedBox(height: 33),
                      _buildErrorMsg(
                        visible: _viewModel.isForgotPasswordError,
                        errorText: fieldErrors[Field.ERROR_MSG],
                      ),
                      SizedBox(height: 33),
                      Row(children: <Widget>[
                        SizedBox(width: 16),
                        Expanded(
                          child: AppButton(
                            enabled: true,
                            text: LocaleKeys.all_send.tr(),
                            onPressed: () async {
                              _viewModel.sendForgotPasswordButtonClicked(
                                email: emailController.text,
                                lang: EasyLocalization.of(context)!.currentLocale!.languageCode.toString(),
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
                          TextButton(
                              onPressed: openLoginPage,
                              child: Text(LocaleKeys.menu_back_login.tr() + " ",
                                  style: GoogleFonts.openSans(
                                    color: Theme.of(context).toggleableActiveColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ))),
                          SizedBox(width: 16),
                        ],
                      ),
                    ],
                  ),
                );
              }), // This trailing comma makes auto-formatting nicer for build methods.
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
    emailFocus.unfocus();
  }

  void showProgressBar(){
    unFocusField();
    EasyLoading.show();
  }

  Widget _buildErrorMsg({
    required bool visible,
    String? errorText,
  }) {
    return _buildErrorMessageContent(
      visible: visible,
      errorText: errorText,
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

  void openLoginPage() {
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(type: PageTransitionType.fade, child: LoginPage()),
        (Route<dynamic> route) => false);
  }

  void openForgotPasswordSendMailPage() {
    EasyLoading.dismiss();
    Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            type: PageTransitionType.fade, child: ForgotPasswordSendMailPage()),
        (Route<dynamic> route) => false);
  }
}
