// ignore_for_file: override_on_non_overriding_member

part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  bool get isValidEmail =>
      email.contains(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'));

  final String password;
  bool get isValidPassword => password.length >= 6;

  final FormSubmissionStatus formStatus;

  const LoginState({
    this.email = '',
    this.password = '',
    this.formStatus = const InitialFormStatus(),
  });

  LoginState copyWith({
    String? email,
    String? password,
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      formStatus: formStatus ?? this.formStatus,
    );
  }

  @override
  List<Object> get props => [email, password, formStatus];
}

abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FormSubmitting extends FormSubmissionStatus {}

class SubmissionLoading extends FormSubmissionStatus {}

class SubmissionSuccess extends FormSubmissionStatus {}

class SubmissionFailed extends FormSubmissionStatus {
  final String errorMessage;

  SubmissionFailed({required this.errorMessage});

  List<Object> get props => [errorMessage];
}

// @immutable
// sealed class LoginState {}

// final class LoginInitial extends LoginState {}

// final class LoginLoading extends LoginState {}

// final class LoginSuccess extends LoginState {
//   final String token;

//   LoginSuccess({required this.token});

//   List<Object> get props => [token];
// }

// final class LoginFailed extends LoginState {
//   final String message;

//   LoginFailed({required this.message});

//   List<Object> get props => [message];
// }
