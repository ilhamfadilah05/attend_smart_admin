import 'package:attend_smart_admin/models/broadcast_model.dart';
import 'package:attend_smart_admin/models/header_table_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BroadcastRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final listHeaderTable = <HeaderTableModel>[
    HeaderTableModel(key: 'image_url', label: '', width: 50, type: 'image'),
    HeaderTableModel(key: 'title', label: 'Judul', width: 420),
    HeaderTableModel(key: 'subtitle', label: 'Deskripsi', width: 420),
    HeaderTableModel(
      key: 'action',
      width: 150,
      label: '',
    ),
  ];

  Future getBroadcast(String idCompany, Map<String, dynamic> lasData) async {
    try {
      var result = await firestore
          .collection('broadcast')
          .where('id_company', isEqualTo: idCompany)
          .get();

      var listBroadcast = [];
      for (var i = 0; i < result.docs.length; i++) {
        var data = result.docs[i].data();
        listBroadcast.add(data);
      }

      return listBroadcast;
    } catch (e) {
      return e.toString();
    }
  }

  Future getTotalDataBroadcast(String idCompany) async {
    try {
      var result = firestore
          .collection('broadcast')
          .where('id_company', isEqualTo: idCompany)
          .count();

      var z = await result.get();
      var b = z.count;

      return b;
    } catch (e) {
      return e.toString();
    }
  }

  Future getBroadcastById({required String id}) async {
    try {
      var result = await firestore.collection('broadcast').doc(id).get();
      var data = result.data();
      return data;
    } catch (e) {
      return e.toString();
    }
  }

  Future addBroadcast({required BroadcastModel broadcast}) async {
    try {
      await firestore
          .collection('broadcast')
          .doc(broadcast.id)
          .set(broadcast.toJson());

      return broadcast.toJson();
    } catch (e) {
      return e.toString();
    }
  }

  Future addBroadcastSend({required BroadcastSendModel broadcast}) async {
    try {
      await firestore
          .collection('broadcast-send')
          .doc(broadcast.id)
          .set(broadcast.toJsonSendNotif());

      return broadcast.toJsonSendNotif();
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteBroadcast({required String id}) async {
    try {
      await firestore.collection('broadcast').doc(id).delete();
    } catch (e) {
      return e.toString();
    }
  }
}
