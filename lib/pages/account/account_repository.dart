import 'dart:convert';

import 'package:attend_smart_admin/models/account_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<AccountModel?> init() async {
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (sharedPrefs.getString('token') != null) {
      return AccountModel.fromJson(jsonDecode(sharedPrefs.getString('token')!));
    } else {
      return null;
    }
  }

  Future<void> createAccount(AccountModel account) async {
    var result = await firestore
        .collection('account')
        .doc(account.id)
        .set(account.toJson());
    return result;
  }
}
