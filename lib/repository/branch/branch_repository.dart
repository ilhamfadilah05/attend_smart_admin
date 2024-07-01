import 'package:attend_smart_admin/bloc/branch/branch_bloc.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/branch_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

List<TableCell> listHeaderTableBranch = [
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          width: 10,
          child: TextGlobal(message: 'No', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: 'Nama', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: 'Lokasi', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
    padding: const EdgeInsets.all(10),
    child: Center(
      child: TextGlobal(
        message: 'Action',
        fontWeight: FontWeight.bold,
      ),
    ),
  ))
];

Future<List<TableRow>> listDataTableBranch(
    List<BranchModel> data, BuildContext context) async {
  return List.generate(data.length, (index) {
    var dataBranch = data[index];
    return TableRow(children: [
      TableCell(
        child: Container(
          width: 10,
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: '${index + 1}'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataBranch.name ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataBranch.address ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    context.go('/cabang/edit?id=${dataBranch.id}');
                  },
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Iconsax.edit_outline,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                dataBranch.isCentralBranch!
                    ? Container(
                        width: 20,
                      )
                    : InkWell(
                        onTap: () {
                          dialogQuestion(context, onTapYes: () {
                            context
                                .read<BranchBloc>()
                                .add(BranchDeleteEvent(id: dataBranch.id!));
                            Navigator.pop(context);
                          },
                              icon: const Icon(
                                Iconsax.trash_bold,
                                color: Colors.red,
                                size: 100,
                              ),
                              message:
                                  'Apakah anda yakin ingin menghapus ${dataBranch.name}?');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Iconsax.trash_outline,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      )
              ],
            )),
      )
    ]);
  });
}

class BranchRepository {
  final firestore = FirebaseFirestore.instance;

  Future getBranch(String idCompany) async {
    try {
      var result = await firestore
          .collection('branch')
          .where('id_company', isEqualTo: idCompany)
          .get();
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

  Future getBranchById({required String id}) async {
    try {
      var result = await firestore.collection('branch').doc(id).get();
      var data = result.data();
      return data;
    } catch (e) {
      return e.toString();
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

  Future deleteBranch({required String id}) async {
    try {
      await firestore.collection('branch').doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }
}
