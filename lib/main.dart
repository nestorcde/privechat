import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:privechat/app/modules/loading/loading_page.dart';
import 'package:privechat/app/routes/pages_app.dart';
import 'package:privechat/app/ui/theme/theme_app.dart';
import 'package:privechat/app/utils/dependency_injection.dart';

void main()async {
  await DependencyInjection.init();
  await initializeDateFormatting();
  runApp(
    GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        defaultTransition: Transition.fade,
        getPages: AppPages.pages,
        home: const LoadingPage(),
        
    )
  );
}