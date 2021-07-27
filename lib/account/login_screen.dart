import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import '../app.dart';
import '../constants.dart';
import '../custom_route.dart';
import '../static_models.dart';
import '../users.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      ParseUser user = ParseUser(data.name, data.password, null);
      ParseResponse response = await user.login();
      if (response.success) {
        StaticModels.user = user;
        return null;
      }
      else {
        return 'نام کاربری یا رمز عبور نادرست است';
      }
    });
  }

  Future<String?> _signUp(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      ParseUser user = ParseUser(data.name, data.password, data.name);
      ParseResponse userResponse = await user.signUp();
      if (userResponse.success) {
          user = userResponse.result;
        }
      ParseResponse response = await user.login();
      if (response.success) {
        StaticModels.user = user;
        return null;
      }
      else {
        return 'خطا در ساختن حساب کاربری';
      }
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) async {
      ParseUser user = ParseUser(null, null, name);
      ParseResponse response = await user.requestPasswordReset();
      if (response.success) {
        return null;
      }
      return 'بازنشانی رمز عبور موفق نبود.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/images/parking.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,
      messages: LoginMessages(
        userHint: 'ایمیل',
        passwordHint: 'رمز عبور',
        confirmPasswordHint: 'تایید',
        loginButton: 'ورود',
        signupButton: 'ثبت‌نام',
        forgotPasswordButton: 'فراموشی رمز عبور',
        recoverPasswordButton: 'ارسال رمز',
        goBackButton: 'برگشت',
        confirmPasswordError: 'تطابق ندارد',
        recoverPasswordIntro: 'فراموشی رمز عبور',
        recoverPasswordDescription: 'ایمیل خود را وارد کنید تا ایمیل فراموشی به آن ارسال شود.',
        recoverPasswordSuccess: 'رمز عبور با موفقیت تغییر کرد',
        flushbarTitleError: 'خطا',
        flushbarTitleSuccess: 'موفقیت',
      ),
      theme: LoginTheme(
        primaryColor: Colors.blueAccent,
        accentColor: Colors.white,
        errorColor: Colors.red.shade600,
        pageColorLight: Colors.blue.shade400,
        pageColorDark: Colors.indigoAccent,
        logoWidth: 0.80,
      ),
      userValidator: (value) {
        if (!value!.contains('@')) {
          return "ایمیل نامعتبر";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'رمز عبور را وارد کنید';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _signUp(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => const App(),
        ));
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }
}