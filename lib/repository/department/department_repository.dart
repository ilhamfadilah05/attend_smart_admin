import 'package:attend_smart_admin/bloc/department/department_bloc.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/department_model.dart';
import 'package:attend_smart_admin/models/header_table_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

List<TableCell> listHeaderTableDepartment = [
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
    child: Center(
      child: TextGlobal(
        message: 'Action',
        fontWeight: FontWeight.bold,
      ),
    ),
  ))
];

Future<List<TableRow>> listDataTableDepartment(
    List<DepartmentModel> data, BuildContext context) async {
  return List.generate(data.length, (index) {
    var dataDepartment = data[index];
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
          child: TextGlobal(message: dataDepartment.name ?? '-'),
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
                    context.go('/department/edit?id=${dataDepartment.id}');
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
                          .read<DepartmentBloc>()
                          .add(DepartmentDeleteEvent(id: dataDepartment.id!));
                      Navigator.pop(context);
                    },
                        icon: const Icon(
                          Iconsax.trash_bold,
                          color: Colors.red,
                          size: 100,
                        ),
                        message:
                            'Apakah anda yakin ingin menghapus ${dataDepartment.name}?');
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

class DepartmentRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final listHeaderTable = <HeaderTableModel>[
    HeaderTableModel(key: '', label: '', width: 100),
    HeaderTableModel(key: 'name', label: 'Nama', width: 800),
    HeaderTableModel(
      key: 'action',
      width: 150,
      label: '',
    ),
  ];

  Future getDepartment(String idCompany, Map<String, dynamic> lasData) async {
    try {
      var result = await firestore
          .collection('department')
          .where('id_company', isEqualTo: idCompany)
          .get();

      var listDepartment = [];
      for (var i = 0; i < result.docs.length; i++) {
        var data = result.docs[i].data();
        listDepartment.add(data);
      }

      return listDepartment;
    } catch (e) {
      return e.toString();
    }
  }

  Future getTotalDataDepartment(String idCompany) async {
    try {
      var result = firestore
          .collection('department')
          .where('id_company', isEqualTo: idCompany)
          .count();

      var z = await result.get();
      var b = z.count;

      return b;
    } catch (e) {
      return e.toString();
    }
  }

  Future getDepartmentById({required String id}) async {
    try {
      var result = await firestore.collection('department').doc(id).get();
      var data = result.data();
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future addDepartment({required DepartmentModel department}) async {
    try {
      await firestore
          .collection('department')
          .doc(department.id)
          .set(department.toJson());

      return department.toJson();
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteDepartment({required String id}) async {
    try {
      await firestore.collection('department').doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }
}
