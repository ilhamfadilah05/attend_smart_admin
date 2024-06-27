import 'dart:convert';

import 'package:attend_smart_admin/models/account_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(AccountInitial());

  Future<AccountModel?> init() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    if (sharedPrefs.getString('dataUser') != null) {
      emit(AccountLoaded(AccountModel.fromJson(
          jsonDecode(sharedPrefs.getString('dataUser')!))));

      return AccountModel.fromJson(
          jsonDecode(sharedPrefs.getString('dataUser')!));
    } else {
      return null;
    }
  }
}
