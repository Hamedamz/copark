import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Parking extends StatefulWidget {
  const Parking({Key? key}) : super(key: key);

  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  final List<ParkingSlot> _parking = [
    ParkingSlot(number: 1, state: ParkingState.free),
    ParkingSlot(number: 2, state: ParkingState.full),
    ParkingSlot(number: 3, state: ParkingState.full),
    ParkingSlot(number: 4, state: ParkingState.reserved),
    ParkingSlot(number: 5, state: ParkingState.full),
    ParkingSlot(number: 6, state: ParkingState.free),
    ParkingSlot(number: 7, state: ParkingState.full),
    ParkingSlot(number: 8, state: ParkingState.full),
    ParkingSlot(number: 9, state: ParkingState.free),
    ParkingSlot(number: 10, state: ParkingState.full),
    ParkingSlot(number: 11, state: ParkingState.free),
  ];

  final textStyle = const TextStyle(color: Colors.white);

  Widget _buildParkingCols() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: (_parking.length / 2).ceil(),
      itemBuilder: (context, i) {
        final index = i * 2;
        return _buildParkingSlot(index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return Row(
          children: [
            Expanded(
                child: Container(
              color: Colors.amber,
              height: 8,
            )),
            Container(
              height: 8,
              width: 30,
              color: Colors.green,
            ),
            Expanded(
                child: Container(
              color: Colors.amber,
              height: 8,
            )),
          ],
        );
      },
    );
  }

  Widget _buildParkingSlot(int index) {
    return Row(
      children: [
        Expanded(
            child: Row(
          children: [
            Text(
              _parking[index].number.toString(),
              textAlign: TextAlign.right,
              style: textStyle,
            ),
            Expanded(child: _buildSingleParkSlot(index)),
          ],
        )),
        Container(
          width: 30,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: index == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0))
                : index == ((_parking.length - 1) / 2).ceil() * 2
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))
                    : null,
          ),
        ),
        Expanded(
          child: index + 1 < _parking.length
              ? Row(
                  children: [
                    Expanded(child: _buildSingleParkSlot(index + 1)),
                    Text(
                      _parking[index + 1].number.toString(),
                      textAlign: TextAlign.left,
                      style: textStyle,
                    ),
                  ],
                )
              : const Text(''),
        ),
      ],
    );
  }

  Widget _buildSingleParkSlot(index) {
    var imagePath = _parking[index].state == ParkingState.full
        ? 'assets/images/car-top-view.png'
        : 'assets/images/car-top-view-grey.png';

    var message = _parking[index].state == ParkingState.full
        ? 'این پارکینگ پر است'
        : _parking[index].state == ParkingState.reserved
        ? 'این پارکینگ رزور شده است'
        : 'روزو انجام شد';

    return TextButton(
        onPressed: () {
          if (_parking[index].state == ParkingState.free) {
            // todo handle reserve
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              // action: SnackBarAction(
              //   label: 'Action',
              //   onPressed: () {
              //     // Code to execute.
              //   },
              // ),
            ),
          );
        },
        child: _parking[index].state == ParkingState.free
            ? const Text('رزرو')
            : RotatedBox(
                quarterTurns: index.isOdd ? 1 : -1,
                child: Image.asset(
                  imagePath,
                  width: 60,
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: _buildParkingCols(),
    );
  }
}

class ParkingSlot {
  ParkingSlot({required this.number, required this.state});

  int number;
  ParkingState state;
}

enum ParkingState { free, reserved, full }
