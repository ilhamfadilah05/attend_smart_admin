part of 'session_cubit.dart';

sealed class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object> get props => [];
}

final class UserAuthenticated extends SessionState {}

final class UserUnauthenticated extends SessionState {}
