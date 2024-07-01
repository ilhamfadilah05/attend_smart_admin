import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/history_attend_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

List<TableCell> listHeaderTableHistoryAttend = [
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
          child: TextGlobal(message: 'Jabatan', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: 'Cabang', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(
              message: 'Lokasi Absen', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child:
              TextGlobal(message: 'Tipe Absen', fontWeight: FontWeight.bold))),
  TableCell(
      child: Container(
          padding: const EdgeInsets.all(10),
          child:
              TextGlobal(message: 'Waktu Absen', fontWeight: FontWeight.bold))),
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

Future<List<TableRow>> listDataTableHistoryAttend(
    List<HistoryAttendModel> data, BuildContext context) async {
  return List.generate(data.length, (index) {
    var dataHistoryAttend = data[index];
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
          child: TextGlobal(message: dataHistoryAttend.nameEmployee ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataHistoryAttend.department ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataHistoryAttend.nameBranch ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataHistoryAttend.locationAttend ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataHistoryAttend.tipeAbsen ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(
              message:
                  "${dataHistoryAttend.dateAttend}, ${dataHistoryAttend.timeAttend}"),
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
                    context.go('/cabang/edit?id=${dataHistoryAttend.id}');
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
                    // dialogQuestion(context, onTapYes: () {
                    //   context.read<HistoryAttendBloc>().add(
                    //       HistoryAttendDeleteEvent(
                    //           id: dataHistoryAttend.id!));
                    //   Navigator.pop(context);
                    // },
                    //     icon: const Icon(
                    //       Iconsax.trash_bold,
                    //       color: Colors.red,
                    //       size: 100,
                    //     ),
                    //     message:
                    //         'Apakah anda yakin ingin menghapus ${dataHistoryAttend.name}?');
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

class HistoryAttendRepository {
  final firestore = FirebaseFirestore.instance;

  Future getHistoryAttend(String idCompany) async {
    try {
      var result = await firestore
          .collection('history-attend')
          .where('id_company', isEqualTo: idCompany)
          .get();
      var listHistoryAttend = <HistoryAttendModel>[];
      for (var i = 0; i < result.docs.length; i++) {
        var data = result.docs[i].data();
        listHistoryAttend.add(HistoryAttendModel.fromJson(data));
      }

      return listHistoryAttend;
    } catch (e) {
      return e;
    }
  }

  Future getHistoryAttendById({required String id}) async {
    try {
      var result = await firestore.collection('history-attend').doc(id).get();
      var data = result.data();
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future addHistoryAttend({required HistoryAttendModel historyAttend}) async {
    try {
      await firestore
          .collection('history-attend')
          .doc(historyAttend.id)
          .set(historyAttend.toJson());

      return historyAttend.toJson();
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteHistoryAttend({required String id}) async {
    try {
      await firestore.collection('history-attend').doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }
}
