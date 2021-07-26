import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                children: [
                  ...[
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.ltr,
                        hintText: 'foo@example.com',
                        labelText: 'ایمیل',
                      ),
                      autofillHints: [AutofillHints.email],
                    ),
                    const TextField(
                      obscureText: true,
                      textInputAction: TextInputAction.go,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'رمز عبور',
                      ),
                      autofillHints: <String>[AutofillHints.telephoneNumber],
                    ),
                    MaterialButton(
                      onPressed: _onLoginPressed,
                      child: const Text('ورود'),
                      color: Colors.blue,
                      elevation: 0,
                      minWidth: 400,
                      textColor: Colors.white,
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.pushNamed(context, '/signup')
                      },
                      child: const Text('ثبت‌نام'),
                    )
                  ].expand(
                    (widget) => [
                      widget,
                      const SizedBox(
                        height: 24,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginPressed() {
    Navigator.pushNamed(context, '/home');
  }
}