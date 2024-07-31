import 'package:attend_smart_admin/bloc/submission/submission_bloc.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/submission_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

List<TableCell> listHeaderTableSubmission = [
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          width: 10,
          child: TextGlobal(message: 'No', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(
              message: 'Nama Karyawan', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: 'Tipe', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: 'Tanggal', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: 'Status', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child:
              TextGlobal(message: 'Keterangan', fontWeight: FontWeight.bold))),
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

Future<List<TableRow>> listDataTableSubmission(
    List<SubmissionModel> data, BuildContext context) async {
  return List.generate(data.length, (index) {
    var dataSubmission = data[index];
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
          child: TextGlobal(message: dataSubmission.nameEmployee ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataSubmission.type ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(
              message:
                  "${DateFormat('dd MMM yyyy').format(DateTime.parse(dataSubmission.dateStart!))} s/d ${DateFormat('dd MMM yyyy').format(DateTime.parse(dataSubmission.dateEnd!))}"),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: dataSubmission.status == 'pending'
                  ? Colors.amber
                  : dataSubmission.status == 'approved'
                      ? Colors.green
                      : Colors.grey),
          child: TextGlobal(
            message: dataSubmission.status ?? '-',
            colorText: Colors.white,
          ),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataSubmission.reason ?? '-'),
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
                    context.go('/pengajuan/edit?id=${dataSubmission.id}');
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
                InkWell(
                  onTap: () {
                    dialogQuestion(context, onTapYes: () {
                      context
                          .read<SubmissionBloc>()
                          .add(SubmissionDeleteEvent(id: dataSubmission.id!));
                      Navigator.pop(context);
                    },
                        icon: const Icon(
                          Iconsax.trash_bold,
                          color: Colors.red,
                          size: 100,
                        ),
                        message:
                            'Apakah anda yakin ingin menghapus ${dataSubmission.nameEmployee}?');
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

class SubmissionRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getSubmission(String idCompany, Map<String, dynamic> lasData) async {
    try {
      var result = await firestore
          .collection('submission')
          .where('id_company', isEqualTo: idCompany)
          .get();

      var listSubmission = <SubmissionModel>[];
      for (var i = 0; i < result.docs.length; i++) {
        var data = result.docs[i].data();
        listSubmission.add(SubmissionModel.fromJson(data));
      }

      return listSubmission;
    } catch (e) {
      return e.toString();
    }
  }

  Future getTotalDataSubmission(String idCompany) async {
    try {
      var result = firestore
          .collection('submission')
          .where('id_company', isEqualTo: idCompany)
          .count();

      var z = await result.get();
      var b = z.count;

      return b;
    } catch (e) {
      return e.toString();
    }
  }

  Future getSubmissionById({required String id}) async {
    try {
      var result = await firestore.collection('submission').doc(id).get();
      var data = result.data();
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future addSubmission({required SubmissionModel submission}) async {
    try {
      await firestore
          .collection('submission')
          .doc(submission.id)
          .set(submission.toJson());

      return submission.toJson();
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteSubmission({required String id}) async {
    try {
      await firestore.collection('submission').doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }
}
