part of 'login_bloc.dart';

@immutable
sealed class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged({required this.email});

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;
  LoginPasswordChanged({required this.password});

  @override
  List<Object> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LoginFailed extends LoginEvent {
  final String message;
  LoginFailed({required this.message});

  @override
  List<Object?> get props => [message];
}

class LogoutSubmitted extends LoginEvent {
  @override
  List<Object?> get props => [];
}
