import 'package:get/get.dart';
import 'package:privechat/app/data/repository/remote/auth_repository.dart';
import 'package:privechat/app/data/repository/remote/socket_repository.dart';
import 'package:privechat/app/routes/routes_app.dart';

class LoadingController extends GetxController {

  final AuthRepository _repository = Get.find<AuthRepository>();
  final SocketRepository _socketRepository = Get.find<SocketRepository>();

  //RxBool loggedIn = false.obs;
  //RxBool autenticando = false.obs;

  @override
  void onReady(){
    _init();
  }


  Future<void> _init()async{
      final bool isLogged = await _repository.isLoggedIn();
      if(isLogged){
       await _socketRepository.connect().whenComplete(() =>Get.offAllNamed(Routes.LANDING));
        
      }else{
        Get.offAllNamed(Routes.LOGIN);
      }
  }
 
  

  
}