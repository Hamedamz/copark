import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class InfoWithReservation extends StatelessWidget {
  const InfoWithReservation({Key? key, required this.parkingNumber})
      : super(key: key);

  final num parkingNumber;

  Future<void> setUnreserved() async {
    ParseCloudFunction function = ParseCloudFunction('unReserveParkPlace');
    await function.execute();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                children: [
                  const Text('شماره پارکینگ شما'),
                  Text(parkingNumber.toString()),
                  MaterialButton(
                    onPressed: () => {
                    setUnreserved()
                  },
                    child: const Text('امروز نمیام'),
                  )
                ]
            )
        )
    );
  }
}
