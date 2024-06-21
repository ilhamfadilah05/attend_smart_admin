import 'dart:convert';

import 'package:attend_smart_admin/bloc/login/login_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future login(
      {required String password,
      required String email,
      required LoginState state,
      required Emitter<LoginState> emit}) async {
    try {
      var result = await firestore
          .collection('account')
          .where('email', isEqualTo: email)
          .get();

      if (result.docs.isEmpty) {
        emit(state.copyWith(
            formStatus: SubmissionFailed(),
            errorMessage: 'Akun Tidak Di Temukan!'));
      } else {
        var data = result.docs[0];
        var hashPassword = utf8.decode(base64.decode(data['password']));
        if (hashPassword == password) {
          return result.docs;
        } else {
          emit(state.copyWith(
              formStatus: SubmissionFailed(), errorMessage: 'Password Salah!'));
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
