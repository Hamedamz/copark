import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _saved = <UserInfo>{};     // NEW

  final List<UserInfo> _users = [
    UserInfo(email: 'email'),
    UserInfo(email: 'email'),
    UserInfo(email: 'email'),
    UserInfo(email: 'email'),
    UserInfo(email: 'email'),
    UserInfo(email: 'email'),
    UserInfo(email: 'email'),
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
      trailing: Switch(
        onChanged: (value) => {},
        value: alreadySaved,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(_users[index]);
          } else {
            _saved.add(_users[index]);
          }
        });
      },
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
  UserInfo({required this.email});

  String email;
}
