import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/common/auth/login/login_states.dart';
import 'package:flutter_app/pages/common/auth/login/login_view.dart';
import 'package:flutter_app/pages/common/auth/login/login_view_model.dart';
import 'package:flutter_app/pages/common/auth/registration/registration_page.dart';
import 'package:flutter_app/pages/common/forgot_password/forgot_password_page.dart';
import 'package:flutter_app/pages/primary/primary_page.dart';
import 'package:flutter_app/translations/locale_keys.g.dart';
import 'package:flutter_app/utils/common_ui/notifications_mixin.dart';
import 'package:flutter_app/widgets/app_button.dart';
import 'package:flutter_app/widgets/app_text_field.dart';
import 'package:flutter_app/widgets/app_message_error.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_app/provider/theme_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with NotificationsMixin
    implements LoginView {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passwordFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  late LoginViewModel _viewModel;

  @override
  void initState() {
    _viewModel = LoginViewModel(view: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: GestureDetector(
        child: SafeArea(
          child: StreamBuilder<LoginState>(
            initialData: Idle(errors: {}),
            stream: _viewModel.statesStream,
            builder: (context, snapshot) {
              final LoginState state = snapshot.data!;

              final bool loginInProgress = state is LoginInProgress;
              final bool showErrorMessage = state is ShowErrorMessage;

              final Map<Field, String> fieldErrors = {};
              if (state is Idle) {
                fieldErrors.addAll(state.errors);
              }
              loginInProgress ? showProgressBar() : EasyLoading.dismiss();
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        LocaleKeys.login_login.tr(),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        LocaleKeys.login_welcome.tr(),
                        maxLines: 3,
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 18),
                    AppTextField(
                      prefix: LocaleKeys.all_email.tr(),
                      controller: emailController,
                      focusNode: emailFocusNode,
                    ),
                    AppTextField(
                      prefix: LocaleKeys.all_password.tr(),
                      suffix: LocaleKeys.login_forgot.tr(),
                      hideText: true,
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      obscuringCharacter: '*',
                      onPressedSuffix: openForgotPasswordPage,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    _buildErrorMsg(
                      visible: _viewModel.isLoginError,
                      // visible: showErrorMessage,
                      errorText: fieldErrors[Field.ERROR_MSG] ?? "",
                    ),
                    SizedBox(height: 31),
                    Row(children: <Widget>[
                      SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          enabled: true,
                          text: LocaleKeys.login_login.tr(),
                          onPressed: () async {
                            _viewModel.sendLoginButtonClicked(
                                email: emailController.text,
                                password: passwordController.text);
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
                          LocaleKeys.login_newUser.tr(),
                          style: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.primaryVariant,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextButton(
                            onPressed: openRegistrationPage,
                            child: Text(LocaleKeys.register_register.tr(),
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
            },
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    unFocusField();
    return Center(
      child:
          Container(width: 32, height: 32, child: CircularProgressIndicator()),
    );
  }

  void showLoaderDialog() {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showMyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            backgroundColor: Theme.of(context).primaryColor,
            content: Container(
                width: 32, height: 32, child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _buildErrorMsg({
    required bool visible,
    required String errorText,
  }) {
    return _buildErrorMessageContent(
      visible: visible,
      errorText: errorText,
    );
  }

  Widget _buildErrorMessageContent({
    required bool visible,
    required String errorText,
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
              text: errorText,
            ),
          ),
          SizedBox(width: 16),
        ]),
      ),
    );
  }

  void openPrimaryPage() {
    EasyLoading.dismiss();
    Navigator.of(context).pushReplacement(
        PageTransition(type: PageTransitionType.fade, child: PrimaryPage()));
  }

  @override
  void openRegistrationPage() {
    unFocusField();
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: RegistrationPage()));
  }

  void unFocusField() {
    // Unfocus all focus nodes
    passwordFocusNode.unfocus();
    emailFocusNode.unfocus();

    // Disable text field's focus node request
    passwordFocusNode.canRequestFocus = false;
    emailFocusNode.canRequestFocus = false;

    //Enable the text field's focus node request after some delay
    Future.delayed(Duration(milliseconds: 100), () {
      passwordFocusNode.canRequestFocus = true;
      emailFocusNode.canRequestFocus = true;
    });
  }

  void showProgressBar() {
    unFocusField();
    EasyLoading.show();
  }

  @override
  void openForgotPasswordPage() {
    unFocusField();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
    );
  }
}
