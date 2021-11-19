import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privechat/app/modules/loading/loading_page.dart';
import 'package:privechat/app/routes/pages_app.dart';
import 'package:privechat/app/ui/theme/theme_app.dart';
import 'package:privechat/app/utils/dependency_injection.dart';

void main() {
  DependencyInjection.init();
  runApp(
    GetMaterialApp(
        debugShowCheckedModeBanner: false,
        //initialRoute: Routes.LOADING,
        theme: appThemeData,
        defaultTransition: Transition.fade,
        //initialBinding: HomeBinding(),
        getPages: AppPages.pages,
        home: const LoadingPage(),
        //initialBinding: LoadingBinding(),
        
    )
  );
}