import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/socket_controller.dart';
import '../controllers/state_controller.dart';
import '../global/values.dart';
import '../helpers/user_helper.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool _canChangeNickname = false;

  final socketController = Get.find<SocketController>();
  final stateController = Get.find<StateController>();

  @override
  void initState() {
    super.initState();
    socketController.socket.on('total-user', _listenUserConnect);
  }

  void _listenUserConnect(dynamic payload) async {
    final totalUsers = await UserHelper.getTotalUsers();
    stateController.totalUsers.value = totalUsers;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.23,
            child: Container(
              color: const Color(0xFF242430),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Spacer(flex: 2),
                  const CircleAvatar(
                    radius: 60,
                    child: Icon(
                      Icons.person_rounded,
                      size: 60,
                    ),
                  ),
                  const Spacer(),
                  _canChangeNickname
                      ? Padding(
                          padding: const EdgeInsets.all(defaultPadding),
                          child: TextField(
                            onSubmitted: (value) async {
                              await stateController.changeNickname(value);
                              setState(() => _canChangeNickname = false);
                            },
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Nuevo nickname',
                            ),
                          ),
                        )
                      : Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                stateController.user.value.firstName!,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              IconButton(
                                onPressed: () => setState(() =>
                                    _canChangeNickname = !_canChangeNickname),
                                icon: const Icon(Icons.edit_rounded),
                              )
                            ],
                          ),
                        ),
                  Obx(
                    () => Text(
                      stateController.user.value.id,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
          const Spacer(),
          Obx(() =>
              Text('Usuarios en línea: ${stateController.totalUsers.value}')),
          const SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
