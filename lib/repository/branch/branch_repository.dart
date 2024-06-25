import 'package:attend_smart_admin/models/branch_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchRepository {
  final firestore = FirebaseFirestore.instance;

  Future getBranch() async {
    try {
      var result = await firestore.collection('branch').get();
      var listBranch = <BranchModel>[];
      for (var i = 0; i < result.docs.length; i++) {
        var data = result.docs[i].data();
        listBranch.add(BranchModel.fromJson(data));
      }

      return listBranch;
    } catch (e) {
      return e;
    }
  }

  Future addBranch({required BranchModel branch}) async {
    try {
      await firestore.collection('branch').doc(branch.id).set(branch.toJson());

      return branch.toJson();
    } catch (e) {
      return e.toString();
    }
  }
}
