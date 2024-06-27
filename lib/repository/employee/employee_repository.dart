import 'package:attend_smart_admin/bloc/employee/employee_bloc.dart';
import 'package:attend_smart_admin/components/global_dialog_component.dart';
import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';

List<TableCell> listHeaderTableEmployee = [
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
          child: TextGlobal(
              message: 'No. Handphone', fontWeight: FontWeight.bold))),
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
          child: TextGlobal(message: 'Status', fontWeight: FontWeight.bold))),
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

Future<List<TableRow>> listDataTableEmployee(
    List<EmployeeModel> data, BuildContext context) async {
  return List.generate(data.length, (index) {
    var dataEmployee = data[index];
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
          child: TextGlobal(message: dataEmployee.name ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataEmployee.nohp ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataEmployee.department ?? '-'),
        ),
      ),
      TableCell(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: TextGlobal(message: dataEmployee.nameBranch ?? '-'),
        ),
      ),
      TableCell(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: TextGlobal(message: dataEmployee.workingStatus ?? '-'),
      )),
      TableCell(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    context.go('/karyawan/edit?id=${dataEmployee.id}');
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
                          .read<EmployeeBloc>()
                          .add(EmployeeDeleteEvent(id: dataEmployee.id!));
                      Navigator.pop(context);
                    },
                        icon: const Icon(
                          Iconsax.trash_bold,
                          color: Colors.red,
                          size: 100,
                        ),
                        message:
                            'Apakah anda yakin ingin menghapus ${dataEmployee.name}?');
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

class EmployeeRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future getEmployee(String idCompany) async {
    try {
      var result = await firestore
          .collection('employee')
          .where('id_company', isEqualTo: idCompany)
          .get();
      var listEmployee = <EmployeeModel>[];
      for (var i = 0; i < result.docs.length; i++) {
        var data = result.docs[i].data();
        listEmployee.add(EmployeeModel.fromJson(data));
      }

      return listEmployee;
    } catch (e) {
      return e;
    }
  }

  Future getEmployeeById({required String id}) async {
    try {
      var result = await firestore.collection('employee').doc(id).get();
      var data = result.data();
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future addEmployee({required EmployeeModel employee}) async {
    try {
      await firestore
          .collection('employee')
          .doc(employee.id)
          .set(employee.toJson());

      return employee.toJson();
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteEmployee({required String id}) async {
    try {
      await firestore.collection('employee').doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }
}
