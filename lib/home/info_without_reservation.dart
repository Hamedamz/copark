import 'package:flutter/material.dart';

class InfoWithoutReservation extends StatelessWidget {
  const InfoWithoutReservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                children: [
                  const Text('در این دوره پارکینگی را رزرو نکرده‌اید.'),
                  MaterialButton(
                    onPressed: () => Navigator.of(context).pushNamed('/find_parking'),
                    child: const Text('یافتن پارکینگ خالی'),
                  )
                ]
            )
        )
    );
  }
}
