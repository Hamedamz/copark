import 'package:flutter/material.dart';

class InfoWithoutReservation extends StatelessWidget {
  const InfoWithoutReservation({Key? key, required this.onFindPressed}) : super(key: key);

  final void Function() onFindPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                children: [
                  Image.asset('assets/images/no-parking.png', height: 100,),
                  const SizedBox(height: 20,),
                  const Text(
                    'در این دوره پارکینگی را رزرو نکرده‌اید.',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(color: Colors.white),
                            )
                        )
                    ),
                    onPressed: onFindPressed,
                    child: const Text(
                      'یافتن پارکینگ خالی',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ]
            )
        )
    );
  }
}
