import 'package:copark/user_model.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'constants.dart';
import 'custom_route.dart';
import 'dashboard_screen.dart';
import 'users.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      ParseUser user = ParseUser(data.name, data.password, null);
      ParseResponse response = await user.login();
      if (response.success) {
        UserModel.user = user;
        return null;
      }
      else {
        return 'نام کاربری یا رمز عبور نادرست است';
      }
    });
  }

  Future<String?> _signUp(LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      ParseUser user = ParseUser(data.name, data.password, null); //TODO: email
      ParseResponse userResponse = await user.signUp();
      if (userResponse.success) {
          user = userResponse.result;
        }
      ParseResponse response = await user.login();
      if (response.success) {
        UserModel.user = user;
        return null;
      }
      else {
        return 'خطا در ساختن حساب کاربری';
      }
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'کاربر وجود ندارد';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      logo: 'assets/images/ecorp.png',
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      // hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,
      messages: LoginMessages(
        userHint: 'کاربر',
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
        accentColor: Colors.yellow,
        errorColor: Colors.deepOrange,
        pageColorLight: Colors.indigo.shade300,
        pageColorDark: Colors.indigo.shade500,
        logoWidth: 0.80,
        titleStyle: const TextStyle(
          color: Colors.greenAccent,
          fontFamily: 'Vazir',
          letterSpacing: 4,
        ),
      // buttonTheme: LoginButtonTheme(
      //   splashColor: Colors.purple,
      //   backgroundColor: Colors.pinkAccent,
      //   highlightColor: Colors.lightGreen,
      //   elevation: 9.0,
      //   highlightElevation: 6.0,
      //   shape: BeveledRectangleBorder(
      //     borderRadius: BorderRadius.circular(10),
      //     ),
      //   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //   // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //   // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      ),
      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.orange,
      //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
      //   buttonStyle: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Colors.yellow,
      //   ),
      //   cardTheme: CardTheme(
      //     color: Colors.yellow.shade100,
      //     elevation: 5,
      //     margin: EdgeInsets.only(top: 15),
      //     shape: ContinuousRectangleBorder(
      //         borderRadius: BorderRadius.circular(100.0)),
      //   ),
      //   inputTheme: InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.purple.withOpacity(.1),
      //     contentPadding: EdgeInsets.zero,
      //     errorStyle: TextStyle(
      //       backgroundColor: Colors.orange,
      //       color: Colors.white,
      //     ),
      //     labelStyle: TextStyle(fontSize: 12),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      // ),
      userValidator: (value) {
        // if (!value!.contains('@')) {
        //   return "ایمیل نامعتبر";
        // }
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
          builder: (context) => DashboardScreen(),
        ));
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: true,
    );
  }
}