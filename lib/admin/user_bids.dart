import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBids extends StatefulWidget {
  const UserBids({Key? key}) : super(key: key);

  @override
  _UserBidsState createState() => _UserBidsState();
}

class _UserBidsState extends State<UserBids> {
  final _saved = <UserInfo>{};     // NEW

  final List<UserInfo> _users = [
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
    UserInfo(email: 'email', bid: 1000),
  ];

  final textStyle = const TextStyle(color: Colors.white);

  Widget _buildParkingCols() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _users.length,
      itemBuilder: (context, i) {
        return _buildUser(i);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  Widget _buildUser(int index) {
    final alreadySaved = _saved.contains(_users[index]);

    return ListTile(
      title: Text(_users[index].email),
      trailing: Text(
        '${_users[index].bid} تومان ',
        style: const TextStyle(color: Colors.green),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildParkingCols(),
    );
  }
}

class UserInfo {
  UserInfo({required this.email, required this.bid});

  String email;
  int bid;
}
