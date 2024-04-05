import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_apps/bloc/user_bloc.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();

    _fetchUser();
  }

  void _fetchUser() {
    context.read<UserBloc>().add(FetchUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Page'),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is UserLoaded) {
              return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                    );
                  });
            } else if (state is UserError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<UserBloc>().add(GetUsers());
          },
          child: const Icon(Icons.refresh),
        ));
  }
}
