import 'dart:convert';

import 'package:attend_smart_admin/models/broadcast_model.dart';
import 'package:flutter/material.dart';
// import 'package:googleapis/cloudfunctions/v2.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "attend-smart-01",
      "private_key_id": "2217c6e3e5cd5f3fa5b107c455748fcb8a2d3d65",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDWLP5qoAp4NEQ1\nZiQJlPDcS2cPDbQnBxU/Bljw+CDEtjEtYGz9xCN9aFUbuZ9Jbs8HRcIL04tuW8cd\ndHo01fiD0du5ZxMyekQrJ1vXpYjIfAIDW/hgynPC3MccoDCZWp5jQGhkXPorvbvz\nAsR4Sn+QtH3LJx/z17UTm30DGaErvfWKh+bqSCDuNxEMOzyHgOHHHox4aWqFVoQE\nMl8hkELvwSUiVfbzA3mczZsw4rLuiL8UJ/vc3jiUCfGNPDfAvnCeXJE5AKGIknYc\nRTEO6wmge6CGMYfsxD11g+tqgUsIrnboMaIh9dVE+fW6dI3Q2dG13udVoacugs9G\n3Nj0d7ylAgMBAAECggEANAIKiMVSrYRRoN7r9tiwUWpM/RqQid6eMeb+b4ttV58/\nW1u8M7YugQw2CIy/aZNLGiK+H2WQCO0n8ZbgexaPaaEq+D9Xqc0HYyxEUN4dVEPK\nsFqjuotG54V5o1Gh44deCU9xWhe61ybUbksYfvZmOjMeDdgzGeEiUz/RcFCHsulU\n2Z8fNmdmIemyH8wdYLCzPAZSiqBmBXVjqdi3tCZKY2MpPOSiedaUwY9SAlifHrxi\nKiHN22R+hgITpHNAotYWtsQI/5fqtL9A+yvXWe/8iUT6N4PtuWLiBFlWZlkJ8daL\nznes8ivfC90rr8+7Pbwq3R9Yhko+8QEwIb2IX8WM+QKBgQDzYiFvcp3Gz7SZxgxl\n7ASieKxFWwhHXwXfx3jwkaHK5B+a5CizbmYIEicJpsZVMMLXzLx0ujXQtUVR5CVb\n/rteRiH31IMIwo81GZziQc6crNlLm7OOSCpI05kLvtKIfMWNxnMUHLSrJ+nYzDmO\n9Wr165vqp84xZE/5pXfrCiTr/QKBgQDhR0IR/LZzyappUckKvOUopDBjOerXSAZt\nBHoPN6V+Q4/eBuw3nFM+jdi4XnJbBmgBe7FTfMiB00PKcgQMWU6n66zVz27giRQr\nQD8SSt8jNmAmM6VUi4ymW3ZTOhtgnJNE9bFLBybR4HqRFNSkY4tB1hsVM0PMaPm2\n1J03mfMvyQKBgQDQcPqxuDfoTXsfN77mi3xsqWzg+VXdykP9o5iwcAlg+n8W6NDy\n21oHD4TffzXdQCWfLHk6f0AXvyffOsXERCW0V9w/pIGUvwxnLchu/m01QdPYLUFa\nWfPc61vn80XcHwASrCNi1jLlYwmj40Roa0dv1plyHsU5B/B2noBVjBqTAQKBgCrP\nRcjxQyLBwfZ9qjy2JL4SZXeVvADpGP+CiEd4BaT25dIFcsImnNMYVYTDvet6Ti1p\n+gqpfdjd8tX30LkgB4h1isSexK06n3CQpuus+rZQUPkxe0uTsUizvMqYEjfLyVij\nb+uYElJz3BbR5I7Qs9fw/fiLY2jm0f1ibfXw9XuxAoGAUoswKdPCpOCNfOHRa/6P\npnVadK1h6CJS6a6CzQhSU6DzcdTPdPuNHob75fYVdPR9wJvg2VLbUFQY/LrB694w\n9BIZiKtWvvZviwo/D9fAuGehAjd45vfEP0dopchaqaY4vqqZQ+B6wyixebV5GCxX\nVDUjX9w3ZvcKauD5IOniqFM=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "attend-smart-fcm@attend-smart-01.iam.gserviceaccount.com",
      "client_id": "112881484196344450623",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/attend-smart-fcm%40attend-smart-01.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotificationToEmployee(
      BroadcastSendModel dataNotif, BuildContext context) async {
    final String accessTokenFCM = await getAccessToken();
    String endpointFCM =
        "https://fcm.googleapis.com/v1/projects/attend-smart-01/messages:send";

    var message = {
      'message': {
        'token': dataNotif.tokenNotif,
        'notification': {
          'title': dataNotif.title,
          'body': dataNotif.body,
          'image': dataNotif.image
        },
        'data': {
          'type': 'broadcast',
          'id': dataNotif.id,
          'id_broadcast': dataNotif.idBroadcast,
          'id_employee': dataNotif.idEmployee,
          'name_employee': dataNotif.nameEmployee,
          'title': dataNotif.title,
          'body': dataNotif.body,
          'image': dataNotif.image,
          'token_notif': dataNotif.tokenNotif,
          'is_read': 'false'
        }
      }
    };

    final http.Response response = await http.post(Uri.parse(endpointFCM),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessTokenFCM',
        },
        body: json.encode(message));

    if (response.statusCode == 200) {
      print("Notification sended");
    } else {
      print("Notification failed : ${jsonEncode(accessTokenFCM)}");
    }
  }
}
