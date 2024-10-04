import 'package:attend_smart_admin/models/employee_model.dart';
import 'package:attend_smart_admin/models/header_table_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static final listHeaderTable = <HeaderTableModel>[
    HeaderTableModel(key: 'image', label: '', width: 50, type: 'image'),
    HeaderTableModel(key: 'name', label: 'Nama', width: 150),
    HeaderTableModel(key: 'nohp', label: 'No. Handphone', width: 150),
    HeaderTableModel(key: 'department', label: 'Jabatan', width: 150),
    HeaderTableModel(key: 'name_branch', label: 'Cabang', width: 200),
    HeaderTableModel(key: 'working_status', label: 'Status', width: 100),
    HeaderTableModel(
      key: 'action',
      width: 150,
      label: '',
    ),
  ];

  Future getEmployee(String idCompany) async {
    try {
      var result = await firestore
          .collection('employee')
          .where('id_company', isEqualTo: idCompany)
          .get();
      var listEmployee = [];
      for (var i = 0; i < result.docs.length; i++) {
        var data = result.docs[i].data();
        listEmployee.add(data);
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

  Future deleteAccount({required String id}) async {
    try {
      await firestore.collection('account').doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }
}
