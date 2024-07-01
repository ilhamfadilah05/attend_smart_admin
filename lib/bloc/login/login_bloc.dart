// ignore_for_file: depend_on_referenced_packages

import 'package:attend_smart_admin/models/account_model.dart';
import 'package:attend_smart_admin/repository/login/login_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository? loginRepo;
  LoginBloc({required this.loginRepo}) : super(const LoginState()) {
    on<LoginEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }
  Future mapEventToState(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginEmailChanged) {
      emit(state.copyWith(
          email: event.email, formStatus: const InitialFormStatus()));
    } else if (event is LoginPasswordChanged) {
      emit(state.copyWith(
          password: event.password, formStatus: const InitialFormStatus()));
    } else if (event is LoginSubmitted) {
      emit(state.copyWith(formStatus: SubmissionLoading()));
      try {
        var result = await loginRepo?.login(
            password: event.password,
            email: event.email,
            state: state,
            emit: emit);
        if (result != null) {
          AccountModel account = AccountModel.fromJson(result[0].data());
          if (account.role == 'super_admin') {
            emit(state.copyWith(
              formStatus: SubmissionSuccess(),
              account: account,
            ));
          } else {
            emit(state.copyWith(
                formStatus: SubmissionFailed(),
                errorMessage: 'Akun anda tidak berhak mengakses web ini!'));
          }
        }
      } catch (e) {
        emit(state.copyWith(
            formStatus: SubmissionFailed(), errorMessage: e.toString()));
      }
    } else if (event is LogoutSubmitted) {
      emit(state.copyWith(
          email: null, password: null, formStatus: const InitialFormStatus()));
    }
  }
}
