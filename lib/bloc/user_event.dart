part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class FetchUsers extends UserEvent {}

class GetUsers extends UserEvent {}

