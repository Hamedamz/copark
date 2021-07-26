import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.ltr,
                        labelText: 'نام و نام خانوادگی',
                      ),
                      autofillHints: [AutofillHints.email],
                    ),
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        hintTextDirection: TextDirection.ltr,
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
                    const TextField(
                      obscureText: true,
                      textInputAction: TextInputAction.go,
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'تکرار رمز عبور',
                      ),
                      autofillHints: <String>[AutofillHints.telephoneNumber],
                    ),
                    MaterialButton(
                      onPressed: _onLoginPressed,
                      child: const Text('ثبت‌نام'),
                      color: Colors.blue,
                      elevation: 0,
                      minWidth: 400,
                      textColor: Colors.white,
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.pushNamed(context, '/login')
                      },
                      child: const Text('ورود'),
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