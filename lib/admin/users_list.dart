import 'package:copark/data/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../static_models.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final pageSize = 10;
  bool isLoading = false;

  final List<User> _users = [];

  final textStyle = const TextStyle(color: Colors.white);

  @override
  void initState() {
    super.initState();
    initUsers();
  }

  Future _loadData() async {
    final response = await StaticModels.userRepo?.all(_users.length, pageSize);
    if (response != null && response.success && response.count > 0) {
      for (var user in response.results!) {
        _users.add(user);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void initUsers() async {
    isLoading = true;
    _loadData();
  }

  Widget _buildUsersList() {
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
    return ListTile(
      title: Text(_users[index].username ?? ''),
      trailing: Switch(
        onChanged: (value) => {},
        value: _users[index].isActive,
      ),
      onTap: () {
        setState(() {
          _users[index].isActive = !_users[index].isActive;
          _users[index].save();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadData();
          // start loading data
          setState(() {
            isLoading = true;
          });
          return true;
        }
        return true;
      },
      child: _buildUsersList(),
    );
  }
}
