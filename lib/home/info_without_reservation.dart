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
                  const Text('در این دوره پارکینگی را رزرو نکرده‌اید.'),
                  MaterialButton(
                    onPressed: onFindPressed,
                    child: const Text('یافتن پارکینگ خالی'),
                  )
                ]
            )
        )
    );
  }
}
