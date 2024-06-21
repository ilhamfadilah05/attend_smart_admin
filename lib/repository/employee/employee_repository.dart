import 'package:attend_smart_admin/components/global_text_component.dart';
import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

Future<List<TableRow>> listDataTableEmployee(List<EmployeeModel> data) async {
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
          child: TextGlobal(message: dataEmployee.workingPosition ?? '-'),
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
                  onTap: () {},
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
                  onTap: () {},
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

  Future getEmployee() async {
    try {
      var result = await firestore.collection('employee').get();
      // print('object $result');
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

  Future addEmployee({required EmployeeModel employee}) async {
    try {
      var result =
          await firestore.collection('employee').add(employee.toJson());
      return result.get();
    } catch (e) {
      return e.toString();
    }
  }
}
