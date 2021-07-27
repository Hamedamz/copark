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
            child: Column(children: [
              const Text(
                  'شماره پارکینگ شما',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    parkingNumber.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                    ),
                  ),
                  Icon(
                    Icons.local_parking,
                    color: Colors.green.shade300,
                    size: 60,
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.white),
                ))),
                onPressed: () => {
                  setUnreserved()
                },
                child: const Text(
                    'امروز نمیام',
                    style: TextStyle(color: Colors.white),
              ),
              )
            ]
          )
       )
    );
  }
}
