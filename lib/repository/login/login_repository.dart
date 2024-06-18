import 'package:attend_smart_admin/bloc/login/login_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future login({required LoginBloc event, required String email}) async {
    try {
      var result = await firestore
          .collection('user')
          .where('email', isEqualTo: email)
          .get();

      if (result.docs.isEmpty) {
        event.add(LoginFailed(message: 'Akun Tidak Ditemukan!'));
      } else {
        return result.docs;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
