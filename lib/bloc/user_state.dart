part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserFetchSucces extends UserState {
  final String message;

  UserFetchSucces(this.message);
}

final class UserError extends UserState {
  final String message;

  UserError(this.message);
}

final class UserLoaded extends UserState {
  final List<Datum> users;

  UserLoaded(this.users);
}
