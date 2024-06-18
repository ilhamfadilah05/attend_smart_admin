import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(UserUnauthenticated());

  Future init() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.getString('token') != null) {
      emit(UserAuthenticated());
    } else {
      emit(UserUnauthenticated());
    }
  }
}
