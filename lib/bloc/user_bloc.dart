import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_apps/databases/user_database.dart';
import 'package:sqflite_apps/models/user_model.dart';
import 'package:http/http.dart' as http;

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  static const baseUrl = 'https://reqres.in/api/users';
  static final dio = Dio();
  UserBloc() : super(UserInitial()) {
    fetchUser();
    getUsers();
  }

  void getUsers() {
    return on<GetUsers>((event, emit) async {
      try {
        emit(UserLoading());
        final users = await UserDatabaseHelper.instance.getUsers();

        final List<Datum> userList = users
            .map((user) => Datum(
                  id: user['id'],
                  firstName: user['first_name'],
                  lastName: user['last_name'],
                  email: user['email'],
                  avatar: user['avatar'],
                ))
            .toList();

        emit(UserLoaded(userList));
      } catch (e) {
        emit(UserError('Error get User $e'));
      }
    });
  }

  void fetchUser() {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final response = await http.get(Uri.parse(baseUrl));
        if (response.statusCode == 200) {
          final Map<String, dynamic> convert = jsonDecode(response.body);

          final User userModel = User.fromJson(convert);

          for (final item in userModel.data) {
            final Datum userDatum = Datum(
              id: item.id,
              firstName: item.firstName,
              lastName: item.lastName,
              email: item.email,
              avatar: item.avatar,
            );

            log('User: ${userDatum.firstName} ${userDatum.lastName}');

            await UserDatabaseHelper.instance.insertUser(userDatum.toMap());
          }

          emit(UserFetchSucces('Users fetched successfully'));
          log('Users fetched successfully');
        } else {
          emit(UserError('Error ${response.statusCode}'));
        }
      } catch (e) {
        emit(UserError('Error fetching User: $e'));
      }
    });
  }
}
