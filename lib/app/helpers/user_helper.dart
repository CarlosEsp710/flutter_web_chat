import 'package:dio/dio.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:platform_device_id/platform_device_id.dart';

class UserHelper {
  static String apiUrl = '${Uri.base.origin}/api';

  static Future<types.User?> getUserData() async {
    try {
      String? deviceId = await PlatformDeviceId.getDeviceId;

      if (deviceId == null) {
        return null;
      }

      final response = await Dio().post(
        '$apiUrl/users/getUser',
        data: {"device_id": deviceId},
      );

      final status = response.data['ok'];

      if (status) {
        final userData = response.data['user'];

        return types.User(
          id: userData['uid'],
          firstName: userData['nickname'],
        );
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<types.User> changeNickname(String uid, String nickname) async {
    final response = await Dio().post(
      '$apiUrl/users/updateNickname',
      data: {"nickname": nickname, "uid": uid},
    );

    final status = response.data['ok'];

    if (status) {
      final userData = response.data['user'];

      return types.User(
        id: userData['uid'],
        firstName: userData['nickname'],
      );
    } else {
      throw Exception('Error al actualizar el usuario');
    }
  }

  static Future<int> getTotalUsers() async {
    final response = await Dio().get('$apiUrl/users/getTotalUsers');

    final status = response.data['ok'];

    if (status) {
      return response.data['total'];
    } else {
      return 0;
    }
  }
}
