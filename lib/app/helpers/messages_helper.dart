import 'package:dio/dio.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class MessagesHelper {
  static String apiUrl = '${Uri.base.origin}/api';

  static Future<List<types.Message>> getAllMessages() async {
    try {
      final response = await Dio().get(
        '$apiUrl/messages/getAllMessages',
      );

      if (response.data['ok']) {
        List<types.Message> messages = [];

        for (var item in response.data['messages']) {
          final message = types.TextMessage(
            author: types.User(
              id: item['userUid'],
              firstName: item['nickname'],
            ),
            id: const Uuid().v4(),
            text: item['content'],
            createdAt: DateTime.parse(item['createdAt']).millisecondsSinceEpoch,
          );

          messages.add(message);
        }

        return messages;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
