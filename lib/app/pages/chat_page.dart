import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../controllers/socket_controller.dart';
import '../controllers/state_controller.dart';
import '../global/values.dart';
import '../helpers/messages_helper.dart';
import '../widgets/responsive.dart';
import '../widgets/side_menu.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final socketController = Get.find<SocketController>();
  final stateController = Get.find<StateController>();

  List<types.Message> messages = [];

  @override
  void initState() {
    super.initState();
    socketController.connect(stateController.user.value.id);
    socketController.socket.on('private-message', _listenMessage);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
              backgroundColor: bgColor,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(Icons.menu),
                  );
                },
              ),
            ),
      drawer: const SideMenu(),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: maxWidth),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  flex: 2,
                  child: SideMenu(),
                ),
              if (Responsive.isDesktop(context))
                const SizedBox(width: defaultPadding),
              Expanded(
                flex: 7,
                child: Chat(
                  messages: messages,
                  onSendPressed: _handleSendPressed,
                  showUserAvatars: true,
                  showUserNames: true,
                  scrollPhysics: const BouncingScrollPhysics(),
                  user: stateController.user.value,
                  theme: const DefaultChatTheme(
                    seenIcon: Text(
                      'read',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                    inputElevation: 2,
                    inputMargin: EdgeInsets.all(8),
                    backgroundColor: bgColorSoft,
                    inputBorderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    socketController.emit('private-message', {
      'userUid': stateController.user.value.id,
      'nickname': stateController.user.value.firstName,
      'content': message.text,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  void _listenMessage(dynamic payload) {
    final message = types.TextMessage(
      author: types.User(
        id: payload['userUid'],
        firstName: payload['nickname'],
      ),
      id: const Uuid().v4(),
      text: payload['content'],
      createdAt: DateTime.parse(payload['createdAt']).millisecondsSinceEpoch,
    );

    if (mounted) {
      setState(() {
        messages.insert(0, message);
      });
    }
  }

  void _loadHistory() async {
    List<types.Message> history = await MessagesHelper.getAllMessages();

    if (mounted) {
      setState(() {
        messages.insertAll(0, history);
      });
    }
  }
}
