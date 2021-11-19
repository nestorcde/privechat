import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/modules/loading/loading_controller.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);
  //final LoadingController loadingCtrl = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: GetBuilder<LoadingController>(
            builder: (_) {
              _.onReady();
              return const Center(child: CircularProgressIndicator());
              }
            // FutureBuilder(
            //   future: checkLoginState(),
            //   builder: (context, snapshot) {
            //     return const Center(
            //       child: Text('Espere...'),
            //     );
            //   },
            // )
          ),
        );
  }

  // Future checkLoginState() async {
  //   // final authService = Provider.of<AuthService>(context, listen:  false);
  //   // final socketService = Provider.of<SocketService>(context);
  //   final autenticado = await loadingCtrl.isLoggedIn();
  //   if (autenticado!) {
  //     //socketService.connect();
  //     Get.offAllNamed(Routes.USUARIO);
  //   } else {
  //     Future.delayed(Duration.zero, () {
  //       Get.offAllNamed(Routes.LOGIN);
  //     });
  //   }
  // }
}
