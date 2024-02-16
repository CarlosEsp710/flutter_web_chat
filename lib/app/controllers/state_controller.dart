import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';

import '../helpers/user_helper.dart';
import '../pages/chat_page.dart';
import '../pages/error_page.dart';
import 'socket_controller.dart';

class StateController extends GetxController {
  late Rx<types.User> user;
  RxInt totalUsers = 0.obs;

  @override
  void onReady() async {
    super.onReady();
    await setUser();
  }

  Future<void> setUser() async {
    final res = await UserHelper.getUserData();

    if (res == null) {
      Get.to(() => const ErrorPage(error: 'No se pudo acceder al servidor'));
      return;
    }

    user = Rx<types.User>(res);
    Get.put(SocketController());
    Get.offAll(() => const ChatPage());
  }

  Future<void> changeNickname(String nickname) async {
    final res = await UserHelper.changeNickname(user.value.id, nickname);
    user.value = res;
    update();
  }
}
