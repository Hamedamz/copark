import 'package:copark/data/model/park_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Parking extends StatefulWidget {
  const Parking({Key? key}) : super(key: key);

  @override
  _ParkingState createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  List<ParkPlace>? _parking = null;

  final textStyle = const TextStyle(color: Colors.white);
  String message = '';

  Widget _buildParkingCols() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: (_parking!.length / 2).ceil(),
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
              _parking![index].number.toString(),
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
                : index == ((_parking!.length - 1) / 2).ceil() * 2
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0))
                    : null,
          ),
        ),
        Expanded(
          child: index + 1 < _parking!.length
              ? Row(
                  children: [
                    Expanded(child: _buildSingleParkSlot(index + 1)),
                    Text(
                      _parking![index + 1].number.toString(),
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
    var imagePath = 'assets/images/car-top-view.png';

    return TextButton(
        onPressed: () {
          if (_parking![index].owner == null) {
            reserveParkPlace(index);
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
        child: _parking![index].owner == null
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
    if (_parking == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      color: Colors.grey.shade800,
      child: _buildParkingCols(),
    );
  }

  @override
  void initState() {
    super.initState();
    getParkList();
  }

  Future<void> reserveParkPlace(int index) async {
    ParseCloudFunction function = ParseCloudFunction('reserveParkPlace');
    ParseResponse response =
        await function.execute(parameters: {'number': index + 1});
    ParseUser user = await ParseUser.currentUser();
    if (response.success) {
      setState(() {
        message = 'رزرو انجام شد';
        _parking![index].owner = user;
      });
    } else {
      setState(() {
        message = response.error!.message;
      });
    }
  }

  Future<void> getParkList() async {
    QueryBuilder<ParkPlace> query = QueryBuilder(ParkPlace())
      ..whereEqualTo('isActive', true);
    ParseResponse response = await query.query();
    print(response);
    setState(() {
      _parking = response.results!.cast<ParkPlace>();
    });
  }
}